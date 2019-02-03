//
//  NodeReference.swift
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

/// Uniquely identifies a lemma within a text, specifying the text ID, line and line position
public struct NodeReference: Hashable {
    public var base: TextID
    public var path: [String]
}

extension NodeReference: CustomStringConvertible {
    public var description: String {
        let pathString = path.joined(separator: ".")
        return "\(base).\(pathString)"
    }
}

extension NodeReference: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let components = value.split(separator: ".").compactMap{String($0)}
        let id = TextID.init(stringLiteral: String(components.first!))
        self.init(base: id, path: Array(components.dropFirst()))
    }
}

extension NodeReference: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        self.init(stringLiteral: str)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }
}

