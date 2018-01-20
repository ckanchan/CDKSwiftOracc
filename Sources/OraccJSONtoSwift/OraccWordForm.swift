//
//  OraccWordForm.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 08/01/2018.
//

import Foundation

public struct WordForm {
    public struct Translation: Decodable {
        let guideWord: String?
        let citationForm: String?
        let sense: String?
        let partOfSpeech: String?
        let effectivePartOfSpeech: String?
    }
    
    let language: Language
    let form: String
    let graphemeDescriptions: [GraphemeDescription]
    let normalisation: String?
    let translation: Translation
    let delimiter: String?
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
