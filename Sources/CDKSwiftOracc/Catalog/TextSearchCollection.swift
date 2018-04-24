//
//  TextSearchCollection.swift
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

public struct TextSearchCollection: TextSet {
    public var title: String {
        return "Search: \(searchTerm)"
    }
    
    public var searchTerm: String
    public var members: [String : OraccCatalogEntry]
    
    let searchIDs: [String]
    
    public init(searchTerm: String, members: [String: OraccCatalogEntry], searchIDs: [String]) {
        self.searchTerm = searchTerm
        self.members = members
        self.searchIDs = searchIDs
    }
    
}


