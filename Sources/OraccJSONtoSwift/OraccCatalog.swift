//
//  OraccCatalog.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 01/01/2018.
//

import Foundation

public struct OraccCatalog: Decodable {
    public let source: URL
    public let project: String
    public let members: [String: OraccCatalogEntry]
    
    
    public lazy var keys: [String] = {
        var keys = [String]()
        for entry in self.members.keys {
            keys.append(entry)
        }
        return keys
    }()
    
    public mutating func sortBySAANum() {
        let sortedMembers = members.sorted {
            return $0.value.SAAid < $1.value.SAAid
        }
        keys = sortedMembers.map{$0.key}
    }
}
