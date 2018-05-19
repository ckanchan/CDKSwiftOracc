//
//  XISReference.swift
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

/// A path reference to a specific instance of a glossary lemma. Indexed by a XISKey string.
public struct XISReference: CustomStringConvertible {
    public var description: String {
        return "\(project):\(cdliID)"
    }
    
    public let project: String
    public var cdliID: TextID {
        let str = String(reference.prefix{$0 != "."})
        return TextID(stringLiteral: str)
    }
    
    public let reference: String

    public init?(withReference key: String) {
        let elements = key.split(separator: ":")
        self.project = String(elements[0])
        self.reference = String(elements[1])
    }
    
    
    
}
