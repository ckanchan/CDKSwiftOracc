//
//  TextEditionFormatting.swift
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

public extension NSAttributedStringKey {
    public static var formatting: NSAttributedStringKey {
        return self.init("formatting")
    }
}


/// Provides formatting hints
public struct TextEditionFormatting: OptionSet {
    public let rawValue: Int
    
    public static let editorial = TextEditionFormatting(rawValue: 1 << 0)
    public static let bold = TextEditionFormatting(rawValue: 1 << 1)
    public static let italic = TextEditionFormatting(rawValue: 1 << 2)
    public static let superscript = TextEditionFormatting(rawValue: 1 << 3)
    public static let damaged = TextEditionFormatting(rawValue: 1 << 4)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
}


extension OraccTextEdition {
    
    /// Returns a normalisation of the text edition with formatting hints as a platform-independent NSAttributedString
    public func normalised() -> NSAttributedString {
        let str = NSMutableAttributedString(string: "")
        for node in self.cdl {
            str.append(node.normalised())
        }
        return NSAttributedString(attributedString: str)
    }
    
    /// Returns a transliteration of the text edition with formatting hints as a platform-independent NSAttributedString
    public func transliterated() -> NSAttributedString {
        let str = NSMutableAttributedString(string: "")
        for node in self.cdl {
            str.append(node.transliterated())
        }
        return NSAttributedString(attributedString: str)
    }
}

extension OraccCDLNode {
    
    /// Returns a portable normalised string with platform-independent formatting attributes encoded under the `Formatting` key. These strings can be transformed with the `.render()` function for display.
    func normalised() -> NSAttributedString {
        let str = NSMutableAttributedString(string: "")
        
        switch self {
        case .l(let lemma):
            let attrStr: NSMutableAttributedString
            if let norm = lemma.wordForm.normalisation {
                var translationAttrs = lemma.getExtendedAttributes()
                translationAttrs[.formatting] = TextEditionFormatting([.italic]).rawValue
                attrStr = NSMutableAttributedString(
                    string: "\(norm) ",
                    attributes: translationAttrs
                )
            } else {
                attrStr = NSMutableAttributedString(
                    string: "x ",
                    attributes: [.formatting: TextEditionFormatting([.damaged]).rawValue]
                )
            }
            
            str.append(attrStr)
            
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.normalised())
            }
            
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                let obv = NSAttributedString(string: "Obverse: \n", attributes: [.formatting: TextEditionFormatting([.editorial, .bold]).rawValue])
                str.append(obv)
            case .linestart:
                let ln = NSAttributedString(string: "\n\(discontinuity.label ?? "") ", attributes: [.formatting: TextEditionFormatting([.editorial]).rawValue])
                str.append(ln)
            case .reverse:
                let rev = NSAttributedString(string: "\n\n\n Reverse: \n", attributes: [.formatting: TextEditionFormatting([.editorial, .bold]).rawValue])
                str.append(rev)
            default:
                break
            }
            
        case .linkbase(_):
            break
        }
        return NSAttributedString(attributedString: str)
    }

    func transliterated() -> NSAttributedString {
        let str = NSMutableAttributedString(string: "")
        switch self {
        case .l(let lemma):
            for grapheme in lemma.wordForm.graphemeDescriptions {
                let sstr = NSMutableAttributedString(string: "")
                let attribs = lemma.getExtendedAttributes()
                
                sstr.append(grapheme.transliterated())
                sstr.addAttributes(attribs, range: NSMakeRange(0, sstr.string.count))
                str.append(sstr)
            }
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.transliterated())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                let obv = NSAttributedString(string: "Obverse: \n", attributes: [.formatting: TextEditionFormatting([.editorial, .bold]).rawValue])
                str.append(obv)
            case .linestart:
                let ln = NSAttributedString(string: "\n\(discontinuity.label ?? "") ", attributes: [.formatting: TextEditionFormatting([.editorial]).rawValue])
                str.append(ln)
            case .reverse:
                let rev = NSAttributedString(string: "\n\n\n Reverse: \n", attributes: [.formatting: TextEditionFormatting([.editorial, .bold]).rawValue])
                str.append(rev)
            default:
                break
            }
        case .linkbase(_):
            break
        }
        return str
    }
    
}


