//
//  OraccCDLNode+ExtendedAttributes.swift
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

extension OraccCDLNode.Lemma {
    public func getExtendedAttributes() -> [NSAttributedString.Key: Any] {
        var attributes = [NSAttributedString.Key:Any]()
        attributes[.oraccCitationForm] = self.wordForm.translation.citationForm ?? ""
        attributes[.oraccGuideWord] = self.wordForm.translation.guideWord
        attributes[.oraccSense] = self.wordForm.translation.sense ?? ""
        attributes[.partOfSpeech] = self.wordForm.translation.partOfSpeech
        attributes[.effectivePartOfSpeech] = self.wordForm.translation.effectivePartOfSpeech
        attributes[.writtenForm] = self.fragment
        attributes[.instanceTranslation] = self.instanceTranslation
        attributes[.reference] = self.reference.path.joined(separator: ".")
        attributes[.oraccLanguage] = self.wordForm.language.protocolCode
        
        return attributes
    }
    
    @available(macOS 12, iOS 15, *)
    public func getExtendedAttributeValues() -> AttributeContainer {
        var container = AttributeContainer()
        container.citationForm = self.wordForm.translation.citationForm ?? ""
        container.guideWord = self.wordForm.translation.guideWord
        container.sense = self.wordForm.translation.sense ?? ""
        container.partOfSpeech = self.wordForm.translation.partOfSpeech
        container.effectivePartOfSpeech = self.wordForm.translation.effectivePartOfSpeech
        container.writtenForm = self.fragment
        container.instanceTranslation = self.instanceTranslation
        container.reference = self.reference
        container.language = self.wordForm.language
        
        return container
    }
}

extension CuneiformSignReading {
    
    private func getSignValueAndModifiers() -> (signValue: String, modifier: [CuneiformSignReading.Modifier]?) {
        let signValue: String
        var modifiers: [CuneiformSignReading.Modifier]? = nil
        // Get the appropriate values from the enumerated type
        switch self {
        case .value(let value):
            signValue = value
        case .name(let name):
            signValue = name
        case .number(value: let value, sexagesimal: _):
            signValue = value.asString
        case .formVariant(_, let base, let modifier):
            signValue = base
            modifiers = modifier
        case .null:
            signValue = ""
        }
        return (signValue, modifiers)
    }
    
    public func getExtendedAttributes() -> [NSAttributedString.Key: Any] {
        var attributes = [NSAttributedString.Key:Any]()
        let (signValue, modifiers) = getSignValueAndModifiers()
        
        attributes[.signValue] = signValue
        if let modifiers = modifiers { attributes[.signModifiers] = modifiers.description }
        return attributes
    }
    
    @available(macOS 12, iOS 15, *)
    public func getExtendedAttributeValues() -> AttributeContainer {
        var container = AttributeContainer()
        let (signValue, modifiers) = getSignValueAndModifiers()
        container.signValue = signValue
        if let modifiers {
            container.modifiers = modifiers
        }
        return container
    }
}
