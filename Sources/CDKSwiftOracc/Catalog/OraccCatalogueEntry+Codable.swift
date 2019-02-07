//
//  OraccCatalogueEntry+Codable.swift
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

import Foundation

extension OraccCatalogEntry: Decodable {
    private enum CodingKeys: String, CodingKey {
        case designation
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
        case pleiadesID = "pleiades_id"
        case pleiadesCoordinate = "pleiades_coord"
        case notes
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let designation = try container.decodeIfPresent(String.self, forKey: .designation) ?? "no designation"
        let displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        let title = try container.decodeIfPresent(String.self, forKey: .title)
        let popularName = try container.decodeIfPresent(String.self, forKey: .popular_name)
        let textID = try container.decodeIfPresent(String.self, forKey: .id)
        let compositeID = try container.decodeIfPresent(String.self, forKey: .id_composite)
        let idStr = textID ?? compositeID ?? "U000000"
        let id = TextID.init(stringLiteral: idStr)
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
        let notes = try container.decodeIfPresent(String.self, forKey: .notes)
        
        let chapterNumber: Int? = {
            guard let chapterNumStr = chapterNumStr else {return nil}
            return Int(String(chapterNumStr.split(separator: " ").last!))!
        }()
        
        
        let pleiadesID: Int?
        if let pleiadesIDStr = try container.decodeIfPresent(String.self, forKey: .pleiadesID) {
            pleiadesID = Int(pleiadesIDStr)
        } else {
            pleiadesID = nil
        }
        
        let pleiadesCoordinates: (Double, Double)?
        if let pleiadesCoordinateStr = try container.decodeIfPresent(String.self, forKey: .pleiadesCoordinate) {
            let squareBrackets = CharacterSet(charactersIn: "[]")
            let components = pleiadesCoordinateStr.trimmingCharacters(in: squareBrackets).split(separator: ",").map{String($0)}
            let x: Double?
            let y: Double?
            
            if let xStr = components.first {
                if let xNum = Double(xStr) {
                    x = xNum
                } else {
                    x = nil
                }
            } else {
                x = nil
            }
            
            if let yStr = components.last {
                if let yNum = Double(yStr) {
                    y = yNum
                } else {
                    y = nil
                }
            } else {
                y = nil
            }
            
            if let x = x, let y = y {
                pleiadesCoordinates = (x, y)
            } else {
                pleiadesCoordinates = nil
            }
        } else {
            pleiadesCoordinates = nil
        }
        
        self.init(displayName: displayName ?? "no friendly name", title: title ?? popularName ?? designation, id: id, ancientAuthor: ancientAuthor, project: project, chapterNumber: chapterNumber, chapterName: chapterName, genre: genre, material: material, period: period, provenience: provenience, primaryPublication: primaryPublication, museumNumber: museumNumber, publicationHistory: publicationHistory, notes: notes, pleiadesID: pleiadesID, pleiadesCoordinate: pleiadesCoordinates, credits: credits)
        
        
    }
}

extension OraccCatalogEntry: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(title, forKey: .title)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(ancientAuthor, forKey: .ancientAuthor)
        try container.encode(project, forKey: .project)
        try container.encodeIfPresent(String(chapterNumber ?? 0), forKey: .chapterNumber)
        try container.encodeIfPresent(chapterName, forKey: .chapterName)
        try container.encodeIfPresent(genre, forKey: .genre)
        try container.encodeIfPresent(material, forKey: .material)
        try container.encodeIfPresent(period, forKey: .period)
        try container.encodeIfPresent(provenience, forKey: .provenience)
        try container.encodeIfPresent(primaryPublication, forKey: .primaryPublication)
        try container.encodeIfPresent(museumNumber, forKey: .museumNumber)
        try container.encodeIfPresent(publicationHistory, forKey: .publicationHistory)
        try container.encodeIfPresent(credits, forKey: .credits)
    }
}
