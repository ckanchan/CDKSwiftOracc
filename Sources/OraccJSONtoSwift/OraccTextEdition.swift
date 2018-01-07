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
    
    /// Computed transliteration. This is recalculated every time it is called so you will need to store it yourself.
    public var transliteration: String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.transliterated())
        }
        
        return str
    }
    
    /// Computed normalisation. This may not be applicable if a text has not been lemmatised. This is recalculated every time it is called so you will need to store it yourself.
    public var transcription: String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.normalised())
        }
        
        return str
    }
    
    /// Computed literal translation. This may not be applicable if a text has not been lemmatised. This is recalculated every time it is called so you will need to store it yourself.
    public var literalTranslation: String  {
        var str = ""
        
        for node in self.cdl {
            str.append(node.literalTranslation())
        }
        
        return str
    }
    
    /// Computed cuneiform. This is recalculated every time it is called so you will need to store it yourself.
    public var cuneiform: String  {
        var str = ""
        
        for node in self.cdl {
            str.append(node.cuneiform())
        }
        
        return str
    }
}

public extension OraccTextEdition {
    
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
