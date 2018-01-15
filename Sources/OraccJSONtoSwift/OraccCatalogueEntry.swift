//
//  OraccCatalogueEntry.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 01/01/2018.
//

import Foundation

public struct OraccCatalogEntry {
    
    /// Short name for referencing
    public let displayName: String
    
    /// Descriptive title for the text content assigned by its editors
    public let title: String
    
    /// CDLI ID, ususally a P or X number
    public let id: String
    
    /// Ancient author, if available
    public let ancientAuthor: String?
    
    /// Path for the originating project
    public let project: String
    
    public let chapterNumber: Int?
    public let chapterName: String?
    public var chapter: String {
        if let name = self.chapterNumber, let number = self.chapterName {
            return "Ch.\(name) (\(number))"}
        else {
            return "No chapter assigned"
        }
    }
    public let genre: String?
    public let material: String?
    public let period: String?
    public let provenience: String?
    public let primaryPublication: String?
    public let museumNumber: String?
    public let publicationHistory: String?
    
    ///Copyright and editorial information
    public let credits: String?
}

extension OraccCatalogEntry: Decodable {
    private enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case title
        case popular_name
        case id = "id_text"
        case id_composite
        case ancientAuthor = "ancient_author"
        case project
        
        case chapterNumber = "ch_no"
        case chapterName = "ch_name"
        
        case genre, material, period, provenience
        case primaryPublication = "primary_publication"
        case museumNumber = "museum_no"
        case publicationHistory = "publication_history"
        case credits
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        let title = try container.decodeIfPresent(String.self, forKey: .title)
        let popularName = try container.decodeIfPresent(String.self, forKey: .popular_name)
        let textID = try container.decodeIfPresent(String.self, forKey: .id)
        let compositeID = try container.decodeIfPresent(String.self, forKey: .id_composite)
        let id = textID ?? compositeID ?? "no ID available"
        let ancientAuthor = try container.decodeIfPresent(String.self, forKey: .ancientAuthor)
        let project = try container.decode(String.self, forKey: .project)
        let chapterNumStr = try container.decodeIfPresent(String.self, forKey: .chapterNumber)
        let chapterName = try container.decodeIfPresent(String.self, forKey: .chapterName)
        
        let genre = try container.decodeIfPresent(String.self, forKey: .genre)
        let material = try container.decodeIfPresent(String.self, forKey: .material)
        let period = try container.decodeIfPresent(String.self, forKey: .period)
        let provenience = try container.decodeIfPresent(String.self, forKey: .provenience)
        let primaryPublication = try container.decodeIfPresent(String.self, forKey: .primaryPublication)
        let museumNumber = try container.decodeIfPresent(String.self, forKey: .museumNumber)
        let publicationHistory = try container.decodeIfPresent(String.self, forKey: .publicationHistory)
        let credits = try container.decodeIfPresent(String.self, forKey: .credits)
        
        let chapterNumber: Int? = {
            guard let chapterNumStr = chapterNumStr else {return nil}
            return Int(String(chapterNumStr.split(separator: " ").last!))!
        }()
        
        self.init(displayName: displayName ?? "no friendly name", title: title ?? popularName ?? "no title", id: id, ancientAuthor: ancientAuthor, project: project, chapterNumber: chapterNumber, chapterName: chapterName, genre: genre, material: material, period: period, provenience: provenience, primaryPublication: primaryPublication, museumNumber: museumNumber, publicationHistory: publicationHistory, credits: credits)
        
        
        
        
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
