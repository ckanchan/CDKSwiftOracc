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
    public let citationForm: OraccCitationForm
    public let guideWord: OraccGuideWord
    public let sense: OraccSense
    public let partOfSpeech: OraccPartOfSpeech
    public let effectivePartOfSpeech: OraccEffectivePartOfSpeech
    public let language: OraccLanguage
    public let writtenForm: WrittenForm
    public let normalisation: Normalisation
    public let instanceTranslation: InstanceTranslation
    public let reference: Reference
    
    public let signValue: SignValue
    public let modifiers: SignModifiers
    
    public let cdlTextFormatting: FormattingValue
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
public extension CDLTextAttributes {
    enum OraccCitationForm: CodableAttributedStringKey {
        public typealias Value = String
        public static let name = "oraccCitationForm"
    }
    
    enum OraccGuideWord: CodableAttributedStringKey {
        public typealias Value = String
        public static let name = "oraccGuideWord"
    }
    
    enum OraccSense: CodableAttributedStringKey {
        public typealias Value = String
        public static let name = "oraccSense"
    }
    
    enum OraccPartOfSpeech: CodableAttributedStringKey {
        public typealias Value = String
        public static let name = "PartOfSpeech"
    }
    
    enum OraccEffectivePartOfSpeech: CodableAttributedStringKey {
        public typealias Value = String
        public static let name = "EffectivePartOfSpeech"
    }
    
    enum OraccLanguage: CodableAttributedStringKey {
        public typealias Value = Language
        public static let name = "OraccLanguage"
    }
    
    enum WrittenForm: CodableAttributedStringKey {
        public typealias Value = String
        public static let name = "WrittenForm"
    }
    
    enum Normalisation: CodableAttributedStringKey {
        public typealias Value = String
        public static let name = "Normalisation"
    }
    
    enum InstanceTranslation: CodableAttributedStringKey {
        public typealias Value = String
        public static let name = "InstanceTranslation"
    }
    
    enum Reference: CodableAttributedStringKey {
        public typealias Value = NodeReference
        public static let name = "Reference"
    }
    
    enum FormattingValue: CodableAttributedStringKey {
        public typealias Value = [TextEditionFormatting]
        public static let name = "formatting"
    }
}



@available(macOS 12, iOS 15, *)
public extension CDLTextAttributes {
    enum SignValue: CodableAttributedStringKey {
        public typealias Value = String
        public static let name = "SignValue"
    }
    
    enum SignModifiers: CodableAttributedStringKey {
        public typealias Value = [CuneiformSignReading.Modifier]
        public static let name = "signModifiers"
    }
}
