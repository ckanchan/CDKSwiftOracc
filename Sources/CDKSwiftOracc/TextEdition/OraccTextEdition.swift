//
//  OraccTextEdition.swift
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

public struct OraccTextEdition: Codable {
    var type: String
    var project: String
    var loadedFrom: URL? = nil
    
    /// Access to the raw CDL node array
    var cdl: [OraccCDLNode]
    var textid: TextID
    
    /// URL for online edition. Returns `nil` if unable to form URL.
    var url: URL? {
        return URL(string: "http://oracc.museum.upenn.edu/\(project)/\(textid)/html")
    }

    
    public enum Representation: Int {
        case cuneiform = 0, transliteration, normalisation, translation
    }
}

public extension OraccTextEdition {
    /// Computed transliteration. This is recalculated every time it is called so you will need to store it yourself.
    var transliteration: String {
        return cdl.reduce(""){$0 + $1.transliterated()}
    }
    
    /// Computed normalisation. This may not be applicable if a text has not been lemmatised. This is recalculated every time it is called so you will need to store it yourself.
    var transcription: String {
        return cdl.reduce(""){$0 + $1.normalised()}
    }
    
    /// Computed literal translation. This may not be applicable if a text has not been lemmatised. This is recalculated every time it is called so you will need to store it yourself.
    var literalTranslation: String  {
        return cdl.reduce(""){$0 + $1.literalTranslation()}
    }
    
    /// Computed cuneiform. This is recalculated every time it is called so you will need to store it yourself.
    var cuneiform: String  {
        return cdl.reduce(""){$0 + $1.cuneiform()}
    }
}

public extension OraccTextEdition {
    init(type: String, project: String, cdl: [OraccCDLNode], textID: TextID = "") {
        self.init(type: type, project: project, loadedFrom: nil, cdl: cdl, textid: textID)
    }
}


#if os(macOS)
public extension OraccTextEdition {
    
    /// Tries to scrape translation from Oracc HTML using the XML tree-based parser. A bit hackish. Returns nil if a translation can't be formed. If you use this method you *must* include the copyright and license for the text manually.
    func scrapeTranslation() -> String? {
        var translation: String = ""
        
        do {
            guard let url = self.url else { return nil }
            let xml = try XMLDocument(contentsOf: url, options: XMLNode.Options.documentTidyHTML)
            let nodes = try xml.nodes(forXPath: "//*/td[3]/p/span")
            nodes.forEach{
                if let str = $0.stringValue {
                    translation.append(str)
                    translation.append("\n")
                }
            }
        } catch {
            return nil
        }
        
        return translation
    }
}
#endif

#if os(iOS)

enum ScrapeError: Error {
    case NoDataAtURL
}

    /// An object that provides a single method to scrape an Oracc translation for a text directly from HTML using the event-based parser which is the only one available on iOS.
    class OraccTranslationScraper: NSObject, XMLParserDelegate {
        let parser: XMLParser
        var insideTranslation = false
        var currentElement = ""
        var completion: (String) -> Void
        
        init(withURL url: URL, completion: @escaping (String) -> Void) {
            self.parser = XMLParser(contentsOf: url)!
            self.completion = completion
            super.init()
            self.parser.delegate = self
        }
        
        func scrape() {
            parser.parse()
        }
        
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            
            if elementName == "td" && attributeDict["class"] == "t1 xtr" {
                self.insideTranslation = true
            } else if attributeDict["class"] == "tlit" {
                self.insideTranslation = false
            } else if attributeDict["class"] == "l" {
                self.insideTranslation = false
            }
        }
        
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            
            if elementName == "td" {
                self.insideTranslation = false
            }
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            if insideTranslation {
                currentElement.append(string)
            }
        }
        
        func parserDidEndDocument(_ parser: XMLParser) {
            completion(self.currentElement)
        }
    }

    public extension OraccTextEdition {
        
        /// Asynchronously scrapes a text translation from the Oracc webpage using an event-based parser, then calls the supplied completion handler. You will need to check manually whether the copyright notice and license are included in the scraped text. If the copyright notice and license are not included, you *must* include this manually.
        /// - Throws: `ScrapeError.NoDataAtURL` if the URL could not be reached.
        func scrapeTranslation(_ completion: @escaping (String) -> Void) throws {
            guard let url = self.url else { throw ScrapeError.NoDataAtURL }
            let scraper = OraccTranslationScraper(withURL: url, completion: completion)
            scraper.scrape()
        }
    }

#endif

// Debugging extensions
extension OraccTextEdition {
    
    var discontinuityTypes: Set<String> {
        var types = Set<String>()
        
        for node in self.cdl {
            types.formUnion(node.discontinuityTypes())
        }
        return types
    }
    
    var chunkTypes: Set<String> {
        var types = Set<String>()
        
        for node in self.cdl {
            types.formUnion(node.chunkTypes())
        }
        return types
    }
}
