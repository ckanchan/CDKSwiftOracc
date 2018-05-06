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

extension Float {
    /// Supports encoding, decoding and formatting for sexagesimal numbers
    var asString: String {
        if let wholeInt = Int.init(exactly: self) {
            return String(wholeInt)
        } else {
            return String(self)
        }
    }
}


/// Datatype enumerating a localized reading of a cuneiform sign from a tablet.

public enum CuneiformSignReading {
    
    /// Sign read with syllabic value.
    case value(String)
    
    /// Sign read with name. Usually indicates a logogram in Akkadian texts.
    case name(String)
    
    /// Sexagesimal number
    case number(value: Float, sexagesimal: String)
    
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
public enum Preservation {
    public enum BreakPosition {
        case start(String), end(String), undefined
    }
    
    case preserved
    case damaged(BreakPosition)
    case missing
}


/// Presents a single interface to any signs that are comprised of subsigns, whilst preserving the 'group|gdl|seq' metadata
public enum Components {
    /// If a logogram consists of multiple graphemes, it seems to be represented by this
    case group([GraphemeDescription])
    
    /// Seems to represent subelements in a name
    case gdl([GraphemeDescription])
    
    /// Some kind of container for further elements
    case sequence([GraphemeDescription])
    
    var items: [GraphemeDescription] {
        switch self {
        case .group(let items):
            return items
        case .gdl(let items):
            return items
        case .sequence(let items):
            return items
        }
    }
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
    
    
    /// If a determinative, what role it plays (usually 'semantic'), and position it occupies
    public let isDeterminative: Determinative?
    
    /// Present if the sign contains subunits
    public let components: Components?
    
    /// If defined, a string that separates this character from the next one.
    public let delim: String?
    
    /// Creates a single grapheme description containing the Unicode cuneiform, sign metadata and delimiter information for formatting
    public init(graphemeUTF8: String?, sign: CuneiformSignReading, isLogogram: Bool, preservation: Preservation = Preservation.preserved, isDeterminative: Determinative?, components: Components?, delimiter: String?) {
        self.graphemeUTF8 = graphemeUTF8
        self.sign = sign
        self.isLogogram = isLogogram
        self.preservation = preservation
        self.isDeterminative = isDeterminative
        self.components = components
        self.delim = delimiter
    }
}

extension GraphemeDescription: Decodable {
    enum CodingKeys: String, CodingKey {
        case graphemeUTF8 = "gdl_utf8"
        
        case signValue = "v"
        case signName = "s"
        case sexagesimal = "sexified"
        
        
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
            // If 'sexified' field present, encode as a number
            if let sexified = try container.decodeIfPresent(String.self, forKey: .sexagesimal) {
                let value: Float
                if let form = try container.decodeIfPresent(String.self, forKey: .form) {
                    if let formNumber = Float(form) {
                        value = formNumber
                    } else {value = -1}
                } else {value = -1}
                
                cuneiformSign = CuneiformSignReading.number(value: value, sexagesimal: sexified)
            }
                
                
                // If a cuneiform sign with modifiers, create annotated sign
            else if let modifiersArray = try container.decodeIfPresent([[String: String]].self, forKey: .modifiers) {
                
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
            switch breakDescription {
            case "missing":
                preservation = .missing
                
            case "damaged":
                // Get sign break position
                let breakPosition: Preservation.BreakPosition
                if container.contains(.breakEnd) {
                    let metadata = try container.decode(String.self, forKey: .breakEnd)
                    breakPosition = .end(metadata)
                } else if container.contains(.breakStart) {
                    let metadata = try container.decode(String.self, forKey: .breakStart)
                    breakPosition = .start(metadata)
                } else {
                    breakPosition = .undefined
                }
                
                preservation = .damaged(breakPosition)
                
                
            default:
                preservation = .preserved
            }

        } else {
            preservation = .preserved
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
        let group: [GraphemeDescription]?
        let sequence: [GraphemeDescription]?
        let gdl: [GraphemeDescription]?
        
        switch cuneiformSign {
        case .number:
            group = nil
            sequence = nil
            gdl = nil
        default:
            group = try container.decodeIfPresent([GraphemeDescription].self, forKey: .group)
            sequence = try container.decodeIfPresent([GraphemeDescription].self, forKey: .sequence)
            gdl = try container.decodeIfPresent([GraphemeDescription].self, forKey: .gdl)
        }
        
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
        
        let components: Components?
        
        if let group = group {
            components = Components.group(group)
        } else if let sequence = sequence {
            components = Components.sequence(sequence)
        } else if let gdl = gdl {
            components = Components.gdl(gdl)
        } else {
            components = nil
        }
        
        
        // Init
        self.init(graphemeUTF8: graphemeUTF8, sign: cuneiformSign, isLogogram: isLogogram, preservation: preservation, isDeterminative: determinative, components: components, delimiter: delimiter)
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
        case .number(let number):
            try container.encode(number.value.asString, forKey: .form)
            try container.encode(number.sexagesimal, forKey: .sexagesimal)
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
            
        case .damaged(let breakPosition):
            switch breakPosition {
            case .start(let metadata):
                try container.encode(metadata, forKey: .breakStart)
            case .end(let metadata):
                try container.encode(metadata, forKey: .breakEnd)
            default:
                break
            }
            
            try container.encode("damaged", forKey: .preservation)
        case .missing:
            try container.encode("missing", forKey: .preservation)
        }
        
