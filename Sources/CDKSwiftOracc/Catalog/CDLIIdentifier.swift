//
//  CDLIIdentifier.swift
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


/// Unique identifier for a tablet entry in the CDLI database, specified [here](https://cdli.ucla.edu/?q=cdli-search-information)
public struct TextID: Hashable {
    
    enum Catalogue: String {
        /// CDLI Inscribed Object
        case P
        
        /// Single cuneiform composition in the [Oracc Q Catalogue](http://oracc.museum.upenn.edu/qcat/)
        case Q
        
        /// Single cuneiform manuscript in the [Oracc X Catalogue](http://oracc.museum.upenn.edu/xcat/)
        case X
        
        /// Unspecified catalogue
        case U
    }
    
    let catalogue: Catalogue
    let id: String
}

extension TextID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        if value.isEmpty {
            self.catalogue = .U
            self.id = ""
            return
        } else {
            let catalogueCharacter = value.first!
            let id = String(value.dropFirst())
            guard let catalogue = Catalogue.init(rawValue: String(catalogueCharacter)) else {
                self.catalogue = .U
                self.id = id
                return
            }
            self.catalogue = catalogue
            self.id = id
        }
    }
}

extension TextID: CustomStringConvertible {
    public var description: String {
        return "\(catalogue)\(id)"
    }
}

extension TextID: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        self = TextID.init(stringLiteral: str)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode (self.description)
    }
}
