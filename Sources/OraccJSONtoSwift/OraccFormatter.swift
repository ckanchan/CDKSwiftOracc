//
//  OraccFormatter.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 07/01/2018.
//

import Foundation


// Adds keys that support the encoding of Oracc lemmatisation information into attributed strings.
public extension NSAttributedStringKey {
    public static var oraccCitationForm: NSAttributedStringKey {
        return self.init("oraccCitationForm")
    }
    
    public static var oraccGuideWord: NSAttributedStringKey {
        return self.init("oraccGuideWord")
    }
    
    public static var oraccSense: NSAttributedStringKey {
        return self.init("oraccSense")
    }
    
    public static var partOfSpeech: NSAttributedStringKey {
        return self.init("partOfSpeech")
    }
    
    public static var effectivePartOfSpeech: NSAttributedStringKey {
        return self.init("effectivePartOfSpeech")
    }
    
    public static var oraccLanguage: NSAttributedStringKey {
        return self.init("oraccLanguage")
    }
    
    public static var writtenForm: NSAttributedStringKey {
        return self.init("writtenForm")
    }
    
    public static var normalisation: NSAttributedStringKey {
        return self.init("normalisation")
    }
    
    public static var instanceTranslation: NSAttributedStringKey {
        return self.init("instanceTranslation")
    }
}

// Adds keys that support the encoding of GDL grapheme data into attributed strings
public extension NSAttributedStringKey {
    public static var signValue: NSAttributedStringKey {
        return self.init("signValue")
    }
    
    public static var signModifiers: NSAttributedStringKey {
        return self.init("signModifiers")
    }
    
}


extension OraccCDLNode.Lemma {
    public func getExtendedAttributes() -> [NSAttributedStringKey: Any] {
        var attributes = [NSAttributedStringKey:Any]()
        attributes[.oraccCitationForm] = self.wordForm.translation.citationForm ?? ""
        attributes[.oraccGuideWord] = self.wordForm.translation.guideWord
        attributes[.oraccSense] = self.wordForm.translation.sense ?? ""
        attributes[.partOfSpeech] = self.wordForm.translation.partOfSpeech
        attributes[.effectivePartOfSpeech] = self.wordForm.translation.effectivePartOfSpeech
        attributes[.writtenForm] = self.fragment
        attributes[.instanceTranslation] = self.instanceTranslation
        
        return attributes
    }
}

extension CuneiformSign {
    public func getExtendedAttributes() -> [NSAttributedStringKey: Any] {
        var attributes = [NSAttributedStringKey:Any]()
        let signValue: String
        var modifiers: String? = nil
        // Get the appropriate values from the enumerated type
        switch self {
        case .value(let value):
            signValue = value
        case .name(let name):
            signValue = name
        case .number(let number):
            signValue = number
        case .formVariant(_, let base, let modifier):
            signValue = base
            modifiers = modifier.description
        case .null:
            signValue = ""
        }
        
        attributes[.signValue] = signValue
        if let modifiers = modifiers { attributes[.signModifiers] = modifiers}
        return attributes
    }
}




#if os(iOS)
    import UIKit
    
