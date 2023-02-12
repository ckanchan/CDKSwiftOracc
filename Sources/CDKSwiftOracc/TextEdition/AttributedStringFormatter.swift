//
//  AttributedStringFormatter.swift
//  CDKSwiftOracc: Cuneiform Documents for Swift
//  Copyright (C) 2023 Chaitanya Kanchan
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

public struct FormattingAttributes: AttributeScope {
    public let formatting: FormattingValue
}

public enum FormattingValue: AttributedStringKey {
    public typealias Value = [TextEditionFormatting]
    public static let name = "formatting"
}

@available(macOS 12, iOS 15, *)
public extension AttributeDynamicLookup {
    subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<FormattingAttributes, T>) -> T {
        return self[T.self]
    }
}

@available(macOS 12, iOS 15, *)
public extension OraccTextEdition {
    func normalisedAttributedString() -> AttributedString {
        var normalisedAttributedString = AttributedString()
        for node in self.cdl {
            normalisedAttributedString.append(node.normalisedAttributedString())
        }
        return normalisedAttributedString
    }
}

@available(macOS 12, iOS 15, *)
extension OraccCDLNode {
    func formattedDiscontinuity(_ discontinuity: Discontinuity) -> AttributedString? {
        var formatting = AttributeContainer()
        let discontinuityString: String?
        switch discontinuity.type {
        case .obverse:
            formatting.formatting = [.editorial, .bold]
            discontinuityString = "Obverse: \n"
            
        case .linestart:
            formatting.formatting = [.editorial]
            discontinuityString = "\n\(discontinuity.label ?? "") "
            
        case .reverse:
            formatting.formatting = [.editorial, .bold]
            discontinuityString = "\n\n\n Reverse: \n"
            
        default:
            discontinuityString = nil
        }
        
        if let discontinuityString {
           return AttributedString(discontinuityString, attributes: formatting)
        } else {
            return nil
        }
    }
    
    func normalisedAttributedString() -> AttributedString {
        var str = AttributedString()
        
        switch self {
        case .l(let lemma):
            let attributedLemma: AttributedString
            if let norm = lemma.wordForm.normalisation {
                var translationAttrs = lemma.getExtendedAttributeValues()
                translationAttrs.formatting = [.italic]
                attributedLemma = AttributedString(
                    "\(norm) ",
                    attributes: translationAttrs
                )
            } else {
                let damagedAttribute = AttributeContainer([.formatting: [TextEditionFormatting.damaged]])
                attributedLemma = AttributedString(
                    "x ",
                    attributes: damagedAttribute
                )
            }
            str.append(attributedLemma)
            
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.normalisedAttributedString())
            }
            
        case .d(let discontinuity):
            let discontinuityString = formattedDiscontinuity(discontinuity)
            if let discontinuityString {
                str.append(discontinuityString)
            }
            
        case .linkbase(_):
            break
        }
        return str
    }
    
    func transliteratedAttributedString() -> AttributedString {
        var str = AttributedString()
        switch self {
        case .l(let lemma):
            for grapheme in lemma.wordForm.graphemeDescriptions {
                var graphemeStr = grapheme.transliteratedAttributedString()
                graphemeStr.mergeAttributes(lemma.getExtendedAttributeValues())
                str.append(graphemeStr)
            }
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.transliteratedAttributedString())
            }
            
        case .d(let discontinuity):
            let discontinuityString = formattedDiscontinuity(discontinuity)
            if let discontinuityString {
                str.append(discontinuityString)
            }
            
        case .linkbase:
            break
        }
        
        return str
    }
}

@available(macOS 12, iOS 15, *)
extension GraphemeDescription {
    func transliteratedAttributedString() -> AttributedString {
        
        func formatAs(_ damage: Preservation, sign: AttributedString) -> AttributedString {
            let startBreak: AttributedString?
            let endBreak: AttributedString?
            
            switch damage {
            case .damaged:
                startBreak = AttributedString("⸢")
                endBreak = AttributedString("⸣")
            case .missing:
                startBreak = AttributedString("[")
                endBreak = AttributedString("]")
            case .preserved:
                startBreak = nil
                endBreak = nil
            }
            
            if let startBreak, let endBreak {
                return (startBreak + sign + endBreak)
            } else {
                return sign
            }
        }
        
        
        var str = AttributedString()
        func delimit() {
            let delimiter = AttributedString(delim ?? " ")
            str.append(delimiter)
        }
        
        if let determinative = isDeterminative {
            var syllable = AttributedString()
            if let components {
                if case let Components.sequence(graphemes) = components {
                    for grapheme in graphemes {
                        syllable.append(grapheme.transliteratedAttributedString())
                    }
                }
            }
            
            let delim: AttributedString
            switch determinative {
            case .pre:
                delim = AttributedString()
            case .post:
                delim = AttributedString(" ")
            }
                     
            syllable.formatting = [.superscript]
            str.append(syllable)
            str.append(delim)
        } else if let components {
            components.items.forEach{str.append($0.transliteratedAttributedString())}
        } else {
            if case let Preservation.damaged(breakPosition) = self.preservation {
                if case Preservation.BreakPosition.start = breakPosition {
                    let startBreak = AttributedString("[")
                    str.append(startBreak)
                }
            }
            
            switch self.sign {
                
            case .value(let syllable): //Syllabographic
                var akkSyllable = AttributedString(syllable)
                
                switch self.preservation {
                case .damaged, .missing:
                    akkSyllable.formatting = [.damaged]
                    str.append(formatAs(self.preservation, sign: akkSyllable))
            
                case .preserved:
                    akkSyllable.formatting = [.italic]
                    str.append(akkSyllable)
                }
                
                delimit()
                
            case .name(let log): //Logographic
                var logogram = AttributedString(log)
                
                switch self.preservation {
                case .damaged, .missing:
                    logogram.formatting = [.damagedLogogram]
                    str.append(formatAs(self.preservation, sign: logogram))
                    
                case .preserved:
                    str.append(logogram)
                }
                
                delimit()
                
            case .number(value: let value, sexagesimal: _):
                str.append(AttributedString(value.asString))
                delimit()
                
            case .formVariant(form: _, base: let base, _):
                var specialForm = AttributedString(base)

                switch self.preservation {
                case .damaged, .missing:
                    if self.isLogogram {
                        specialForm.formatting = [.damagedLogogram]
                    } else {
                        specialForm.formatting = [.damaged]
                    }
                    
                    str.append(formatAs(self.preservation, sign: specialForm))
                    
                case .preserved:
                    if self.isLogogram {
                        str.append(specialForm)
                    } else {
                        specialForm.formatting = [.italic]
                        str.append(specialForm)
                    }
                }
                
                delimit()
                
            case .null:
                break
            }
        }
        
        if case let Preservation.damaged(breakPosition) = self.preservation {
            if case Preservation.BreakPosition.start = breakPosition {
                let endBreak = AttributedString("]")
                str.append(endBreak)
            }
        }
        
        return str
    }
}
