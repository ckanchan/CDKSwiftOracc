//
//  OraccTextEdition.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 01/01/2018.
//

import Foundation

public struct OraccTextEdition: Codable {
    public let type: String
    public let project: String
    public var loadedFrom: URL? = nil
    
    /// Access to the raw CDL node array
    public let cdl: [OraccCDLNode]
    let textid: String
    
    /// URL for online edition. Returns `nil` if unable to form URL.
    public var url: URL? {
        return URL(string: "http://oracc.museum.upenn.edu/\(project)/\(textid)/html")
    }
    
    /// Computed transliteration. This is recalculated every time it is called so you will need to store it yourself.
    public var transliteration: String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.transliterated())
        }
        
        return str
    }
    
    /// Computed normalisation. This may not be applicable if a text has not been lemmatised. This is recalculated every time it is called so you will need to store it yourself.
    public var transcription: String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.normalised())
        }
        
        return str
    }
    
    /// Computed literal translation. This may not be applicable if a text has not been lemmatised. This is recalculated every time it is called so you will need to store it yourself.
    public var literalTranslation: String  {
        var str = ""
        
        for node in self.cdl {
            str.append(node.literalTranslation())
        }
        
        return str
    }
    
    /// Computed cuneiform. This is recalculated every time it is called so you will need to store it yourself.
    public var cuneiform: String  {
        var str = ""
        
        for node in self.cdl {
            str.append(node.cuneiform())
        }
        
        return str
    }
    
    public static func createNewText(nodes: [OraccCDLNode] = []) -> OraccTextEdition {
        let edition = OraccTextEdition(type: "modern", project: "none", loadedFrom: nil, cdl: nodes, textid: "n/a")
        return edition
    }
}







#if os(macOS)
public extension OraccTextEdition {
    
    /// Tries to scrape translation from Oracc HTML. A bit hackish. Returns nil if a translation can't be formed.
    public var scrapeTranslation: String? {
        var translation: String = ""
        
        do {
            guard let url = self.url else { return nil}
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
        public func scrapeTranslation(_ completion: @escaping (String) -> Void) throws {
            guard let url = self.url else { throw InterfaceError.TextError.notAvailable }
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
