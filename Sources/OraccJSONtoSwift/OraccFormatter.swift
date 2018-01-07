//
//  OraccFormatter.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 07/01/2018.
//

#if os(iOS)
    
    import Foundation
    import UIKit
    
    
    /// Formats strings and text using Assyriological conventions. Available for iOS only.
    public extension OraccTextEdition {
        
        /// Returns a string formatted for Akkadian
        public func formattedNormalisation(withFont font: UIFont) -> NSAttributedString {
            let str = NSMutableAttributedString(string: "")
            
            for node in self.cdl {
                str.append(node.normalisedAttributedString(withFont: font))
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
    }
    
    extension OraccCDLNode {
        func normalisedAttributedString(withFont font: UIFont) -> NSAttributedString {
            
            let str: NSMutableAttributedString = NSMutableAttributedString(string: "")
            let italicFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font.getItalicFont()]
            let editorialFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.regular)]
            let editorialBoldFormatting: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.monospacedDigitSystemFont(ofSize: UIFont.smallSystemFontSize, weight: UIFont.Weight.bold)]
            
            switch self.node {
            case .l(let lemma):
                if lemma.f.lang == "akk-x-neoass" || lemma.f.lang == "akk" {
                    let attrStr: NSAttributedString
                    if let norm = lemma.f.norm {
                        attrStr = NSAttributedString(
                            string: "\(norm) ",
                            attributes: italicFormatting
                        )
                    } else {
                        attrStr = NSAttributedString(
                            string: "x ",
                            attributes: editorialFormatting
                        )
                    }
                    str.append(attrStr)
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
                    let ln = NSAttributedString(string: "\n\(discontinuity.label!) ", attributes: editorialFormatting)
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
