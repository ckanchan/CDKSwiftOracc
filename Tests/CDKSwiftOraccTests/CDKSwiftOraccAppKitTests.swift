//
//  CDKSwiftOraccTests.swift
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



#if canImport(AppKit.NSFont)
import AppKit.NSFont
import XCTest
@testable import CDKSwiftOracc


@available(macOS 10.12, *)
final class CDKSwiftOraccAppKitTests: XCTestCase {

    func testFromOnline() throws {
        let url =  URL(string: "https://raw.githubusercontent.com/ckanchan/oraccjsonmirror/master/saao/saa01/corpusjson/P224485.json")!
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let textEdition = try decoder.decode(OraccTextEdition.self, from: data)
        let portable = textEdition.transliterated()
        print(textEdition.transliteration)
        
        
        let formatted = portable.render(withPreferences: NSFont.systemFont(ofSize: NSFont.systemFontSize).makeDefaultPreferences())
        
        XCTAssert(textEdition.textid == "P224485", "Text did not decode successfully")
    }

    func testRINAP4() throws {
        let url =  URL(string: "https://raw.githubusercontent.com/ckanchan/oraccjsonmirror/master/rinap/rinap4/corpusjson/Q003230.json")!
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let textEdition = try decoder.decode(OraccTextEdition.self, from: data)
        let portable = textEdition.transliterated()
        print(textEdition.transliteration)
        
        
        let formatted = portable.render(withPreferences: NSFont.systemFont(ofSize: NSFont.systemFontSize).makeDefaultPreferences())
        
        XCTAssert(textEdition.textid == "Q003230", "Text did not decode successfully")
    }
    
}

#endif
