//
//  OraccCatalog.swift
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

public struct OraccCatalog: TextSet {
    public var source: URL
    public var project: String
    public var members: [TextID: OraccCatalogEntry]
    
    public var title: String {
        return project
    }
    
    enum CodingKeys: String, CodingKey {
        case source, project, members
    }
}

extension OraccCatalog: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let source = try container.decode(URL.self, forKey: .source)
        let project = try container.decode(String.self, forKey: .project)
        let stringKeyedMembers = try container.decode([String: OraccCatalogEntry].self, forKey: .members)
        var textIDMembers = [TextID: OraccCatalogEntry]()
        stringKeyedMembers.forEach {
            let id = TextID(stringLiteral: $0.key)
            textIDMembers[id] = $0.value
        }
        
        self.init(source: source, project: project, members: textIDMembers)
        
    }
}


