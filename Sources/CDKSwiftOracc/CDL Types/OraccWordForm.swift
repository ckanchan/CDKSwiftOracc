//
//  OraccWordForm.swift
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

public struct WordForm {
    public struct Translation: Decodable {
        public let guideWord: String?
        public let citationForm: String?
        public let sense: String?
        public let partOfSpeech: String?
        public let effectivePartOfSpeech: String?
        
        public init(guideWord: String?, citationForm: String?, sense: String?, partOfSpeech: String?, effectivePartOfSpeech: String?) {
            self.guideWord = guideWord
            self.citationForm = citationForm
            self.sense = sense
            self.partOfSpeech = partOfSpeech
            self.effectivePartOfSpeech = effectivePartOfSpeech
        }
    }
    
    public let language: Language
    public let form: String
    public let graphemeDescriptions: [GraphemeDescription]
    public let normalisation: String?
    public let translation: Translation
    public let delimiter: String?
    
    public init(language: Language, form: String, graphemeDescriptions: [GraphemeDescription], normalisation: String?, translation: Translation, delimiter: String?){
        self.language = language
        self.form = form
        self.graphemeDescriptions = graphemeDescriptions
        self.normalisation = normalisation
        self.translation = translation
        self.delimiter = delimiter
    }
    
    
}

extension WordForm: Decodable {
    enum CodingKeys: String, CodingKey {
        case lang, form, delim, gdl, cf, gw, sense, norm, pos, epos
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WordForm.CodingKeys.self)
        let lang = try container.decodeIfPresent(String.self, forKey: .lang)
        let form = try container.decode(String.self, forKey: .form)
        let graphemeDescriptions = try container.decode([GraphemeDescription].self, forKey: .gdl)
        let normalisation = try container.decodeIfPresent(String.self, forKey: .norm)
        let delimiter = try container.decodeIfPresent(String.self, forKey: .delim)
        
        // Try and get translation fields
        var guideWord = try container.decodeIfPresent(String.self, forKey: .gw)
        let citationForm = try container.decodeIfPresent(String.self, forKey: .cf)
        var sense = try container.decodeIfPresent(String.self, forKey: .sense)
        let partOfSpeech = try container.decodeIfPresent(String.self, forKey: .pos)
        let effectivePartOfSpeech = try container.decodeIfPresent(String.self, forKey: .epos)
        
        // If a proper name, reassign guideWord and Sense fields to the proper name
        if let gw = guideWord {
            if gw == "1" {
                guideWord = citationForm
                sense = citationForm
            }
        }
        
        
        let translation = Translation(guideWord: guideWord, citationForm: citationForm, sense: sense, partOfSpeech: partOfSpeech, effectivePartOfSpeech: effectivePartOfSpeech)
        
        let language = Language(withCode: lang ?? "unknown")
        
        self.init(language: language, form: form, graphemeDescriptions: graphemeDescriptions, normalisation: normalisation, translation: translation, delimiter: delimiter)
    }
}

extension WordForm: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let lang: String
        switch language {
        case .Akkadian(let dialect):
            lang = dialect.rawValue
        case .Sumerian(let dialect):
            lang = dialect.rawValue
        case .Hittite:
            lang = "hit"
        case .Other(let o):
            lang = o
        }
        
        try container.encode(lang, forKey: .lang)
        try container.encode(form, forKey: .form)
        try container.encode(graphemeDescriptions, forKey: .gdl)
        try container.encodeIfPresent(normalisation, forKey: .norm)
        try container.encodeIfPresent(delimiter, forKey: .delim)
        try container.encodeIfPresent(translation.guideWord, forKey: .gw)
        try container.encodeIfPresent(translation.citationForm, forKey: .cf)
        try container.encodeIfPresent(translation.sense, forKey: .sense)
        try container.encodeIfPresent(translation.partOfSpeech, forKey: .pos)
        try container.encodeIfPresent(translation.effectivePartOfSpeech, forKey: .epos)
        
    }
}
