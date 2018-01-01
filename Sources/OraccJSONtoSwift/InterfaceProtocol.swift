//
//  InterfaceProtocol.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 01/01/2018.
//

import Foundation

/**
 Protocol adopted by framework interface objects. Exposes a public API for selecting Oracc catalogues, querying the texts within, and getting output from them.
 */

protocol Interface {
    var oraccProjects: [OraccProjectEntry] { get }
    var availableVolumes: [OraccProjectEntry] { get }
    func getOraccProjects() -> [OraccProjectEntry]
    
    
    func getAvailableVolumes(_ completion: @escaping (OraccProjectList) throws -> Void)
    
    func loadCatalogue(_ volume: OraccVolume, completion: @escaping (OraccCatalog) throws -> Void)
    
    func loadText(_ key: String, inCatalogue: OraccCatalog) throws -> OraccTextEdition
}

extension Interface {
    private func getOraccProjects() -> [OraccProjectEntry]{
        let listData = try! Data(contentsOf: URL(string: "http://oracc.museum.upenn.edu/projectlist.json")!)
        let projectList = self.decoder.decode(OraccProjectList.self, from: listData)
        return projectList.projects
    }
}







//MARK:- API Errors
/**
 Enumeration defining the errors that are returned from an interface object
 */

enum InterfaceError: Error {
    
    enum JSONError {
        case unableToDecode(swiftError: String)
    }
    
    enum ArchiveError {
        case unableToDownloadList
    }
    
    enum VolumeError {
        case notAvailable
    }
    
    enum CatalogueError {
        case notAvailable, doesNotContainText
    }
    
    enum TextError {
        case notAvailable
    }
}
