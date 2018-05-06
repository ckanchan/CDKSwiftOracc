//
//  OraccCDLNode.swift
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

public enum OraccCDLDecodingError: Error {
    case unableToDecode(String)
}


/// A single node in an Oracc CDL nested representation of a cuneiform document.
public enum OraccCDLNode {
    
    /// A single unit of meaning, in cuneiform and translated forms. Summary information is included in the top-level properties; more detailed information can be accessed under the Form property and its Translation and GraphemeDescription fields.
    public struct Lemma: Equatable, Hashable, CustomStringConvertible {
        public var hashValue: Int {
            return reference.hashValue
        }
        
        public static func ==(lhs: OraccCDLNode.Lemma, rhs: OraccCDLNode.Lemma) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        public var description: String {
            return self.wordForm.form + " " + (self.wordForm.translation.sense ?? "")
        }
        
        /// Transliteration with diacritical marks.
        public let fragment: String
        
        /// String key containing normalisation[translation]partofspeech
        public let instanceTranslation: String?
        
        /// Detailed wordform information
        public let wordForm: WordForm
        
        /// Reference for glossary lookup
        public let reference: String
        
        public var transliteration: String {
            var str = ""
            for grapheme in self.wordForm.graphemeDescriptions {
                str.append(grapheme.transliteration)
            }
            return str
        }
        
        public init(fragment: String, instanceTranslation: String?, wordForm: WordForm, reference: String) {
            self.fragment = fragment
            self.instanceTranslation = instanceTranslation
            self.wordForm = wordForm
            self.reference = reference
        }

    
    }
    
    /// A 'chunk' of a cuneiform document, as interpreted by an editor. Contains an array of `OraccCDLNode`.
    public struct Chunk: CustomStringConvertible {
        public enum Chunktype: String {
            case sentence, text, phrase, discourse
        }
        
        public let type: Chunktype
        public let cdl: [OraccCDLNode]
        
        public var description: String {
            return self.type.rawValue
        }
    }
    
    /// Represents breaks on the tablet, whether line-breaks or physical damage
    public struct Discontinuity: CustomStringConvertible {
        public enum DiscontinuityType: String {
            case bottom, broken = "nonx", cellStart = "cell-start", cellEnd = "cell-end", column, edge, envelope, excised, fieldStart = "field-start", left, obverse, object, linestart = "line-start", punct, right, reverse, surface, tablet, top, uninscribed = "nonw"
            
            //case nonx
            //case nonw
        }
        
        public let type: DiscontinuityType
        public let label: String?
        
        public var description: String {
            return "\(self.type) \(self.label ?? "")"
        }
    }
    
    /// Unknown usage...
    public struct Linkset: Codable {
        struct Link: Codable {
            let type: String
            let xlink_title: String
        }
    }
    
    /// Base element of a cuneiform document: a `Chunk` representing a section of text, which contains further `Chunk`s, `Discontinuity` or `Lemma`. The abbreviated `c`, `d`, `l`, cases reflect the Oracc usage.
   
        case l(Lemma)
        case c(Chunk)
        case d(Discontinuity)
        case linkbase([Linkset])
  
}

extension OraccCDLNode: Decodable {
    enum CodingKeys: String, CodingKey {
        case fragment = "frag"
        case instanceTranslation = "inst"
        case wordForm = "f"
        case sense = "sense"
        case norm = "norm"
        case type = "type"
        case cdl = "cdl"
        case node = "node"
        case linkbase = "linkbase"
        case label = "label"
        case reference = "ref"
        case choices
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let node = try container.decodeIfPresent(String.self, forKey: .node)
        
        if let node = node {
            switch node {
            case "d":
                let type = try container.decode(String.self, forKey: .type)
                let label = try container.decodeIfPresent(String.self, forKey: .label)
                let d = OraccCDLNode.Discontinuity(type: OraccCDLNode.Discontinuity.DiscontinuityType(rawValue: type)!, label: label)
                self = OraccCDLNode.d(d)
                
            case "l":
                let frag = try container.decode(String.self, forKey: .fragment)
                let inst = try container.decodeIfPresent(String.self, forKey: .instanceTranslation)
                let f = try container.decode(WordForm.self, forKey: .wordForm)
                let ref = try container.decode(String.self, forKey: .reference)
                
               
                
                let l = OraccCDLNode.Lemma(fragment: frag, instanceTranslation: inst, wordForm: f, reference: ref)
                self = OraccCDLNode.l(l)
                
            case "ll":
                let choices = try container.decode([OraccCDLNode].self, forKey: .choices)
                self = choices.first!
                
            case "c":
                let type = try container.decode(String.self, forKey: .type)
                let cdl = try container.decode([OraccCDLNode].self, forKey: .cdl)
                let chunktype = OraccCDLNode.Chunk.Chunktype(rawValue: type)!
                let c = OraccCDLNode.Chunk(type: chunktype, cdl: cdl)
                self = OraccCDLNode.c(c)
                
            default:
                let error: Error = "Error!" as! Error
                throw error
            }
        }
        else {
            let linkbase = try container.decodeIfPresent([Linkset].self, forKey: .linkbase)
            
            if let linksets = linkbase {
                self = OraccCDLNode.linkbase(linksets)
                
            } else {
                throw OraccCDLDecodingError.unableToDecode("at node: \(node ?? "unknown node")")
            }
        }
    }
}

