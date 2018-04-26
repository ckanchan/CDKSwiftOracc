//
//  OraccGlossary.swift
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

/// Enumeration for Oracc glossary categories
public enum OraccGlossaryType: String {
    case akkadian = "gloss-akk"
    case neoAssyrian = "gloss-akk-x-neoass"
    case neoBabylonian = "gloss-akk-x-neobab"
    case standardBabylonian = "gloss-akk-x-stdbab"
    
    case allProperNames = "gloss-qpn"
    case divineNames = "gloss-qpn-x-divine"
    case ethnicNames = "gloss-qpn-x-ethnic"
    case monthNames = "gloss-qpn-x-months"
    case peopleNames = "gloss-qpn-x-people"
    case placeNames = "gloss-qpn-x-places"
    case templeNames = "gloss-qpn-x-temple"
    case waterBodyNames = "gloss-qpn-x-waters"
}

/// Class representing an Oracc glossary
public final class OraccGlossary {
    public let project: String
    public let lang: String
    public let entries: [GlossaryEntry]
    
    /// Dictionary of XISReference paths to instances of a glossary entry in the corpus, keyed by the XISKey property. Use `instancesOf(_ entry: GlossaryEntry)` to access.
    public let instances: [String: [XISReference]]
    
    /// Dictionary of array indexes in `self.entries` keyed to citationForm. Not to be used directly.
    
    let citationFormIndex: [String: Int]
    
    /// Look up paths to instances of a specific glossary entry
    /// - Parameter entry: A 'GlossaryEntry' struct, which can be looked up directly in the `OraccGlossary.entries` array or through one of the lookup methods.
    public func instancesOf(_ entry: GlossaryEntry) -> [XISReference] {
        return self.instances[entry.xisKey]!
    }
    
    /// Gets the full entry for a specific citation form
    /// - Parameter citationForm: the CDA conventional form of the Akkadian lemma.
    public func lookUp(citationForm: String) -> GlossaryEntry? {
        guard let idx = citationFormIndex[citationForm] else { return nil }
        return self.entries[idx]
    }
    
    /// Gets a full entry for a text edition lemma, if present.
    /// - Parameter node: any OraccCDLNode within an OraccTextEdition.
    /// - Returns: `GlossaryEntry` if a valid lemma, `nil` if otherwise
    public func lookUp(node: OraccCDLNode) -> GlossaryEntry? {
        if case let OraccCDLNode.CDLNode.l(lemma) = node.node {
            guard let cf = lemma.wordForm.translation.citationForm else { return nil }
            return self.lookUp(citationForm: cf)
        } else {
            return nil
        }
    }
    
    /// Returns a set of texts containing the search term
    /// - Parameter citationForm: the CDA citation form of the search term
    /// - Parameter inCatalogue: the catalogue in which to perform the search, which must correspond to the catalogue from which the glossary is derived
    /// - Returns: `TextSearchCollection`, which conforms to the same interface as an OraccCatalog and thus can be used to display and look up results.
    
    public func searchResults(citationForm: String, inCatalogue catalogue: OraccCatalog) -> TextSearchCollection? {
        guard catalogue.project == self.project else { return nil }
        guard let entry = self.lookUp(citationForm: citationForm) else {return nil}
        let instances = self.instancesOf(entry)
        let searchIDs = instances.map{$0.reference}
        
        var resultSet = [String: OraccCatalogEntry]()
        
        for instance in instances {
            let id = instance.cdliID
            guard let result = catalogue.members[id] else { continue }
            
            resultSet[id] = result
        }
        
        
        return TextSearchCollection(searchTerm: citationForm, members: resultSet, searchIDs: searchIDs)
    }
    
    
    
    init(project: String, lang: String, entries: [GlossaryEntry], instances: [String: [XISReference]]) {
        self.project = project
        self.lang = lang
        self.entries = entries
        self.instances = instances
        
        self.citationFormIndex = {
            var index: [String: Int] = [:]
            
            for (idx, entry) in entries.enumerated() {
                index[entry.citationForm] = idx
            }
            
            return index
        }()
    }
    
    enum CodingKeys: String, CodingKey {
        case project, lang, entries, instances
    }
}

extension OraccGlossary: Decodable {
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let project = try container.decode(String.self, forKey: .project)
        let lang = try container.decode(String.self, forKey: .lang)
        let entries = try container.decode([GlossaryEntry].self, forKey: .entries)
        let instances = try container.decode([String: [String]].self, forKey: .instances)
        
        let xisInstances = instances.mapValues {
            return $0.map { return XISReference(withReference: $0)! }
        }
        
        self.init(project: project, lang: lang, entries: entries, instances: xisInstances)
    }
}


extension OraccGlossary: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(project, forKey: .project)
        try container.encode(lang, forKey: .lang)
        try container.encode(entries, forKey: .entries)
        
        let encodableInstances = instances.mapValues{$0.map{$0.description}}
        try container.encode(encodableInstances, forKey: .instances)
    }
}

/// An Oracc glossary entry
public struct GlossaryEntry: Codable, CustomStringConvertible {
    
    // MARK :- Helper types
    /// Encodes information about individual spellings for a given headword.
    public struct Form: Codable {
        
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
    public struct Norm: Codable, CustomStringConvertible {
        
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
    
    public struct Sense: Codable {
        
        public let id: String
        public let headWord: String
        public let meaning: String
        public let partOfSpeech: String
        public let signatures: [Signature]?
        
        enum CodingKeys: String, CodingKey {
            case id
            case headWord = "n"
            case meaning = "mng"
            case partOfSpeech = "pos"
            case signatures = "sigs"
        }
    }
    
    public struct Signature: Codable {
        public let signature: String
        
        enum CodingKeys: String, CodingKey {
            case signature = "sig"
        }
    }
    
    /// Unique ID for entry
    public let id: String
    
    /// Index key allowing lookup of references
    public let xisKey: String
    
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
        case xisKey = "xis"
        case forms, norms, senses, id
    }
    
    public var description: String {
        var str = "\(headWord)\n\(citationForm), \(guideWord ?? "")"
        
        if let forms = forms {
            str.append("\nForms: \(forms)")
        }
        
        return str
    }
    
    public init(id: String, xisKey: String, headWord: String, citationForm: String, guideWord: String?, partOfSpeech: String?, instanceCount: String, forms: [Form]?, norms: [Norm]?, senses: [Sense]?){
        
        self.id = id
        self.xisKey = xisKey
        self.headWord = headWord
        self.citationForm = citationForm
        self.guideWord = guideWord
        self.partOfSpeech = partOfSpeech
        self.instanceCount = instanceCount
        self.forms = forms
        self.norms = norms
        self.senses = senses
        
    }
}
