//
//  OraccNSFormatter.swift
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

#if os(macOS)
    import Cocoa
    
    let noFormatting = [NSAttributedStringKey.font: NSFont.systemFont(ofSize: NSFont.systemFontSize)]
    
    
    /// Formats strings and text using Assyriological conventions.
@available(OSX 10.11, *)
public extension OraccTextEdition {
        
        /// Returns a string formatted with Akkadian normalisation.
        public func formattedNormalisation(withFont font: NSFont) -> NSAttributedString {
            let str = NSMutableAttributedString(string: "")
            
            for node in self.cdl {
                str.append(node.normalisedAttributedString(withFont: font))
            }
            
            return str
        }
        
        /// Returns a formatted transliteration.
        public func formattedTransliteration(withFont font: NSFont) -> NSAttributedString {
            let str = NSMutableAttributedString(string: "")
            for node in self.cdl {
                str.append(node.transliteratedAttributedString(withFont: font))
            }
            
            return str
        }
    }
    
    extension NSFont {
        func getItalicFont() -> NSFont {
            let fontDsc = self.fontDescriptor
            let italicDsc = NSFontDescriptor.SymbolicTraits.italic
            let italicfntDsc = fontDsc.withSymbolicTraits(italicDsc)
            let systemFontDsc = NSFont.systemFont(ofSize: self.pointSize).fontDescriptor
            
            return NSFont(descriptor: italicfntDsc, size: self.pointSize) ?? NSFont(descriptor: systemFontDsc, size: self.pointSize)!
        }
    }
    
    extension GraphemeDescription {
        public func transliteratedAttributedString(withFont font: NSFont) -> NSAttributedString {
            let str = NSMutableAttributedString(string: "")
            //Formatting attributes
            let italicFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font.getItalicFont()]
            let superscriptFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.superscript: 1]
            let damagedFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font.getItalicFont(), NSAttributedStringKey.foregroundColor: NSColor.gray]
            
            //Determinatives
            if let determinative = isDeterminative {
                let syllable = NSMutableAttributedString(string: "")
                if let sequence = sequence {
                    for grapheme in sequence {
                        syllable.append(grapheme.transliteratedAttributedString(withFont: font))
                    }
                }
                
                let delim: NSAttributedString
                switch determinative {
                case .pre:
                    delim = NSAttributedString(string: "")
                case .post:
                    delim = NSAttributedString(string: " ")
                }
                
                syllable.addAttributes(superscriptFormatting, range: NSMakeRange(0, syllable.string.count))
                
                str.append(syllable)
                str.append(delim)
            } else if let group = group { //Recursing
                group.forEach{str.append($0.transliteratedAttributedString(withFont: font))}
            } else if let gdl = gdl {
                gdl.forEach{str.append($0.transliteratedAttributedString(withFont: font))}
            } else if let sequence = sequence {
                sequence.forEach{str.append($0.transliteratedAttributedString(withFont: font))}
            } else {
                if case let Preservation.damaged(breakPosition) = self.preservation {
                    if case Preservation.BreakPosition.start = breakPosition {
                        let startBreak = NSAttributedString(string: "[", attributes: noFormatting)
                        str.append(startBreak)
                    }
                }
                
                
                switch self.sign {
                case .value(let syllable): // Syllabographic
                    let akkSyllable: NSAttributedString

                    switch self.preservation {
                    case .damaged:
                        let startBreak = NSAttributedString(string: "⸢", attributes: noFormatting)
                        str.append(startBreak)
                        akkSyllable = NSAttributedString(string: syllable,
                                                         attributes: damagedFormatting)
                        str.append(akkSyllable)
                        let endBreak = NSAttributedString(string: "⸣", attributes: noFormatting)
                        str.append(endBreak)
                    case .missing:
                        akkSyllable = NSAttributedString(string: syllable,
                                                         attributes: damagedFormatting)
                        str.append(akkSyllable)
                    case .preserved:
                        akkSyllable = NSAttributedString(string: syllable,
                                                         attributes: italicFormatting)
                        str.append(akkSyllable)
                    }
                    
                    
                    
                    let delimiter = NSAttributedString(
                        string: delim ?? " ",
                        attributes: noFormatting
                    )
                    str.append(delimiter)
                    
                case .name(let log): // Logographic
                    let logogram = NSAttributedString(
                        string: log,
                        attributes: noFormatting)
                    str.append(logogram)
                    let delimiter = NSAttributedString(
                        string: delim ?? " ",
                        attributes: noFormatting)
                    str.append(delimiter)
                    
                case .number(let number):
                    let num = NSAttributedString(
                        string: String(number.value),
                        attributes: noFormatting)
                    str.append(num)
                    let delimiter = NSAttributedString(
                        string: delim ?? " ",
                        attributes: noFormatting)
                    str.append(delimiter)
                    
                case .formVariant(_, let base, _):
                    let specialForm: NSAttributedString
                    if self.isLogogram {
                        specialForm = NSAttributedString(string: base, attributes: noFormatting)
                    } else {
                        specialForm = NSAttributedString(string: base, attributes: italicFormatting)
                    }
                    str.append(specialForm)
                    let delimiter = NSAttributedString(
                        string: delim ?? " ",
                        attributes: noFormatting)
                    str.append(delimiter)
                    
                case .null:
                    break
                }
            }
            
            if case let Preservation.damaged(breakPosition) = self.preservation {
                if case Preservation.BreakPosition.start = breakPosition {
                    let endBreak = NSAttributedString(string: "]", attributes: noFormatting)
                    str.append(endBreak)
                }
            }
            
            return str
        }
    }
    
