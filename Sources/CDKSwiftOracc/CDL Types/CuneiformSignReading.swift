//
//  CuneiformSignReading.swift
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

/// Datatype enumerating a localized reading of a cuneiform sign from a tablet.

public enum CuneiformSignReading: Hashable, Equatable, Codable {
    
    /// Sign read with syllabic value.
    case value(String)
    
    /// Sign read with name. Usually indicates a logogram in Akkadian texts.
    case name(String)
    
    /// Sexagesimal number
    case number(value: Float, sexagesimal: String)
    
    /// Complex sign form variant
    /// - Parameter form: simple text representation of the complex sign.
    /// - Parameter base: basic sign value component
    /// - Parameter modifier: array of cuneiform sign modifiers, represented as `CuneiformSign.Modifier`
    case formVariant(form: String, base: String, modifier: [Modifier])
    
    /// Debug value; shouldn't appear under normal circumstances and shouldn't be used directly.
    case null
    
    /// Various kinds of cuneiform sign graphical variations.
    public enum Modifier: Hashable, Equatable, Codable {
        case curved, flat, gunu, šešig, tenu, nutillu, zidatenu, kabatenu, verticallyReflected, horizontallyReflected, rotated(Int), variant
        
        case Allograph(String)
        case FormVariant(String)
    }
}

extension CuneiformSignReading.Modifier {
    
    /// Returns `CuneiformSign.Modifier` for validly encoded GDL modifiers; returns `nil` if modifier can't be found
    static func modifierFromString(_ s: String) -> CuneiformSignReading.Modifier? {
        switch s {
        case "c": return .curved
        case "f": return .flat
        case "g": return .gunu
        case "s": return .šešig
        case "t": return .tenu
        case "n": return .nutillu
        case "z": return .zidatenu
        case "k": return .kabatenu
        case "r": return .verticallyReflected
        case "h": return .horizontallyReflected
        case "v": return .variant
            
        default: return nil
        }
    }
}
