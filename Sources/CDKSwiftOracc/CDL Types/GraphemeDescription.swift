//
//  GraphemeDescription.swift
//  CDKSwiftOracc: Cuneiform Documents for Swift
//  Copyright (C) 2018 Chaitanya Kanchan
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.


import Foundation

/// Datatype enumerating a localized reading of a cuneiform sign from a tablet.

public enum CuneiformSignReading {
    
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
    
    /// Debug value; shouldn't appear under normal circumstances and shouldn't be used directly.
    case null
    
    /// Various kinds of cuneiform sign graphical variations.
    public enum Modifier {
        case curved, flat, gunu, šešig, tenu, nutillu, zidatenu, kabatenu, verticallyReflected, horizontallyReflected, rotated(Int), variant
        
        case Allograph(String)
        case FormVariant(String)
    }
}

extension CuneiformSignReading.Modifier {
    
    /// Returns `CuneiformSign.Modifier` for validly encoded GDL modifiers; returns `nil` if modifier can't be found
    static func modifierFromString(_ s: String) -> CuneiformSignReading.Modifier? {
        switch s {
        case "c": return CuneiformSignReading.Modifier.curved
        case "f": return CuneiformSignReading.Modifier.flat
        case "g": return CuneiformSignReading.Modifier.gunu
        case "s": return CuneiformSignReading.Modifier.šešig
        case "t": return CuneiformSignReading.Modifier.tenu
        case "n": return CuneiformSignReading.Modifier.nutillu
        case "z": return CuneiformSignReading.Modifier.zidatenu
        case "k": return CuneiformSignReading.Modifier.kabatenu
        case "r": return CuneiformSignReading.Modifier.verticallyReflected
        case "h": return CuneiformSignReading.Modifier.horizontallyReflected
        case "v": return CuneiformSignReading.Modifier.variant
            
        default: return nil
        }
    }
}



/// Position of a determinative
public enum Determinative: String {
    case pre, post
}

/// Preservation status of a sign
public enum Preservation: String {
    case preserved, damaged, missing
}

/// Break information - needs refactoring
public enum BreakPosition {
    case start, end
}


/// Base structure for representing cuneiform signs (graphemes) decoded from the grapheme description language. Enables sign-by-sign cuneiform and transliteration functionality. Simplified implementation of the GDL specification, found [here](https://github.com/oracc/oracc/blob/master/doc/ns/gdl/1.0/gdl.xdf)

public struct GraphemeDescription {
    /// Cuneiform glyph in UTF-8
    public let graphemeUTF8: String?
    
    /// Sign reading metadata
    public let sign: CuneiformSignReading
    
    /// True if the sign is a logogram; used for formatting purposes.
    public let isLogogram: Bool
    
    /// Sign preservation
    public let preservation: Preservation
    
    /// If broken, whether it's at the start or the end
    public let breakPosition: BreakPosition?
    
    /// If a determinative, what role it plays (usually 'semantic'), and position it occupies
    public let isDeterminative: Determinative?

    /// If a logogram consists of multiple graphemes, it seems to be represented by this
    public let group: [GraphemeDescription]?
    
    /// Seems to represent subelements in a name
    public let gdl: [GraphemeDescription]?
    
    /// Some kind of container for further elements
    public let sequence: [GraphemeDescription]?
    
    /// If defined, a string that separates this character from the next one.
    public let delim: String?
    
    /// Creates a single grapheme description containing the Unicode cuneiform, sign metadata and delimiter information for formatting
    public init(graphemeUTF8: String?, sign: CuneiformSignReading, isLogogram: Bool, preservation: Preservation = Preservation.preserved, breakPosition: BreakPosition?, isDeterminative: Determinative?, group: [GraphemeDescription]?, gdl: [GraphemeDescription]?, sequence: [GraphemeDescription]?, delimiter: String?) {
        self.graphemeUTF8 = graphemeUTF8
        self.sign = sign
        self.isLogogram = isLogogram
        self.preservation = preservation
        self.breakPosition = breakPosition
        self.isDeterminative = isDeterminative
        self.group = group
        self.gdl = gdl
        self.sequence = sequence
        self.delim = delimiter
    }
}

extension GraphemeDescription: Decodable {
    enum CodingKeys: String, CodingKey {
        case graphemeUTF8 = "gdl_utf8"
        
        case signValue = "v"
        case signName = "s"
        
        
        case form = "form"
        case modifiers = "mods"
        
        case role = "role"
        
        case preservation = "break"
        case determinative = "det"
        case position = "pos"
        
        case group = "group"
        case gdl = "gdl"
        case sequence = "seq"
        case delim = "delim"
        
        case breakStart, breakEnd
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let graphemeUTF8 = try container.decodeIfPresent(String.self, forKey: .graphemeUTF8)
        