@available(OSX 10.11, *)
extension OraccCDLNode {
        func normalisedAttributedString(withFont font: NSFont) -> NSAttributedString {
            
            let str: NSMutableAttributedString = NSMutableAttributedString(string: "")
            let editorialFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: NSFont.monospacedDigitSystemFont(ofSize: NSFont.smallSystemFontSize, weight: NSFont.Weight.regular)]
            let editorialBoldFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: NSFont.monospacedDigitSystemFont(ofSize: NSFont.smallSystemFontSize, weight: NSFont.Weight.bold)]
            
            switch self {
            case .l(let lemma):
                switch lemma.wordForm.language {
                case .Akkadian(_):
                    let attrStr: NSMutableAttributedString
                    if let norm = lemma.wordForm.normalisation {
                        var translationAttrs = lemma.getExtendedAttributes()
                        translationAttrs[.font] = font.getItalicFont()
                        attrStr = NSMutableAttributedString(
                            string: "\(norm) ",
                            attributes: translationAttrs
                        )
                    } else {
                        attrStr = NSMutableAttributedString(
                            string: "x ",
                            attributes: editorialFormatting
                        )
                    }
                    str.append(attrStr)
                    
                case .Sumerian(_):
                    let attrStr: NSAttributedString
                    if let norm = lemma.wordForm.normalisation {
                        attrStr = NSAttributedString(
                            string: "\(norm) ",
                            attributes: nil
                        )
                    } else {
                        attrStr = NSAttributedString(
                            string: "x ",
                            attributes: editorialFormatting
                        )
                    }
                    str.append(attrStr)
                    
                default:
                    break
                }
                
                
            case .c(let chunk):
                for node in chunk.cdl {
                    str.append(node.normalisedAttributedString(withFont: font))
                }
                
            case .d(let discontinuity):
                switch discontinuity.type {
                case .obverse:
                    let obv = NSAttributedString(string: "Obverse: \n", attributes: editorialBoldFormatting)
                    str.append(obv)
                case .linestart:
                    let ln = NSAttributedString(string: "\n\(discontinuity.label ?? "") ", attributes: editorialFormatting)
                    str.append(ln)
                case .reverse:
                    let rev = NSAttributedString(string: "\n\n\n Reverse: \n", attributes: editorialBoldFormatting)
                    str.append(rev)
                default:
                    break
                }
            case .linkbase(_):
                break
            }
            
            return NSAttributedString(attributedString: str)
        }
        
        
        func transliteratedAttributedString(withFont font: NSFont) -> NSAttributedString {
            
            let editorialFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: NSFont.monospacedDigitSystemFont(ofSize: NSFont.smallSystemFontSize, weight: NSFont.Weight.regular)]
            let editorialBoldFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: NSFont.monospacedDigitSystemFont(ofSize: NSFont.smallSystemFontSize, weight: NSFont.Weight.bold)]
            
            let str = NSMutableAttributedString(string: "")
            switch self {
            case .l(let lemma):
                for grapheme in lemma.wordForm.graphemeDescriptions {
                    str.append(grapheme.transliteratedAttributedString(withFont: font))
                }
            case .c(let chunk):
                for node in chunk.cdl {
                    str.append(node.transliteratedAttributedString(withFont: font))
                }
            case .d(let discontinuity):
                switch discontinuity.type {
                case .obverse:
                    let obv = NSAttributedString(string: "Obverse: \n", attributes: editorialBoldFormatting)
                    str.append(obv)
                case .linestart:
                    let ln = NSAttributedString(string: "\n\(discontinuity.label ?? "") ", attributes: editorialFormatting)
                    str.append(ln)
                case .reverse:
                    let rev = NSAttributedString(string: "\n\n\n Reverse: \n", attributes: editorialBoldFormatting)
                    str.append(rev)
                default:
                    break
                }
            case .linkbase(_):
                break
            }
            
            return NSAttributedString(attributedString: str)
        }
    }

    
#endif
