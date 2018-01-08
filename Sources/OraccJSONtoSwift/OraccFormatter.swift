////
////  OraccFormatter.swift
////  OraccJSONtoSwift
////
////  Created by Chaitanya Kanchan on 07/01/2018.
////
//
//#if os(iOS)
//    
//    import Foundation
//    import UIKit
//    
//    
//    /// Formats strings and text using Assyriological conventions. Available for iOS only.
//    public extension OraccTextEdition {
//        
//        /// Returns a string formatted with Akkadian normalisation.
//        public func formattedNormalisation(withFont font: UIFont) -> NSAttributedString {
//            let str = NSMutableAttributedString(string: "")
//            
//            for node in self.cdl {
//                str.append(node.normalisedAttributedString(withFont: font))
//            }
//            
//            return str
//        }
//        
//        /// Returns a formatted transliteration.
//        public func formattedTransliteration(withFont font: UIFont) -> NSAttributedString {
//            let str = NSMutableAttributedString(string: "")
//            for node in self.cdl {
//                str.append(node.transliteratedAttributedString(withFont: font))
//            }
//            
//            return str
//        }
//    }
//    
//    extension UIFont {
//        func getItalicFont() -> UIFont {
//            let fontDsc = self.fontDescriptor
//            let italicDsc = UIFontDescriptorSymbolicTraits.traitItalic
//            let italicfntDsc = fontDsc.withSymbolicTraits(italicDsc)
//            if let descriptor = italicfntDsc {
//                return UIFont(descriptor: descriptor, size: self.pointSize)
//            } else {
//                return UIFont.italicSystemFont(ofSize: self.pointSize)
//            }
//        }
//        
//        var reducedFontSize: UIFont {
//            return UIFont(descriptor: self.fontDescriptor, size: self.pointSize / 2)
//        }
//    }
//    
//    extension GraphemeDescription {
//        public func transliteratedAttributedString(withFont font: UIFont) -> NSAttributedString {
//            let str = NSMutableAttributedString(string: "")
//            
//            //Formatting attributes
//            let italicFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font.getItalicFont()]
//            let superscriptFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.baselineOffset: 10,
//                                                                       NSAttributedStringKey.font: font.reducedFontSize]
//
//            
//            if let v = v {
//                //Syllabograms
//                let akkSyllable: NSAttributedString
//                if v == "x" {
//                    akkSyllable = NSAttributedString(string: v, attributes: nil) // Formats broken signs
//                } else {
//                    akkSyllable = NSAttributedString(
//                        string: v,
//                        attributes: italicFormatting)
//                }
//                
//                str.append(akkSyllable)
//                let delimiter = NSAttributedString(
//                    string: delim ?? " ",
//                    attributes: nil
//                )
//                str.append(delimiter)
//                
//                //Syllabograms defined in `form`
//            } else if let form = form {
//                let akkSyllable: NSAttributedString
//                if let _ = Int(form) {
//                    akkSyllable = NSAttributedString(string: form, attributes: nil)
//                } else if "\(role ?? "")" == "logo" {
//                    akkSyllable = NSAttributedString(string: form, attributes: nil)
//                } else {
//                    akkSyllable = NSAttributedString(
//                    string: form,
//                    attributes: italicFormatting)
//                }
//                str.append(akkSyllable)
//                let delimiter = NSAttributedString(
//                    string: delim ?? " ",
//                    attributes: nil
//                )
//                str.append(delimiter)
//
//                // Logograms
//            } else if let s = s {
//                let logogram = NSAttributedString(
//                    string: s,
//                    attributes: nil)
//                str.append(logogram)
//                let delimiter = NSAttributedString(
//                    string: delim ?? " ",
//                    attributes: nil)
//                str.append(delimiter)
//                
//                // Determinatives
//            } else if det != nil {
//                let delimiter: String
//                
//                if let position = pos { // Formats delimiter appropriately for determinative position
//                    if position == "post" {
//                        delimiter = " "
//                    } else {
//                        delimiter = ""
//                    }
//                } else {
//                    delimiter = ""
//                }
//                
//                if let seq = seq {
//                    for grapheme in seq {
//                        let determinative: NSAttributedString?
//                        if let s = grapheme.s {
//                            determinative = NSAttributedString(
//                                string: s + delimiter,
//                                attributes: superscriptFormatting)
//                        } else if let form = form {
//                            determinative = NSAttributedString(
//                                string: form + delimiter,
//                                attributes: superscriptFormatting)
//                        } else if let v = grapheme.v {
//                            determinative = NSAttributedString(
//                                string: v + delimiter,
//                                attributes: superscriptFormatting)
//                        } else {
//                            determinative = nil
//                        }
//                        if let determinative = determinative
//                        {
//                            str.append(determinative)
//                        }
//                    }
//                }
//                // Recursing
//            } else if let gdl = gdl {
//                for grapheme in gdl {
//                    str.append(grapheme.transliteratedAttributedString(withFont: font))
//                }
//            } else if let seq = seq {
//                for grapheme in seq {
//                    str.append(grapheme.transliteratedAttributedString(withFont: font))
//                }
//            } else if let group = group {
//                for grapheme in group {
//                    str.append(grapheme.transliteratedAttributedString(withFont: font))
//                }
//            } else {
//                str.append(NSAttributedString(string: " "))
//            }
//            return str
//        }
//    }
//    
//    extension OraccCDLNode {
//        func normalisedAttributedString(withFont font: UIFont) -> NSAttributedString {
//            
//            let str: NSMutableAttributedString = NSMutableAttributedString(string: "")
//            let italicFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font.getItalicFont()]
//            let editorialFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.regular)]
//            let editorialBoldFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.bold)]
//            
//            switch self.node {
//            case .l(let lemma):
//                if lemma.f.lang == "akk-x-neoass" || lemma.f.lang == "akk" {
//                    let attrStr: NSAttributedString
//                    if let norm = lemma.f.norm {
//                        attrStr = NSAttributedString(
//                            string: "\(norm) ",
//                            attributes: italicFormatting
//                        )
//                    } else {
//                        attrStr = NSAttributedString(
//                            string: "x ",
//                            attributes: editorialFormatting
//                        )
//                    }
//                    str.append(attrStr)
//                }
//                
//            case .c(let chunk):
//                for node in chunk.cdl {
//                    str.append(node.normalisedAttributedString(withFont: font))
//                }
//                
//            case .d(let discontinuity):
//                switch discontinuity.type {
//                case .obverse:
//                    let obv = NSAttributedString(string: "Obverse: \n", attributes: editorialBoldFormatting)
//                    str.append(obv)
//                case .linestart:
//                    let ln = NSAttributedString(string: "\n\(discontinuity.label!) ", attributes: editorialFormatting)
//                    str.append(ln)
//                case .reverse:
//                    let rev = NSAttributedString(string: "\n\n\n Reverse: \n", attributes: editorialBoldFormatting)
//                    str.append(rev)
//                default:
//                    break
//                }
//            case .linkbase(_):
//                break
//            }
//            
//            return NSAttributedString(attributedString: str)
//        }
//        
//        
//        func transliteratedAttributedString(withFont font: UIFont) -> NSAttributedString {
//            
//            let editorialFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.regular)]
//            let editorialBoldFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.bold)]
//            
//            let str = NSMutableAttributedString(string: "")
//            switch self.node {
//            case .l(let lemma):
//                for grapheme in lemma.f.gdl {
//                    str.append(grapheme.transliteratedAttributedString(withFont: font))
//                }
//            case .c(let chunk):
//                for node in chunk.cdl {
//                    str.append(node.transliteratedAttributedString(withFont: font))
//                }
//            case .d(let discontinuity):
//                switch discontinuity.type {
//                case .obverse:
//                    let obv = NSAttributedString(string: "Obverse: \n", attributes: editorialBoldFormatting)
//                    str.append(obv)
//                case .linestart:
//                    let ln = NSAttributedString(string: "\n\(discontinuity.label!) ", attributes: editorialFormatting)
//                    str.append(ln)
//                case .reverse:
//                    let rev = NSAttributedString(string: "\n\n\n Reverse: \n", attributes: editorialBoldFormatting)
//                    str.append(rev)
//                default:
//                    break
//                }
//            case .linkbase(_):
//                break
//            }
//            
//            return NSAttributedString(attributedString: str)
//        }
//    }
//
//#endif