        // Breakposition not implemented yet
        
        if isLogogram {
            try container.encode("logo", forKey: .role)
        }
        
        if let determinative = self.isDeterminative {
            try container.encode("semantic", forKey: .determinative)
            try container.encode(determinative.rawValue, forKey: .position)
        }
        
        if let components = self.components {
            switch components {
            case .gdl(let gdl):
                try container.encode(gdl, forKey: .gdl)
            case .group(let group):
                try container.encode(group, forKey: .group)
            case .sequence(let seq):
                try container.encode(seq, forKey: .sequence)
            }
        }
        
//        if let group = self.group {
//            try container.encode(group, forKey: .group)
//        }
//
//        if let seq = self.sequence {
//            try container.encode(seq, forKey: .sequence)
//        }
//
//        if let gdl = self.gdl {
//            try container.encode(gdl, forKey: .gdl)
//        }
        
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
        if let components = components {
            for grapheme in components.items {
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
        //Determinatives
        if let determinative = isDeterminative {
            var syllable = ""
            
            if let components = components {
                if case let Components.sequence(sequence) = components {
                    var sequenceGraphemes = ""
                    for grapheme in sequence {
                        sequenceGraphemes.append(grapheme.transliteration)
                    }
                    syllable.append(sequenceGraphemes.trimmingCharacters(in: CharacterSet(charactersIn: "{ }")))
                }
            }
            
            syllable = "{\(syllable)}"
            
            let delim: String
            switch determinative {
            case .pre:
                delim = ""
            case .post:
                delim = ""
            }

            str.append(syllable)
            str.append(delim)

       
        } else if let components = components {
            components.items.forEach{str.append($0.transliteration)}
        } else {
            if case let Preservation.damaged(breakPosition) = self.preservation {
                if case Preservation.BreakPosition.start = breakPosition {
                    str.append("[")
                }
            }
            
            
            switch self.sign {
            case .value(let syllable): // Syllabographic
                switch self.preservation {
                case .damaged:
                    str.append("⸢\(syllable)⸣")
                case .missing:
                    str.append("[\(syllable)]")
                case .preserved:
                    str.append(syllable)
                }
                str.append(delim ?? " ")
                
            case .name(let log): // Logographic
                str.append("\(log)\(delim ?? " ")")
                
            case .number(let number):
                str.append("\(number.value.asString)\(delim ?? " ")")
                
            case .formVariant(_, let base, _):

                if self.isLogogram {
                    str.append("{\(base)}\(delim ?? " ")")
                } else {
                    str.append("\(base)\(delim ?? " ")")
                }

                
            case .null:
                break
            }
        }
        
        if case let Preservation.damaged(breakPosition) = self.preservation {
            if case Preservation.BreakPosition.start = breakPosition {
                str.append("]")
            }
        }
        
        return str
    }
}

