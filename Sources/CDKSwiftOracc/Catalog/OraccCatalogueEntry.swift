//
//  OraccCatalogueEntry.swift
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

public struct OraccCatalogEntry {
    
    /// Short name for referencing
    public var displayName: String
    
    /// Descriptive title for the text content assigned by its editors
    public var title: String
    
    /// CDLI ID, ususally a P or X number
    public var id: TextID
    
    /// Ancient author, if available
    public var ancientAuthor: String?
    
    /// Path for the originating project
    public var project: String
    
    public var chapterNumber: Int?
    public var chapterName: String?
    public var chapter: String {
        if let name = self.chapterNumber, let number = self.chapterName {
            return "Ch.\(name) (\(number))"}
        else {
            return "No chapter assigned"
        }
    }
    public var genre: String?
    public var material: String?
    public var period: String?
    public var provenience: String?
    public var primaryPublication: String?
    public var museumNumber: String?
    public var publicationHistory: String?
    public var notes: String?
    public var pleiadesID: Int?
    public var pleiadesCoordinate: (Double, Double)?
    
    ///Copyright and editorial information
    public var credits: String?
}

extension OraccCatalogEntry {
    // Swift requires that any public initialisers be explicitly declared. The memberwise initialiser is not available outside of the module.
    public init(displayName: String, title: String, id: String, ancientAuthor: String?, project: String, chapterNumber: Int?, chapterName: String?, genre: String?, material: String?, period: String?, provenience: String?, primaryPublication: String?, museumNumber: String?, publicationHistory: String?, notes: String?, pleiadesID: Int?, pleiadesCoordinate: (Double, Double)?, credits: String?) {
        self.displayName = displayName
        self.title = title
        self.id = TextID.init(stringLiteral: id)

        self.ancientAuthor = ancientAuthor
        self.project = project
        self.chapterNumber = chapterNumber
        self.chapterName = chapterName
        self.genre = genre
        self.material = material
        self.period = period
        self.provenience = provenience
        self.primaryPublication = primaryPublication
        self.museumNumber = museumNumber
        self.publicationHistory = publicationHistory
        self.notes = notes
        self.credits = credits
        self.pleiadesID = pleiadesID
        self.pleiadesCoordinate = pleiadesCoordinate
    }
    
    public init(id: TextID, displayName: String, ancientAuthor: String?, title: String, project: String) {
        self.init(displayName: displayName, title: title, id: id, ancientAuthor: ancientAuthor, project: project, chapterNumber: nil, chapterName: nil, genre: nil, material: nil, period: nil, provenience: nil, primaryPublication: nil, museumNumber: nil, publicationHistory: nil, notes: nil, pleiadesID: nil, pleiadesCoordinate: nil, credits: nil)
    }

}

extension OraccCatalogEntry: CustomStringConvertible {
    public var description: String {
        return """
        
        \(displayName)
        \(title)
        \(ancientAuthor ?? "")
        \(chapter)
        \(id)
        \(genre ?? "")
        \(material ?? "")
        \(period ?? "")
        \(provenience ?? "")
        \(primaryPublication ?? "")
        \(publicationHistory ?? "")
        
        """
    }
}


