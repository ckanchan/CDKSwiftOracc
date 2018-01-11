//
//  OraccGlossary.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 07/01/2018.
//

import Foundation

/// Enumeration for Oracc glossary categories
public enum OraccGlossaryType: String {
    case akkadian = "gloss-akk"
    case neoAssyrian = "gloss-akk-x-neoass"
    case divineNames = "gloss-qpn-x-divine"
    case ethnicNames = "gloss-qpn-x-ethnic"
    case monthNames = "gloss-qpn-x-months"
    case peopleNames = "gloss-qpn-x-people"
    case placeNames = "gloss-qpn-x-places"
    case templeNames = "gloss-qpn-x-temple"
    case waterBodyNames = "gloss-qpn-x-waters"
    
    var jsonName: String {
        return "\(self.rawValue).json"
    }
}

/// Class representing an Oracc glossary
public class OraccGlossary: Decodable {
    public let project: String
    public let lang: String
    public let entries: [GlossaryEntry]
}


/// An Oracc glossary entry
public struct GlossaryEntry: Decodable, CustomStringConvertible {
    
    // MARK :- Helper types
    /// Encodes information about individual spellings for a given headword.
    public struct Form: Decodable {
        
        /// Spelling of a lemma, given in transliteration. Not given for forms of type "normform"
        public let spelling: String?
        
        /// For 'normforms', a reference to the concrete form.
        public let reference: String?
        
        /// A unique ID for this spelling.
        public let id: String
        
        /// The number of times this spelling appears in the corpus
        public let instanceCount: String
        
        /// The percentage of spellings this form makes up within the corpus.
        public let instancePercentage: String
        
        enum CodingKeys: String, CodingKey {
            case spelling = "n"
            case reference = "ref"
            case id
            case instanceCount = "icount"
            case instancePercentage = "ipct"
        }
        
    }
    
    /// Encodes information about the normalisations of spellings made by translators and editors.
    public struct Norm: Decodable, CustomStringConvertible {
        
        public let id: String
        public let normalisation: String
        public let instanceCount: String
        public let instancePercentage: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case normalisation = "n"
            case instanceCount = "icount"
            case instancePercentage = "ipct"
        }
        
        public var description: String {
            return normalisation
        }
    }
    
    public struct Sense: Decodable, CustomStringConvertible {
        public let id: String
        public let headWord: String?
        public let meaning: String?
        public let partOfSpeech: String?
        
        enum codingKeys: String, CodingKey {
            case id
            case headWord = "n"
            case meaning = "mng"
            case partOfSpeech = "pos"
        }
        
        public var description: String {
            var str =  "\(headWord ?? "")"
            if let m = meaning {
                str.append(" Meaning: \(m)")
            }
            return str
        }
    }
    
    /// Unique ID for entry
    public let id: String
    
    /// Main heading for entry, formatted as `entry[translation]POS`
    public let headWord: String
    
    /// Conventional citation form as found in the Concise Dictionary of Akkadian
    public let citationForm: String
    
    /// Guide translation
    public let guideWord: String?
    
    /// Part of speech
    public let partOfSpeech: String?
    
    /// Number of times this headword appears in the corpus
    public let instanceCount: String
    
    
    /// Transliterated spellings found in the corpus
    public let forms: [Form]?
    
    /// Transcriptions of spellings suggested by editors
    public let norms: [Norm]?
    
    /// Various senses for translation
    public let senses: [Sense]?
    
    
    enum CodingKeys: String, CodingKey {
        case headWord = "headword"
        case citationForm = "cf"
        case guideWord = "gw"
        case partOfSpeech = "pos"
        case instanceCount = "icount"
        case forms, norms, senses, id
    }
    
    public var description: String {
        var str = "\(headWord)\n\(citationForm), \(guideWord ?? "")"
        
        if let forms = forms {
            str.append("\nForms: \(forms)")
        }
        
        return str
    }
}
