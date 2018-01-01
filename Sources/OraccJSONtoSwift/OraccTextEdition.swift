//
//  OraccTextEdition.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 01/01/2018.
//

import Foundation

public struct OraccTextEdition: Decodable {
    let type: String
    let project: String
    let cdl: [OraccCDLNode]
    let textid: String
    
}

public extension OraccTextEdition {
    public var transcription: String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.normalised())
        }
        
        return str
    }
    
    public var literalTranslation: String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.literalTranslation())
        }
        
        return str
    }
    
    public var cuneiform: String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.cuneiform())
        }
        
        return str
    }
    
    var discontinuityTypes: Set<String> {
        var types = Set<String>()
        
        for node in self.cdl {
            types.formUnion(node.discontinuityTypes())
        }
        return types
    }
    
    var chunkTypes: Set<String> {
        var types = Set<String>()
        
        for node in self.cdl {
            types.formUnion(node.chunkTypes())
        }
        return types
    }
}