let noFormatting = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
let editorialFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.regular)]
let editorialBoldFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.bold)]
    
    
    /// Formats strings and text using Assyriological conventions. Available for iOS only.
    public extension OraccTextEdition {
        
        /// Returns a string formatted with Akkadian normalisation.
        public func formattedNormalisation(withFont font: UIFont) -> NSAttributedString {
            let str = NSMutableAttributedString(string: "")
            
            for node in self.cdl {
                str.append(node.normalisedAttributedString(withFont: font))
            }
            
            return str
        }
        
        /// Returns a formatted transliteration.
        public func formattedTransliteration(withFont font: UIFont) -> NSAttributedString {
            let str = NSMutableAttributedString(string: "")
            for node in self.cdl {
                str.append(node.transliteratedAttributedString(withFont: font))
            }
            
            return str
        }
        
        /// Returns a cuneified string with additional metadata
        /// - Parameter font: A font that covers cuneiform codepoints. Allows choice between OB or NA glyphs.
        public func formattedCuneiform(withFont font: UIFont) -> NSAttributedString {
            let str = NSMutableAttributedString(string: "")
            for node in self.cdl {
                str.append(node.cuneiformAttributedString(withFont: font))
            }

            return str
        }
    }
    
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
    }
    
    extension GraphemeDescription {
        public func transliteratedAttributedString(withFont font: UIFont) -> NSAttributedString {
            let str = NSMutableAttributedString(string: "")
            //Formatting attributes
            let italicFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font.getItalicFont()]
            let superscriptFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.baselineOffset: 10,
                                                                       NSAttributedStringKey.font: font.reducedFontSize]
            
            
            
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
            } else if let group = group {
            
            //Recursing
            
                group.forEach{str.append($0.transliteratedAttributedString(withFont: font))}
            } else if let gdl = gdl {
                gdl.forEach{str.append($0.transliteratedAttributedString(withFont: font))}
            } else if let sequence = sequence {
                sequence.forEach{str.append($0.transliteratedAttributedString(withFont: font))}
            } else {
                switch self.sign {
                case .value(let syllable): // Syllabographic
                    let akkSyllable: NSAttributedString
                    if syllable == "x" {
                        akkSyllable = NSAttributedString(string: syllable, attributes: noFormatting) // Formats broken signs
                    } else {
                        akkSyllable = NSAttributedString(
                            string: syllable,
                            attributes: italicFormatting)
                    }
                    str.append(akkSyllable)
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
                        string: number,
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
            
            return str
        }
    
        public func cuneiformAttributedString(withFont font: UIFont) -> NSAttributedString {
            let str = NSMutableAttributedString(string: "")

            // Recursive calls
            if let gdl = gdl {
                for grapheme in gdl {
                    str.append(grapheme.cuneiformAttributedString(withFont: font))
                }
            } else if let sequence = sequence {
                for grapheme in sequence {
                    str.append(grapheme.cuneiformAttributedString(withFont: font))
                }
            } else if let group = group {
                for grapheme in group {
                    str.append(grapheme.cuneiformAttributedString(withFont: font))
                }
            } else {
                var attributes = self.sign.getExtendedAttributes()
                attributes[.font] = font

                let text = graphemeUTF8 ?? ""
                
                let sign = NSMutableAttributedString(string: text, attributes: attributes)
                

                str.append(sign)
            }

            return str
        }
    
    }
    
    extension OraccCDLNode {
        func normalisedAttributedString(withFont font: UIFont) -> NSAttributedString {
            
            let str: NSMutableAttributedString = NSMutableAttributedString(string: "")
            let italicFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font.getItalicFont()]
            let editorialFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.regular)]
            let editorialBoldFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.bold)]
            
            switch self.node {
            case .l(let lemma):
                switch lemma.wordForm.language {
                case .Akkadian(_):
                    let attrStr: NSMutableAttributedString
                    if let norm = lemma.wordForm.normalisation {
                        let translationAttrs = lemma.getExtendedAttributes()
                        attrStr = NSMutableAttributedString(
                            string: "\(norm) ",
                            attributes: italicFormatting
                        )
                        attrStr.addAttributes(translationAttrs, range: NSMakeRange(0, attrStr.string.count))
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
        
        
        func transliteratedAttributedString(withFont font: UIFont) -> NSAttributedString {
            let str = NSMutableAttributedString(string: "")
            switch self.node {
            case .l(let lemma):
                for grapheme in lemma.wordForm.graphemeDescriptions {
                    let sstr = NSMutableAttributedString(string: "")
                    let attribs = lemma.getExtendedAttributes()
                    
                    sstr.append(grapheme.transliteratedAttributedString(withFont: font))
                    sstr.addAttributes(attribs, range: NSMakeRange(0, sstr.string.count)) 
                    str.append(sstr)
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


        func cuneiformAttributedString(withFont font: UIFont) -> NSAttributedString {

            let str: NSMutableAttributedString = NSMutableAttributedString(string: "")
            let space = NSAttributedString(string: " ")

            switch self.node {
            case .l(let lemma):
                for grapheme in lemma.wordForm.graphemeDescriptions {
                    str.append(grapheme.cuneiformAttributedString(withFont: font))
                    str.append(space)
                }

            case .c(let chunk):
                for node in chunk.cdl {
                    str.append(node.cuneiformAttributedString(withFont: font))
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