extension GraphemeDescription {
     func transliterated() -> NSAttributedString {
        let italicFormatting = [NSAttributedStringKey.formatting: TextEditionFormatting([.italic]).rawValue]
        let superscriptFormatting = [NSAttributedStringKey.formatting: TextEditionFormatting([.superscript]).rawValue]
        let damagedFormatting = [NSAttributedStringKey.formatting: TextEditionFormatting([.damaged]).rawValue]
        let noFormatting = [NSAttributedStringKey.formatting: 0]
        
        let str = NSMutableAttributedString(string: "")
        
        //Determinatives
        if let determinative = isDeterminative {
            let syllable = NSMutableAttributedString(string: "")
            if let components = components {
                if case let Components.sequence(sequence) = components {
                    for grapheme in sequence {
                        syllable.append(grapheme.transliterated())
                    }
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
            
        } else if let components = components {
            components.items.forEach{str.append($0.transliterated())}
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
                    let startBreak = NSAttributedString(string: "[", attributes: noFormatting)
                    str.append(startBreak)
                    akkSyllable = NSAttributedString(string: syllable,
                                                     attributes: damagedFormatting)
                    str.append(akkSyllable)
                    let endBreak = NSAttributedString(string: "]", attributes: noFormatting)
                    str.append(endBreak)
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
                    string: number.value.asString,
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





extension OraccTextEdition {
    public struct FormattingPreferences {
        let editorial: [NSAttributedStringKey: Any]
        let editorialBold: [NSAttributedStringKey: Any]
        let italic: [NSAttributedStringKey: Any]
        let superscript: [NSAttributedStringKey: Any]
        let damaged: [NSAttributedStringKey: Any]
        let none: [NSAttributedStringKey: Any]
        
        public init (editorial: [NSAttributedStringKey: Any], editorialBold: [NSAttributedStringKey: Any], italic: [NSAttributedStringKey: Any], superscript: [NSAttributedStringKey: Any], damaged: [NSAttributedStringKey: Any], none: [NSAttributedStringKey: Any]) {
            self.editorial = editorial
            self.editorialBold = editorialBold
            self.italic = italic
            self.superscript = superscript
            self.damaged = damaged
            self.none = none
        }
    }
}




extension NSAttributedString {
    /// A platform agnostic interface to rendering an NSAttributedString.
    /// - Parameter prefs : An `OraccTextEdition.FormattingPreferences` object filled with the requisited keys for formatting.
    public func render(withPreferences prefs: OraccTextEdition.FormattingPreferences) -> NSAttributedString {
        let mutableSelf = NSMutableAttributedString(attributedString: self)
    
        mutableSelf.enumerateAttribute(.formatting, in: NSMakeRange(0, mutableSelf.length), options: .longestEffectiveRangeNotRequired, using: { value, range, stop in
            guard let formattingInt = value as? Int else {return}
            let formattingOptions = TextEditionFormatting.init(rawValue: formattingInt)
            
            
            if formattingOptions.contains(.italic){
                // format italic
                mutableSelf.addAttributes(prefs.italic, range: range)
                
            }
            
            if formattingOptions.contains(.damaged){
                //format for damaged
                mutableSelf.addAttributes(prefs.damaged, range: range)
            }
            
            if formattingOptions.contains(.editorial){
                //format editorial
                mutableSelf.addAttributes(prefs.editorial, range: range)
            }
            
            if formattingOptions.contains([.editorial, .bold]){
                // format bold
                mutableSelf.addAttributes(prefs.editorialBold, range: range)
            }
            
            if formattingOptions.contains(.superscript){
                // format superscript
                mutableSelf.addAttributes(prefs.superscript, range: range)
            }
            
            if formattingOptions.rawValue == 0 {
                //there is no formatting
                mutableSelf.addAttributes(prefs.none, range: range)
                
            }
        })
        
        return NSAttributedString(attributedString: mutableSelf)
    }
}


#if os(macOS)
import AppKit.NSFont

@available(macOS 10.11, *)
extension NSFont {
    func getItalicFont() -> NSFont {
        let fontDsc = self.fontDescriptor
        let italicDsc = NSFontDescriptor.SymbolicTraits.italic
        let italicfntDsc = fontDsc.withSymbolicTraits(italicDsc)
        let systemFontDsc = NSFont.systemFont(ofSize: self.pointSize).fontDescriptor
        
        return NSFont(descriptor: italicfntDsc, size: self.pointSize) ?? NSFont(descriptor: systemFontDsc, size: self.pointSize)!
    }
    public func makeDefaultPreferences() -> OraccTextEdition.FormattingPreferences {
        let noFormatting = [NSAttributedStringKey.font: NSFont.systemFont(ofSize: NSFont.systemFontSize)]
        let italicFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: self.getItalicFont()]
        let superscriptFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.superscript: 1]
        let damagedFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: self.getItalicFont(), NSAttributedStringKey.foregroundColor: NSColor.gray]
        
        let editorialFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: NSFont.monospacedDigitSystemFont(ofSize: NSFont.smallSystemFontSize, weight: NSFont.Weight.regular)]
        let editorialBoldFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: NSFont.monospacedDigitSystemFont(ofSize: NSFont.smallSystemFontSize, weight: NSFont.Weight.bold)]
        
        return OraccTextEdition.FormattingPreferences(editorial: editorialFormatting, editorialBold: editorialBoldFormatting, italic: italicFormatting, superscript: superscriptFormatting, damaged: damagedFormatting, none: noFormatting)
    }
}
#endif

#if os(iOS)
import UIKit.UIFont

extension UIFont {
        func getItalicFont() -> UIFont {
            let fontDsc = self.fontDescriptor
            let italicDsc = UIFontDescriptorSymbolicTraits.traitItalic
            let italicfntDsc = fontDsc.withSymbolicTraits(italicDsc)
            if let descriptor = italicfntDsc {
                return UIFont(descriptor: descriptor, size: self.pointSize)
            } else {
                return UIFont.italicSystemFont(ofSize: self.pointSize)
            }
        }
        
        var reducedFontSize: UIFont {
            return UIFont(descriptor: self.fontDescriptor, size: self.pointSize / 2)
        }
    
    public func makeDefaultPreferences() -> OraccTextEdition.FormattingPreferences {
        let noFormatting = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        let italicFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: self.getItalicFont()]
        let superscriptFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.baselineOffset: 10,
                                                                   NSAttributedStringKey.font: self.reducedFontSize]
        let damagedFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: self.getItalicFont(), NSAttributedStringKey.foregroundColor: UIColor.gray]
        
        let editorialFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.regular)]
        let editorialBoldFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.bold)]
        
        return OraccTextEdition.FormattingPreferences(editorial: editorialFormatting, editorialBold: editorialBoldFormatting, italic: italicFormatting, superscript: superscriptFormatting, damaged: damagedFormatting, none: noFormatting)
    }
}

#endif