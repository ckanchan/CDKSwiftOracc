//
//  OraccLanguages.swift
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

public enum Language {
    case Akkadian(AkkadianDialect)
    case Sumerian(SumerianDialect)
    case Hittite
    case Other(String)
    
    public enum AkkadianDialect: String {
            case Akkadian = "akk", EarlyAkkadian = "akk-x-earakk", OldAkkadian = "akk-x-oldakk", UrIIIAkkadian = "ua", conventional = "akk-x-conakk", OldAssyrian = "akk-x-oldass", MiddleAssyrian = "akk-x-midass", NeoAssyrian = "akk-x-neoass", OldBabylonian = "akk-x-oldbab", OldBabylonianPeripheral = "akk-x-obperi", MiddleBabylonian = "akk-x-midbab", MiddleBabylonianPeripheral = "akk-x-mbperi", NeoBabylonian = "akk-x-neobab", LateBabylonian = "akk-x-ltebab", StandardBabylonian = "akk-x-stdbab"
    }
    public enum SumerianDialect: String {
        case Emegir = "sux-x-emegir", Emesal = "sux-x-emesal", Syllabic = "sux-x-syllabic", Udgalnun = "sux-x-udgalnun", Sumerian
    }

    
}

public extension Language {
    init?(withProtocolCode code: String) {
        guard let initialCode = code.split(separator: "-").first else {
            return nil
        }
        
        switch initialCode {
        case "akk":
            if let dialect = Language.AkkadianDialect(rawValue: code) {
                self = .Akkadian(dialect)
            } else {
                self = .Akkadian(.Akkadian)
            }
            
        case "sux":
            if let dialect = Language.SumerianDialect(rawValue: code) {
                self = .Sumerian(dialect)
            } else {
                self = .Sumerian(.Sumerian)
            }
            
        case "hit":
            self = .Hittite
            
        default:
            return nil
        }
    }
    
    init?(withInlineCode code: String) {
        switch code {
        case "a": self = .Akkadian(.Akkadian)
        case "akk": self = .Akkadian(.Akkadian)
        case "eakk": self = .Akkadian(.EarlyAkkadian)
        case "oakk": self = .Akkadian(.OldAkkadian)
        case "ur3akk": self = .Akkadian(.UrIIIAkkadian)
        case "oa": self = .Akkadian(.OldAssyrian)
        case "ob": self = .Akkadian(.OldBabylonian)
        case "ma": self = .Akkadian(.MiddleAssyrian)
        case "mb": self = .Akkadian(.MiddleBabylonian)
        case "na": self = .Akkadian(.NeoAssyrian)
        case "nb": self = .Akkadian(.NeoBabylonian)
        case "sb": self = .Akkadian(.StandardBabylonian)
        case "ca": self = .Akkadian(.conventional)
        case "h", "hit": self = .Hittite
        case "s", "sux", "eg": self = .Sumerian(.Emegir)
        case "e", "es": self = .Sumerian(.Emesal)
        case "sy": self = .Sumerian(.Syllabic)
        case "u": self = .Sumerian(.Udgalnun)
        default: return nil
        }
    }
    
    public init(withCode code: String) {
        self = Language.init(withInlineCode: code) ?? Language.init(withProtocolCode: code) ?? Language.Other(code)
    }

    var protocolCode: String {
        switch self {
        case .Akkadian(let dialect):
            return dialect.rawValue
        case .Sumerian(let dialect):
            return dialect.rawValue
        case .Hittite:
            return "hit"
        case .Other(let str):
            return str
        }
    }
}