        //Decoding sign type
        let cuneiformSign: CuneiformSignReading
        if let namedSign = try container.decodeIfPresent(String.self, forKey: .signName){
            // Make a simple logographically read sign
            cuneiformSign = CuneiformSignReading.name(namedSign)
        } else if let signValue = try container.decodeIfPresent(String.self, forKey: .signValue) {
            // Make a simple syllabically read sign
            cuneiformSign = CuneiformSignReading.value(signValue)
        } else if let form = try container.decodeIfPresent(String.self, forKey: .form) {
            // More complex readings associated with the 'form' field.
            
            // If a cuneiform sign with modifiers, create annotated sign
            if let modifiersArray = try container.decodeIfPresent([[String: String]].self, forKey: .modifiers) {
                
                var modifiers = [String:String]()
                for modifier in modifiersArray {
                    modifiers.merge(modifier, uniquingKeysWith: {(_, new) in new})
                }
                
                let base = modifiers["b"] ?? "x"
                var mods = [CuneiformSignReading.Modifier]()

                if let formVariant = modifiers["f"] {
                    mods.append(.FormVariant(formVariant))
                }
                
                if let modifier = modifiers["m"] {
                    if let modifierType = CuneiformSignReading.Modifier.modifierFromString(modifier) {
                        mods.append(modifierType)
                    }
                }
                
                if let allograph = modifiers["a"] {
                    mods.append(.Allograph(allograph))
                }
                cuneiformSign = CuneiformSignReading.formVariant(form: form, base: base, modifier: mods)
            } else {
                cuneiformSign = CuneiformSignReading.formVariant(form: form, base: form, modifier: [])
            }
        } else {
            cuneiformSign = CuneiformSignReading.null
        }
        
        // Get preservation quality
        let preservation: Preservation
        if let breakDescription = try container.decodeIfPresent(String.self, forKey: .preservation) {
            preservation = Preservation(rawValue: breakDescription) ?? .preserved
        } else {
            preservation = .preserved
        }
        
        // Get sign break position
        let breakPosition: BreakPosition?
        if container.contains(.breakStart) {
            breakPosition = .start
        } else if container.contains(.breakEnd) {
            breakPosition = .end
        } else {
            breakPosition = nil
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
        
        let delimiter: String?
        
        if let decodedDelimiter = try container.decodeIfPresent(String.self, forKey: .delim) {
            if decodedDelimiter == "--" {
                delimiter = "—"
            } else {
                delimiter = decodedDelimiter
            }
        } else {
            delimiter = nil
        }
        
        // Init
        self.init(graphemeUTF8: graphemeUTF8, sign: cuneiformSign, isLogogram: isLogogram, preservation: preservation, breakPosition: breakPosition, isDeterminative: determinative, group: group, gdl: gdl, sequence: sequence, delimiter: delimiter)
    }
}

extension GraphemeDescription: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(graphemeUTF8, forKey: .graphemeUTF8)
        
        switch self.sign {
        case .value(let signValue):
            try container.encode(signValue, forKey: .signValue)
        case .name(let signName):
            try container.encode(signName, forKey: .signName)
        case .number(_):
        //TODO: - Implement numbers
            break
        case .formVariant(let form, let base, let modifier):
            
            try container.encode(form, forKey: .form)
            var formDictionary = [[String: String]]()
            formDictionary.append(["b": base])
            
            if !modifier.isEmpty {
                for modifier in modifier {
                    switch modifier {
                    case .Allograph(let a):
                        formDictionary.append(["a": a])
                    case .FormVariant(let f):
                        formDictionary.append(["f": f])
                    default:
                        break
                    }
                }
            }
            
            try container.encode(formDictionary, forKey: .modifiers)
        case .null:
            break
        }
        
        switch self.preservation {
        case .preserved:
            break
        case .damaged:
            try container.encode(preservation.rawValue, forKey: .preservation)
        case .missing:
            try container.encode(preservation.rawValue, forKey: .preservation)
        }
        
        // Breakposition not implemented yet
        
        if isLogogram {
            try container.encode("logo", forKey: .role)
        }
        
        if let determinative = self.isDeterminative {
            try container.encode("semantic", forKey: .determinative)
            try container.encode(determinative.rawValue, forKey: .position)
        }
        
        if let group = self.group {
            try container.encode(group, forKey: .group)
        }
        
        if let seq = self.sequence {
            try container.encode(seq, forKey: .sequence)
        }
        
        if let gdl = self.gdl {
            try container.encode(gdl, forKey: .gdl)
        }
        
        if let delimiter = self.delim {
            if delimiter == "—" {
                try container.encode("--", forKey: .delim)
            } else {
                try container.encode(delimiter, forKey: .delim)
            }
        }
        
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

