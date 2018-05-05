//
//  PortableFormatter.swift
//  CDKSwiftOracc
//
//  Created by Chaitanya Kanchan on 05/05/2018.
//

import Foundation


public extension NSAttributedStringKey {
    public static var formatting: NSAttributedStringKey {
        return self.init("formatting")
    }
}


/// Provides formatting hints
public struct TextEditionFormatting: OptionSet {
    public let rawValue: Int
    
    public static let editorial = TextEditionFormatting(rawValue: 1)
    public static let bold = TextEditionFormatting(rawValue: 2)
    public static let italic = TextEditionFormatting(rawValue: 4)
    public static let superscript = TextEditionFormatting(rawValue: 8)
    public static let damaged = TextEditionFormatting(rawValue: 16)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
}


extension OraccTextEdition {
    func portableNormalisedString() -> NSAttributedString {
        let str = NSMutableAttributedString(string: "")
        for node in self.cdl {
            str.append(node.portableNormalisedString())
        }
        return NSAttributedString(attributedString: str)
    }
}

extension OraccCDLNode {
    func portableNormalisedString() -> NSAttributedString {
        let str = NSMutableAttributedString(string: "")
        
        switch self.node {
        case .l(let lemma):
            let attrStr: NSMutableAttributedString
            if let norm = lemma.wordForm.normalisation {
                var translationAttrs = lemma.getExtendedAttributes()
                translationAttrs[.formatting] = TextEditionFormatting([.italic])
                attrStr = NSMutableAttributedString(
                    string: "\(norm)",
                    attributes: translationAttrs
                )
            } else {
                attrStr = NSMutableAttributedString(
                    string: "x ",
                    attributes: [.formatting: TextEditionFormatting([.damaged])]
                )
            }
            
            str.append(attrStr)
            
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.portableNormalisedString())
            }
            
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                let obv = NSAttributedString(string: "Obverse: \n", attributes: [.formatting: TextEditionFormatting([.editorial, .bold])])
                str.append(obv)
            case .linestart:
                let ln = NSAttributedString(string: "\n\(discontinuity.label ?? "") ", attributes: [.formatting: TextEditionFormatting([.editorial])])
                str.append(ln)
            case .reverse:
                let rev = NSAttributedString(string: "\n\n\n Reverse: \n", attributes: [.formatting: TextEditionFormatting([.editorial, .bold])])
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
    /// An attempt was made to provide a platform agnostic interface to rendering an NSAttributedString
    public func render(withPreferences prefs: OraccTextEdition.FormattingPreferences) -> NSAttributedString {
        let mutableSelf = NSMutableAttributedString(attributedString: self)
    
        mutableSelf.enumerateAttribute(.formatting, in: NSMakeRange(0, mutableSelf.length), options: .longestEffectiveRangeNotRequired, using: { value, range, stop in
            guard let formattingOptions = value as? TextEditionFormatting else {return}
            if formattingOptions.contains(.bold){
                // format bold
                mutableSelf.addAttributes(prefs.editorialBold, range: range)
                
            }
            
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
extension NSFont {
    
    func makeDefaultPreferences() -> OraccTextEdition.FormattingPreferences {
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

#endif
