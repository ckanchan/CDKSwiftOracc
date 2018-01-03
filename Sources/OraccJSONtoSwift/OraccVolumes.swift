//
//  OraccVolumes.swift
//  OraccJSONtoSwiftPackageDescription
//
//  Created by Chaitanya Kanchan on 27/12/2017.
//

import Foundation

/// Structure representing the decoded output of an Oracc JSON project list.
public struct OraccProjectEntry: Decodable {
    let pathname: String
    let abbrev: String
    let name: String
    let blurb: String
    
    var githubKey: String {
        return pathname.replacingOccurrences(of: "/", with: "-").appending(".zip")
    }
}

extension OraccProjectEntry: Equatable, Hashable {
    public var hashValue: Int {
        return pathname.hashValue ^ abbrev.hashValue ^ name.hashValue ^ blurb.hashValue
    }
    
    public static func ==(lhs: OraccProjectEntry, rhs: OraccProjectEntry) -> Bool {
        return lhs.pathname == rhs.pathname && lhs.blurb == rhs.blurb
    }
}

extension OraccProjectEntry: CustomDebugStringConvertible {
    public var debugDescription: String {
        let str =
        """
        name: \(name)
        abbrev: \(abbrev)
        pathname: \(pathname)
        githubKey: \(githubKey)
        blurb: \(blurb)
        """
        
        return str
    }
}

extension Array where Element == OraccProjectEntry {
    func debugPrint(){
        for element in self {
            print(element.debugDescription)
        }
    }
}

public struct OraccProjectList: Decodable {
    let type: String
    let projects: [OraccProjectEntry]
    }

