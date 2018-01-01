//
//  OraccCatalogueEntry.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 01/01/2018.
//

import Foundation

public struct OraccCatalogEntry {
    public let displayName: String
    public let title: String
    public let id: String
    public let ancientAuthor: String?
    public let SAAid: Int
    
    public let chapter: Int
}

extension OraccCatalogEntry: Decodable {
    private enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case title = "title"
        case id = "id_text"
        case ancientAuthor = "ancient_author"
        
        case chapter = "ch_no"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let displayName = try container.decode(String.self, forKey: .displayName)
        let title = try container.decode(String.self, forKey: .title)
        let id = try container.decode(String.self, forKey: .id)
        let chapterStr = try container.decode(String.self, forKey: .chapter)
        let ancientAuthor = try container.decode(String.self, forKey: .ancientAuthor)
        let chapter = Int(String(chapterStr.split(separator: " ").last!))!
        let SAAid = Int(String(displayName.split(separator: " ").last!))!
        
        
        
        self.init(displayName: displayName, title: title, id: id, ancientAuthor: ancientAuthor, SAAid: SAAid, chapter: chapter)
    }
}

extension OraccCatalogEntry: CustomStringConvertible {
    public var description: String {
        return """
        
        \(displayName) \(title)\t [\(id)]
        \(ancientAuthor ?? "")
        
        """
    }
}
