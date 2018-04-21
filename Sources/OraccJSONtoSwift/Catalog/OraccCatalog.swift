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
}


