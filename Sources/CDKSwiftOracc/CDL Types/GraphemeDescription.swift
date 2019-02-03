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

public extension GraphemeDescription {
    
    /// A simplified initialiser that creates a basic grapheme with no complex metadata.
    /// - Parameter syllable: transliterated syllable in Roman script
    /// - Parameter delimiter: separator between this sign and the next. Supply the empty string if at the end of a word.
    /// - Parameter cuneifier: function that converts a transliterated syllable into a cuneiform glyph.
    
    init(syllable: String, delimiter: String, cuneifier: ((String) -> String?)) {
        let sign: CuneiformSignReading
        var logogram = false
        if syllable.uppercased() == syllable {
            // It's a logogram, encode it as such
            sign = .name(String(syllable))
            logogram = true
        } else {
            sign = .value(String(syllable))
        }
        
        self.init(graphemeUTF8: cuneifier(String(syllable)), sign: sign, isLogogram: logogram, isDeterminative: nil, components: nil, delimiter: delimiter)
    }
}
