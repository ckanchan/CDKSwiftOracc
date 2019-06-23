//
//  OraccSwiftUIFormatter.swift
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


#if canImport(SwiftUI)

import Foundation
import SwiftUI

@available(iOS 13, *)
@available(macOS 10.15, *)
extension NSAttributedString {
    func substring(range: NSRange) -> String {
        self.attributedSubstring(from: range).string
    }
    
    public func renderForSwiftUI() -> Text {
        var textArray = [Text]()
        self.enumerateAttribute(
            .formatting,
            in: NSMakeRange(0, self.length),
            options: .longestEffectiveRangeNotRequired,
            using: { value, range, stop in
                guard let formattingInt = value as? Int else {return}
                let formattingOptions = TextEditionFormatting(rawValue: formattingInt)
                var text = Text(self.substring(range: range))
                
                if formattingOptions.contains(.italic) {
                    text = text.italic()
                }
                
                if formattingOptions.contains(.damaged) {
                    text = text.color(.secondary).italic()
                }
                
                if formattingOptions.contains(.damagedLogogram) {
                    text = text.color(.secondary)
                }
                
                if formattingOptions.contains(.editorial) {
                    text = text.color(.secondary)
                }
                
                if formattingOptions.contains([.editorial, .bold]){
                    text = text.bold().color(.secondary)
                }
                
                if formattingOptions.contains(.superscript) {
                    text = text.font(.footnote).baselineOffset(5)
                }
                
                if formattingOptions.rawValue == 0 {
                    text = text.color(.primary)
                }
                
                textArray.append(text)
        })
        
        return textArray.reduce(Text("")) { $0 + $1 }
    }
    
}

#endif

