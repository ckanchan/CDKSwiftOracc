//
//  OraccCDLNode.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 01/01/2018.
//

import Foundation

public struct OraccCDLNode {
    public struct Lemma {
        let frag: String
        let inst: String?
        struct f: Decodable {
            let lang: String
            let form: String
            struct GraphemeDescription: Decodable {
                let gdl_utf8: String?
            }
            let gdl: [GraphemeDescription]
            let sense: String?
            let norm: String?
        }
        let f: f
    }
    
    public struct Chunk {
        enum Chunktype: String {
            case sentence, text, phrase, discourse
        }
        
        let type: Chunktype
        let cdl: [OraccCDLNode]
    }
    
    public struct Discontinuity {
        enum DiscontinuityType: String {
            case bottom, column, edge, excised, left, nonw, nonx, obverse, object, linestart = "line-start", punct, right, reverse, surface, top
        }
        let type: DiscontinuityType
        let label: String?
    }
    
    public struct Linkset: Decodable {
        struct Link: Decodable {
            let type: String
            let xlink_title: String
        }
    }
    
    public enum CDLNode {
        case l(Lemma)
        case c(Chunk)
        case d(Discontinuity)
        case linkbase([Linkset])
    }
    
    public let node: CDLNode
    
    
    init(lemma l: Lemma) {
        self.node = CDLNode.l(l)
    }
    
    init(chunk c: Chunk) {
        self.node = CDLNode.c(c)
    }
    
    init(discontinuity d: Discontinuity) {
        self.node = CDLNode.d(d)
    }
    
    init(linkbase lb: [Linkset]){
        self.node = CDLNode.linkbase(lb)
    }
}

extension OraccCDLNode: Decodable {
    enum CodingKeys: String, CodingKey {
        case frag = "frag"
        case inst = "inst"
        case f = "f"
        case sense = "sense"
        case norm = "norm"
        case type = "type"
        case cdl = "cdl"
        case node = "node"
        case linkbase = "linkbase"
        case label = "label"
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
                self = OraccCDLNode(discontinuity: d)
                
            case "l":
                let frag = try container.decode(String.self, forKey: .frag)
                let inst = try container.decodeIfPresent(String.self, forKey: .inst)
                let f = try container.decode(OraccCDLNode.Lemma.f.self, forKey: .f)
                let l = OraccCDLNode.Lemma(frag: frag, inst: inst, f: f)
                self = OraccCDLNode(lemma: l)
                
            case "c":
                let type = try container.decode(String.self, forKey: .type)
                let cdl = try container.decode([OraccCDLNode].self, forKey: .cdl)
                let chunktype = OraccCDLNode.Chunk.Chunktype(rawValue: type)!
                let c = OraccCDLNode.Chunk(type: chunktype, cdl: cdl)
                self = OraccCDLNode(chunk: c)
                
            default:
                let error: Error = "Error!" as! Error
                throw error
            }
        } else {
            let linkbase = try container.decodeIfPresent([Linkset].self, forKey: .linkbase)
            
            if let linksets = linkbase {
                self = OraccCDLNode.init(linkbase: linksets)
                
            } else {
                let error: Error = "Error!" as! Error
                throw error
            }
        }
    }
}

extension OraccCDLNode { //Text analysis functions
    func transliterated() -> String {
        var str = ""
        switch self.node {
        case .l(let lemma):
            str.append(lemma.frag + " ")
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.transliterated())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("Obverse: \n")
            case .linestart:
                str.append("\n\(discontinuity.label!) ")
            case .reverse:
                str.append("Reverse: \n")
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
        
        switch self.node {
        case .l(let lemma):
            str.append(lemma.f.norm ?? "[x]")
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
                str.append("\n\(discontinuity.label!) ")
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
        
        switch self.node {
            
        case .linkbase(_):
            break
            
        case .l(let lemma):
            str.append(lemma.f.sense ?? "[?]")
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
                str.append("\n\(discontinuity.label!) ")
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
        
        switch self.node {
        case .linkbase(_):
            break
            
        case .l(let lemma):
            for entry in lemma.f.gdl {
                str.append(entry.gdl_utf8 ?? "[]")
            }
            str.append(" ")
            
        case .c(let chunk):
            for node in chunk.cdl{
                str.append(node.cuneiform())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("Obverse: \n")
            case .linestart:
                str.append("\n\(discontinuity.label!) ")
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
        
        switch self.node {
            
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
        
        switch self.node {
            
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
