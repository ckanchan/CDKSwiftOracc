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

@available(macOS 12, iOS 15, *)
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
    
    let signValue: SignValue
    let modifiers: SignModifiers
    
    let formatting: FormattingValue
}

@available(macOS 12, iOS 15, *)
public struct GDLGraphemeAttributes: AttributeScope {

}

@available(macOS 12, iOS 15, *)
public extension AttributeDynamicLookup {
    subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<CDLTextAttributes, T>) -> T {
        return self[T.self]
    }
   
    subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<GDLGraphemeAttributes, T>) -> T {
        return self[T.self]
    }
    
}

@available(macOS 12, iOS 15, *)
extension CDLTextAttributes {
    enum OraccCitationForm: CodableAttributedStringKey {
        typealias Value = String
        static let name = "oraccCitationForm"
    }
    
    enum OraccGuideWord: CodableAttributedStringKey {
        typealias Value = String
        static let name = "oraccGuideWord"
    }
    
    enum OraccSense: CodableAttributedStringKey {
        typealias Value = String
        static let name = "oraccSense"
    }
    
    enum OraccPartOfSpeech: CodableAttributedStringKey {
        typealias Value = String
        static let name = "PartOfSpeech"
    }
    
    enum OraccEffectivePartOfSpeech: CodableAttributedStringKey {
        typealias Value = String
        static let name = "EffectivePartOfSpeech"
    }
    
    enum OraccLanguage: CodableAttributedStringKey {
        typealias Value = Language
        static let name = "OraccLanguage"
    }
    
    enum WrittenForm: CodableAttributedStringKey {
        typealias Value = String
        static let name = "WrittenForm"
    }
    
    enum Normalisation: CodableAttributedStringKey {
        typealias Value = String
        static let name = "Normalisation"
    }
    
    enum InstanceTranslation: CodableAttributedStringKey {
        typealias Value = String
        static let name = "InstanceTranslation"
    }
    
    enum Reference: CodableAttributedStringKey {
        typealias Value = NodeReference
        static let name = "Reference"
    }
    
    enum FormattingValue: CodableAttributedStringKey {
        public typealias Value = [TextEditionFormatting]
        public static let name = "formatting"
    }
}



@available(macOS 12, iOS 15, *)
extension CDLTextAttributes {
    enum SignValue: CodableAttributedStringKey {
        typealias Value = String
        static let name = "SignValue"
    }
    
    enum SignModifiers: CodableAttributedStringKey {
        typealias Value = [CuneiformSignReading.Modifier]
        static let name = "signModifiers"
    }
}