extension OraccCDLNode: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .l(let lemma):
            try container.encode("l", forKey: .node)
            try container.encode(lemma.fragment, forKey: .fragment)
            try container.encodeIfPresent(lemma.instanceTranslation, forKey: .instanceTranslation)
            try container.encodeIfPresent(lemma.wordForm, forKey: .wordForm)
            try container.encode(lemma.reference, forKey: .reference)
            
        case .c(let chunk):
            try container.encode("c", forKey: .node)
            try container.encode(chunk.type.rawValue, forKey: .type)
            try container.encode(chunk.cdl, forKey: .cdl)
            
        case .d(let d):
            try container.encode("d", forKey: .node)
            try container.encode(d.type.rawValue, forKey: .type)
            try container.encodeIfPresent(d.label, forKey: .label)
            
        case .linkbase(let linkSet):
            try container.encodeIfPresent(linkSet, forKey: .linkbase)
            
            
            break
        }
    }
}

public extension OraccCDLNode { //Text analysis functions
    public func transliterated() -> String {
        var str = ""
        switch self {
        case .l(let lemma):
            str.append(lemma.transliteration)
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.transliterated())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("Obverse: \n")
            case .linestart:
                str.append("\n\(discontinuity.label ?? "") ")
            case .reverse:
                str.append("\nReverse: \n")
            default:
                break
            }
        case .linkbase(_):
            break
        }
        return str
    }
    
    func normalised() -> String {
        var str = ""
        
        switch self {
        case .l(let lemma):
            str.append(lemma.wordForm.normalisation ?? "[x]")
            str.append(" ")
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.normalised())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("Obverse: \n")
            case .linestart:
                str.append("\n\(discontinuity.label ?? "") ")
            case .reverse:
                str.append("\n Reverse: \n")
            default:
                break
            }
            
        case .linkbase(_):
            break
        }
        
        return str
    }
    
    
    func literalTranslation() -> String {
        var str = ""
        
        switch self {
            
        case .linkbase(_):
            break
            
        case .l(let lemma):
            str.append(lemma.wordForm.translation.sense ?? "[?]")
            str.append(" ")
            
        case .c(let chunk):
            for node in chunk.cdl{
                str.append(node.literalTranslation())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("Obverse: \n")
            case .linestart:
                str.append("\n\(discontinuity.label ?? "") ")
            case .reverse:
                str.append("Reverse: \n")
            default:
                break
            }
        }
        return str
    }
    
    func cuneiform() -> String {
        var str = ""
        
        switch self {
        case .linkbase(_):
            break
            
        case .l(let lemma):
            for entry in lemma.wordForm.graphemeDescriptions {
                str.append(entry.cuneiform)
            }
            str.append(" ")
            
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.cuneiform())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("Obverse: \n")
            case .linestart:
                str.append("\n\(discontinuity.label ?? "") ")
            case .reverse:
                str.append("\n\nReverse:")
            default:
                break
            }
        }
        return str
    }
    
    func discontinuityTypes() -> Set<String> {
        var types = Set<String>()
        
        switch self {
            
        case .linkbase(_):
            break
            
        case .l(_):
            break
            
        case .c(let chunk):
            for node in chunk.cdl{
                types.formUnion(node.discontinuityTypes())
            }
        case .d(let discontinuity):
            types.insert(discontinuity.type.rawValue)
        }
        
        return types
    }
    
    func chunkTypes() -> Set<String> {
        var types = Set<String>()
        
        switch self {
            
        case .linkbase(_):
            break
            
        case .l(_):
            break
            
        case .c(let chunk):
            for node in chunk.cdl{
                types.insert(chunk.type.rawValue)
                types.formUnion(node.chunkTypes())
            }
        case .d(_):
            break
        }
        
        return types
    }
}

extension OraccCDLNode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .l(let lemma):
            return "Lemma: \(lemma)"
        case .c(let chunk):
            return "Chunk: \(chunk)"
        case .d(let discontinuity):
            return discontinuity.description
        case .linkbase(_):
            return ""
        }
    }
}
