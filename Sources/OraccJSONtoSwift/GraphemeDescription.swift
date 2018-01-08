//
//  GraphemeDescription.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 08/01/2018.
//

import Foundation

/// Datatype enumerating a specific reading of a cuneiform sign.
public enum CuneiformSign {
    
    /// Sign read with syllabic value.
    case value(String)
    
    /// Sign read with name. Usually indicates a logogram in Akkadian texts.
    case name(String)
    
    /// Sexagesimal number
    case number(String)
    
    /** Complex sign form variant
     - Parameter form: simple text representation of the complex sign.
     - Parameter base: basic sign value component
     - Parameter modifier: array of cuneiform sign modifiers, represented as `CuneiformSign.Modifier`
    */
    
    case formVariant(form: String, base: String, modifier: [Modifier])
    
    /// Debug value, shouldn't appear under normal circumstances and shouldn't be used directly.
    case null
    
    /// Various kinds of cuneiform sign graphical variations.
    public enum Modifier {
        case curved, flat, gunu, šešig, tenu, nutillu, zidatenu, kabatenu, verticallyReflected, horizontallyReflected, rotated(Int), variant
        
        case Allograph(String)
        case FormVariant(String)
    }
}


extension CuneiformSign.Modifier {
    static func modifierFromString(_ s: String) -> CuneiformSign.Modifier? {
        switch s {
        case "c": return CuneiformSign.Modifier.curved
        case "f": return CuneiformSign.Modifier.flat
        case "g": return CuneiformSign.Modifier.gunu
        case "s": return CuneiformSign.Modifier.šešig
        case "t": return CuneiformSign.Modifier.tenu
        case "n": return CuneiformSign.Modifier.nutillu
        case "z": return CuneiformSign.Modifier.zidatenu
        case "k": return CuneiformSign.Modifier.kabatenu
        case "r": return CuneiformSign.Modifier.verticallyReflected
        case "h": return CuneiformSign.Modifier.horizontallyReflected
        case "v": return CuneiformSign.Modifier.variant
            
        default: return nil
        }
    }
}

/// Position of a determinative
public enum Determinative: String {
    case pre, post
}


/// Base structure for representing cuneiform signs (graphemes) decoded from the grapheme description language. Enables sign-by-sign cuneiform and transliteration functionality.

public struct GraphemeDescription {
    /// Cuneiform glyph in UTF-8
    public let graphemeUTF8: String?
    
    /// Graphical description of the sign.
    public let sign: CuneiformSign
    
    /// True if the sign is a logogram. Useful for formatting purposes.
    public let isLogogram: Bool
    
    /// If a determinative, what role it plays (usually 'semantic'), and position it occupies
    public let isDeterminative: Determinative?

    /// If a logogram consists of multiple graphemes, it seems to be represented by this
    public let group: [GraphemeDescription]?
    
    /// This seems to represent subelements in a name
    public let gdl: [GraphemeDescription]?
    
    /// Some kind of container for further elements
    public let sequence: [GraphemeDescription]?
    
    /// If defined, a string that separates this character from the next one.
    public let delim: String?
}

extension GraphemeDescription: Decodable {
    enum CodingKeys: String, CodingKey {
        case graphemeUTF8 = "gdl_utf8"
        
        case signValue = "v"
        case signName = "s"
        
        
        case form = "form"
        case modifiers = "mods"
        
        case role = "role"
        
        case determinative = "det"
        case position = "pos"
        
        case group = "group"
        case gdl = "gdl"
        case sequence = "seq"
        case delim = "delim"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let graphemeUTF8 = try container.decodeIfPresent(String.self, forKey: .graphemeUTF8)
        
        //Decoding sign type
        let cuneiformSign: CuneiformSign
        if let namedSign = try container.decodeIfPresent(String.self, forKey: .signName){
            // Make a simple logographically read sign
            cuneiformSign = CuneiformSign.name(namedSign)
        } else if let signValue = try container.decodeIfPresent(String.self, forKey: .signValue) {
            // Make a simple syllabically read sign
            cuneiformSign = CuneiformSign.value(signValue)
        } else if let form = try container.decodeIfPresent(String.self, forKey: .form) {
            // More complex readings associated with the 'form' field.
            
            // If a cuneiform sign with modifiers, create annotated sign
            if let modifiers = try container.decodeIfPresent([String: String].self, forKey: .modifiers) {
                let base = modifiers["b"] ?? "x"
                var mods = [CuneiformSign.Modifier]()

                if let formVariant = modifiers["f"] {
                    mods.append(.FormVariant(formVariant))
                }
                
                if let modifier = modifiers["m"] {
                    if let modifierType = CuneiformSign.Modifier.modifierFromString(modifier) {
                        mods.append(modifierType)
                    }
                }
                
                if let allograph = modifiers["a"] {
                    mods.append(.Allograph(allograph))
                }
                cuneiformSign = CuneiformSign.formVariant(form: form, base: base, modifier: mods)
            } else {
                cuneiformSign = CuneiformSign.formVariant(form: form, base: form, modifier: [])
            }
        } else {
            cuneiformSign = CuneiformSign.null
        }
        
