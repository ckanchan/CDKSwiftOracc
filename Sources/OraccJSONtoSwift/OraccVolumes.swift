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


public struct OraccProjectList: Decodable {
    let type: String
    let projects: [OraccProjectEntry]
    }
}
