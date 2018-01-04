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

protocol OraccInterface {
    var decoder: JSONDecoder { get }
    
    var oraccProjects: [OraccProjectEntry] { get }
    var availableVolumes: [OraccProjectEntry] { get }
    func getOraccProjects() throws -> [OraccProjectEntry]
    
    
    func getAvailableVolumes(_ completion: @escaping ([OraccProjectEntry])  -> Void) throws
    
    func loadCatalogue(_ volume: OraccProjectEntry, completion: @escaping (OraccCatalog)  -> Void) throws
    
    func loadText(_ key: String, inCatalogue catalogue: OraccCatalog) throws -> OraccTextEdition
}

extension OraccInterface {
    /**
     Fetches and decodes an array of all projects hosted on Oracc.
     - Returns: An array of `OraccProjectEntry` where each entry represents an Oracc project.
     - Throws: `InterfaceError.JSONError.unableToDecode` if the remote JSON cannot be parsed.
     */
    
    func getOraccProjects() throws -> [OraccProjectEntry]{
        let listData = try! Data(contentsOf: URL(string: "http://oracc.museum.upenn.edu/projectlist.json")!)
        do {
            let projectList = try decoder.decode(OraccProjectList.self, from: listData)
            return projectList.projects
        } catch {
            throw InterfaceError.JSONError.unableToDecode(swiftError: error.localizedDescription)
        }
    }
    
    func loadText(_ url: URL) throws -> OraccTextEdition {
        guard let jsonData = try? Data(contentsOf: url) else {throw InterfaceError.TextError.notAvailable}
        
        do {
        let textLoaded = try decoder.decode(OraccTextEdition.self, from: jsonData)
        return textLoaded
        } catch {
            throw InterfaceError.JSONError.unableToDecode(swiftError: error.localizedDescription)
        }
    }
}


//MARK:- API Errors

/**
 Enumeration defining the errors that are returned from an interface object
 */

enum InterfaceError: Error {
    
    enum JSONError: Error {
        case unableToDecode(swiftError: String)
    }
    
    enum ArchiveError: Error {
        case unableToDownloadList
        case unableToDownloadArchive
        case alreadyExists
        case unableToWriteArchiveToFile
        case errorReadingArchive(swiftError: String)
    }
    
    enum VolumeError: Error {
        case notAvailable
    }
    
    enum CatalogueError: Error {
        case notAvailable, doesNotContainText
    }
    
    enum TextError: Error {
        case notAvailable
    }
    
    case Unimplemented(String)
}