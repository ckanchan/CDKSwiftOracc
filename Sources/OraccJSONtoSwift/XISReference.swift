//
//  XISReference.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 15/02/2018.
//

import Foundation

public struct XISReference: CustomStringConvertible {
    public var description: String {
        return "\(project):\(cdliID)"
    }
    
    public let project: String
    public var cdliID: String {
        return String(reference.prefix{$0 != "."})
    }
    
    public let reference: String

    public init?(withReference key: String) {
        let elements = key.split(separator: ":")
        self.project = String(elements[0])
        self.reference = String(elements[1])
    }
    
    
    
}
