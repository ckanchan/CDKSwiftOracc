//
//  OraccCDLNode+Codable.swift
//  CDKSwiftOracc: Cuneiform Documents for Swift
//  Copyright (C) 2019 Chaitanya Kanchan
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
    case malformedJSON
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
        case id = "id"
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
                let ref = try container.decode(NodeReference.self, forKey: .reference)
                
                
                
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
                throw OraccCDLDecodingError.malformedJSON
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
