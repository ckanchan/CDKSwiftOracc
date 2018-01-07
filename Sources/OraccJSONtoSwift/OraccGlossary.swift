//
//  OraccGlossary.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 07/01/2018.
//

import Foundation

/// Enumeration for Oracc glossary categories
public enum OraccGlossaryType: String {
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
    public struct Form: Decodable, CustomStringConvertible {
        let n: String
        public var description: String {
            return n
        }
    }
    
    public struct Norm: Decodable, CustomStringConvertible {
        let n: String
        public var description: String {
            return n
        }
    }
    
    public struct Sense: Decodable, CustomStringConvertible {
        let n: String
        let meaning: String?
        
        enum codingKeys: String, CodingKey {
            case n
            case meaning = "mng"
        }
        
        public var description: String {
            var str =  "\(n)"
            if let m = meaning {
                str.append(" Meaning: \(m)")
            }
            return str
        }
    }
    
    /// Main heading for entry
    public let headword: String
    
    /// Rough meaning
    public let meaning: String?
    
    /// Transliterated spellings found in the corpus
    public let forms: [Form]?
    
    /// Transcriptions of spellings suggested by editors
    public let norms: [Norm]
    
    /// Various senses for translation
    public let senses: [Sense]
    
    enum CodingKeys: String, CodingKey {
        case headword
        case meaning = "gw"
        case forms, norms, senses
    }
    
    public var description: String {
        var str =   """
        \(headword)
        \(meaning ?? "n/a")
        Senses: \(senses)
        """
        
        if let forms = forms {
            str.append("\nForms: \(forms)")
        }
        
        return str
    }
}
