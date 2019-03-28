//
//  Cuneifier.swift
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

/// Provides an interface for converting transliterated syllables to cuneiform glyphs.
public struct Cuneifier {
    
    let signDictionary: [String: String]
    
    /// Converts a transliterated syllable to a cuneiform glyph, looking up the sign in an internal sign dictionary.
    /// - Parameter syllable: transliterated representation of a cuneiform sign following standard Assyriological conventions
    /// - Returns: standard string representation of the cuneiform grapheme, or "[X]" if the sign couldn't be found.
    public func cuneifySyllable(_ syllable: String) -> String {
        return syllable.lowercased()
            .replacingOccurrences(of: ".", with: "-")
            .replacingOccurrences(of: "meš", with: "me-eš")
            .split(separator: "-")
            .map({String($0).cuneifyInputEncoded()})
            .map({self.signDictionary[String($0)] ?? "[X]"})
            .joined()
    }
}

extension Cuneifier {
    private init(signList: [OSL.Sign]) {
        var dictionary: [String:String] = [:]
        signList.forEach { sign in
            sign.values.forEach { value in
                dictionary[value] = sign.utf8
            }
        }
        self.init(signDictionary: dictionary)
    }
}

public extension Cuneifier {
    /// Initialises a `Cuneifier` struct from a validly formatted JSON file.
    
    init(json: Data) throws {
        let decoder = JSONDecoder()
        let list = try decoder.decode([OSL.Sign].self, from: json)
        self.init(signList: list)
    }
    
    /// Initialises a `Cuneifier` from an Oracc [`.asl` sign list format](https://github.com/oracc/oracc/blob/master/doc/ns/sl/1.0/sl.xdf). This is twice as slow as initialising from a codable JSON file so that method is preferred.
    
    init(asl: Data) throws {
        guard let aslString = String(data: asl, encoding: .utf8) else {throw OSL.DecodeError.InvalidASL}
        let list = OSL.makeSignList(aslString)
        self.init(signList: list)
    }
}
