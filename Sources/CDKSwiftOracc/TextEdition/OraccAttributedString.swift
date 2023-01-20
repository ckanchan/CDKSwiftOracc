//
//  OraccAttributedString.swift
//  CDKSwiftOracc: Cuneiform Documents for Swift
//  Copyright (C) 2023 Chaitanya Kanchan
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

public struct CDLTextAttributes: AttributeScope {
    let citationForm: OraccCitationForm
    let guideWord: OraccGuideWord
    let sense: OraccSense
    let partOfSpeech: OraccPartOfSpeech
    let effectivePartOfSpeech: OraccEffectivePartOfSpeech
    let language: OraccLanguage
    let writtenForm: WrittenForm
    let normalisation: Normalisation
    let instanceTranslation: InstanceTranslation
    let reference: Reference
}

public struct GDLGraphemeAttributes: AttributeScope {
    let signValue: SignValue
    let modifiers: SignModifiers
}

@available(macOS 12, *)
public extension AttributeDynamicLookup {
    subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<CDLTextAttributes, T>) -> T {
        return self[T.self]
    }
   
    subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<GDLGraphemeAttributes, T>) -> T {
        return self[T.self]
    }
    
}

enum OraccCitationForm: AttributedStringKey {
    typealias Value = String
    static let name = "oraccCitationForm"
}

enum OraccGuideWord: AttributedStringKey {
    typealias Value = String
    static let name = "oraccGuideWord"
}

enum OraccSense: AttributedStringKey {
    typealias Value = String
    static let name = "oraccSense"
}

enum OraccPartOfSpeech: AttributedStringKey {
    typealias Value = String
    static let name = "PartOfSpeech"
}

enum OraccEffectivePartOfSpeech: AttributedStringKey {
    typealias Value = String
    static let name = "EffectivePartOfSpeech"
}

enum OraccLanguage: AttributedStringKey {
    typealias Value = Language
    static let name = "OraccLanguage"
}

enum WrittenForm: AttributedStringKey {
    typealias Value = String
    static let name = "WrittenForm"
}

enum Normalisation: AttributedStringKey {
    typealias Value = String
    static let name = "Normalisation"
}

enum InstanceTranslation: AttributedStringKey {
    typealias Value = String
    static let name = "InstanceTranslation"
}

enum Reference: AttributedStringKey {
    typealias Value = NodeReference
    static let name = "Reference"
}

enum SignValue: AttributedStringKey {
    typealias Value = String
    static let name = "SignValue"
}

enum SignModifiers: AttributedStringKey {
    typealias Value = [CuneiformSignReading.Modifier]
    static let name = "signModifiers"
}