        // Check if grapheme is a logogram
        let isLogogram: Bool
        if let role = try container.decodeIfPresent(String.self, forKey: .role) {
            if role == "logo" {
                isLogogram = true
            } else {
                isLogogram = false
            }
        } else {
            isLogogram = false
        }
        
        // Check if grapheme is a determinative
        var determinative: Determinative? = nil
        if let _ = try container.decodeIfPresent(String.self, forKey: .determinative) {
            if let position = try container.decodeIfPresent(String.self, forKey: .position) {
                determinative = Determinative.init(rawValue: position)
            }
        }
        
        // Recursive calls
        let group = try container.decodeIfPresent([GraphemeDescription].self, forKey: .group)
        let sequence = try container.decodeIfPresent([GraphemeDescription].self, forKey: .sequence)
        let gdl = try container.decodeIfPresent([GraphemeDescription].self, forKey: .gdl)
        
        let delimiter = try container.decodeIfPresent(String.self, forKey: .delim)
        
        // Init
        self.init(graphemeUTF8: graphemeUTF8, sign: cuneiformSign, isLogogram: isLogogram, isDeterminative: determinative, group: group, gdl: gdl, sequence: sequence, delim: delimiter)
    }
}

public extension GraphemeDescription {
    
    /// A computed property that returns cuneiform.
    public var cuneiform: String {
        var str = ""
        if let gdl = gdl {
            for grapheme in gdl {
                str.append(grapheme.cuneiform)
            }
        } else if let sequence = sequence {
            for grapheme in sequence {
                str.append(grapheme.cuneiform)
            }
        } else if let group = group {
            for grapheme in group {
                str.append(grapheme.cuneiform)
            }
        } else {
            str.append(graphemeUTF8 ?? "")
        }
        
        return str
    }
    
    /// A computed property that returns transliteration as an unformatted string.
    public var transliteration: String {
        var str = ""
        if let gdl = gdl {
            for grapheme in gdl {
                str.append(grapheme.transliteration)
            }
        } else if let sequence = sequence {
            for grapheme in sequence {
                str.append(grapheme.transliteration)
            }
        } else if let group = group {
            for grapheme in group {
                str.append(grapheme.transliteration)
            }
        } else {
            var signStr = ""
            
            switch sign {
            case .value(let v):
                signStr.append(v)
            case .name(let name):
                signStr.append(name)
            case .number(let number):
                signStr.append(number)
            case .formVariant(_, let base, _):
                signStr.append(base)
            case .null:
                signStr.append("")
            }
            
            signStr.append(delim ?? " ")
            str.append(signStr)
        }
        return str
    }
}




//// MARK :- Text generation extension
//public extension GraphemeDescription {
//    /// A computed property that returns cuneiform
//    public var cuneiform: String {
//        var str = ""
//        if let gdl = gdl {
//            for grapheme in gdl {
//                str.append(grapheme.cuneiform)
//            }
//        } else if let seq = seq {
//            for grapheme in seq {
//                str.append(grapheme.cuneiform)
//            }
//        } else if let utf8 = graphemeUTF8 {
//            str.append(utf8)
//        } else {
//            str.append("")
//        }
//
//        return str
//    }
//
//    /// A computed property that returns sign transliteration
//    public var transliteration: String {
//        var str = ""
//        if let gdl = gdl {
//            for grapheme in gdl {
//                str.append(grapheme.transliteration)
//            }
//        } else if let seq = seq {
//            for grapheme in seq {
//                str.append(grapheme.transliteration)
//            }
//        } else if let group = group {
//            for grapheme in group {
//                str.append(grapheme.transliteration)
//            }
//        } else if let v = v {
//            let delimiter = delim ?? " "
//            str.append(v)
//            str.append(delimiter)
//        } else if let s = s {
//            let delimiter = delim ?? " "
//            str.append(s)
//            str.append(delimiter)
//        } else if let form = form {
//            let delimiter = delim ?? " "
//            str.append(form)
//            str.append(delimiter)
//        }
//
//        else {
//            str.append(" ")
//        }
//
//        return str
//    }
//}

