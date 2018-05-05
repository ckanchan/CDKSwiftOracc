//
//  CDKSwiftOraccTests.swift
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

import XCTest
@testable import CDKSwiftOracc

class CDKSwiftOraccTests: XCTestCase {
    
    func testCatalogDecode() throws {
        guard let data = catalogueString.data(using: .utf8) else {
            XCTFail("Unable to generate data from string")
            return
        }
        
        let decoder = JSONDecoder()
        
        let catalogue = try decoder.decode(OraccCatalog.self, from: data)
        XCTAssert(catalogue.source.absoluteString == "http://oracc.org/saao/saa01", "Catalogue source is unexpected")
        
    }
    
    func testGlossaryDecode() throws {
        guard let data = glossaryString.data(using: .utf8) else {
            XCTFail("Unable to generate data from string")
            return
        }
        let decoder = JSONDecoder()
        let glossary = try decoder.decode(OraccGlossary.self, from: data)
        XCTAssert(glossary.lang == Language.AkkadianDialect.NeoAssyrian.rawValue, "Glossary did not decode successfully")
    }
    
    func testIndexedLookup() throws {
        guard let data = glossaryString.data(using: .utf8) else {
            XCTFail("Unable to generate data from string")
            return
        }
        let decoder = JSONDecoder()
        let glossary = try decoder.decode(OraccGlossary.self, from: data)
        XCTAssert(glossary.lang == Language.AkkadianDialect.NeoAssyrian.rawValue, "Glossary did not decode successfully")
        
        measure {
            _ = glossary.lookUp(citationForm: "šarru")
        }
    }
    
    func testDirectLookup() throws {
        guard let data = glossaryString.data(using: .utf8) else {
            XCTFail("Unable to generate data from string")
            return
        }
        let decoder = JSONDecoder()
        let glossary = try decoder.decode(OraccGlossary.self, from: data)
        XCTAssert(glossary.lang == Language.AkkadianDialect.NeoAssyrian.rawValue, "Glossary did not decode successfully")
        measure {
            _ = glossary.entries.first(where: {$0.citationForm == "šarru"})
        }
    }
    
    func testSearchResultInterface() throws {
        guard let data = catalogueString.data(using: .utf8) else {
            XCTFail("Unable to generate data from string")
            return
        }
        
        let decoder = JSONDecoder()
        
        let catalogue = try decoder.decode(OraccCatalog.self, from: data)
        
        guard let glossaryData = glossaryString.data(using: .utf8) else {
            XCTFail("Unable to generate data from string")
            return
        }
        
        let glossary = try decoder.decode(OraccGlossary.self, from: glossaryData)
        let results = glossary.searchResults(citationForm: "akālu", inCatalogue: catalogue)
        
        XCTAssertNotNil(results, "Failed to get results")
        
    }
    
    
    
    static var allTests = [
        ("testCatalogDecode", testCatalogDecode),
        ("testGlossaryDecode", testGlossaryDecode),
        ("testIndexedLookup", testIndexedLookup),
        ("testDirectLookup", testDirectLookup)
        
    ]
}

class CDKSwiftOraccTextEditionTests: XCTestCase {
    
    func testTextEditionDecode() throws {
        guard let data = P334176.data(using: .utf8) else {
            XCTFail("Unable to generate data from string")
            return
        }
        
        let decoder = JSONDecoder()

        let textEdition = try decoder.decode(OraccTextEdition.self, from: data)
        XCTAssert(textEdition.textid == "P334176", "Text did not decode successfully")
    }
    
    func testSequence() throws {
        guard let data = P334176.data(using: .utf8) else {
            XCTFail("Unable to generate data from string")
            return
        }
        
        let decoder = JSONDecoder()
        
        let textEdition = try decoder.decode(OraccTextEdition.self, from: data)
        XCTAssert(textEdition.textid == "P334176", "Text did not decode successfully")
        
        for node in textEdition {
            print(node, separator: " ")
        }
    }
    
    func testHTML5Output() throws {
        guard let data = P334176.data(using: .utf8) else {
            XCTFail("Unable to generate data from string")
            return
        }
        
        let decoder = JSONDecoder()
        
        let textEdition = try decoder.decode(OraccTextEdition.self, from: data)
        XCTAssert(textEdition.textid == "P334176", "Text did not decode successfully")
        
        _ = textEdition.html5NormalisationPage()
    }
    
    func testFromOnline() throws {
        let url =  URL(string: "https://raw.githubusercontent.com/ckanchan/oraccjsonmirror/master/saao/saa01/corpusjson/P224485.json")!
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let textEdition = try decoder.decode(OraccTextEdition.self, from: data)
        print(textEdition.transcription)
        XCTAssert(textEdition.textid == "P224485", "Text did not decode successfully")
    }
    
}
