//
//  TextEditionFormatting.swift
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

/// Provides formatting hints
public struct TextEditionFormatting: OptionSet, Hashable, Codable {
    public let rawValue: Int
    
    public static let editorial = TextEditionFormatting(rawValue: 1 << 0)
    public static let bold = TextEditionFormatting(rawValue: 1 << 1)
    public static let italic = TextEditionFormatting(rawValue: 1 << 2)
    public static let superscript = TextEditionFormatting(rawValue: 1 << 3)
    public static let damaged = TextEditionFormatting(rawValue: 1 << 4)
    public static let damagedLogogram = TextEditionFormatting(rawValue: 1 << 5)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
}
