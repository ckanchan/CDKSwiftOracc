//
//  GraphemeDescription+Codable.swift
//  CDKSwiftOracc: Cuneiform Documents for Swift
//  Copyright (C) 2019 Chaitanya Kanchan
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
        case .number(value: let value, sexagesimal: let sexagesimal):
            try container.encode(value.asString, forKey: .form)
            try container.encode(sexagesimal, forKey: .sexagesimal)
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
        
        #warning("Breakposition not implemented yet")
        
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
        
        if let delimiter = self.delim {
            if delimiter == "—" {
                try container.encode("--", forKey: .delim)
            } else {
                try container.encode(delimiter, forKey: .delim)
            }
        }
        
    }
}
