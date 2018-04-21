//
//  InterfaceProtocol.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 01/01/2018.
//

import Foundation

public enum InterfaceType {
    case Github, Oracc
}

/**
 Protocol adopted by framework interface objects. Exposes a public API for selecting Oracc catalogues, querying the texts within, and getting output from them.
 */

public protocol OraccInterface {
    var decoder: JSONDecoder { get }
    
    var oraccProjects: [OraccProjectEntry] { get }
    var availableVolumes: [OraccProjectEntry] { get }
    func getOraccProjects() throws -> [OraccProjectEntry]
    
    
    func getAvailableVolumes(_ completion: @escaping ([OraccProjectEntry])  -> Void) throws
    
    func loadCatalogue(_ volume: OraccProjectEntry) throws -> OraccCatalog
    
    func loadText(_ key: String, inCatalogue catalogue: OraccCatalog) throws -> OraccTextEdition
    
    func loadText(_ textEntry: OraccCatalogEntry) throws -> OraccTextEdition
    
    func loadGlossary(_ glossary: OraccGlossaryType, inCatalogue catalogue: OraccCatalog) throws -> OraccGlossary
    
    func loadGlossary(_ glossary: OraccGlossaryType, catalogueEntry: OraccCatalogEntry) throws -> OraccGlossary
}

extension OraccInterface {
    
    /**
     Fetches and decodes an array of all projects hosted on Oracc.
     - Returns: An array of `OraccProjectEntry` where each entry represents an Oracc project.
     - Throws: `InterfaceError.JSONError.unableToDecode` if the remote JSON cannot be parsed.
     */
    
    public func getOraccProjects() throws -> [OraccProjectEntry]{
        guard let listData = try? Data(contentsOf: URL(string: "http://oracc.museum.upenn.edu/projectlist.json")!) else {throw InterfaceError.cannotSetResourceURL}
        
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
    
    func loadGlossary(_ url: URL) throws -> OraccGlossary {
        guard let jsonData = try? Data(contentsOf: url) else { throw InterfaceError.GlossaryError.notAvailable}
        
        do {
            let glossaryLoaded = try decoder.decode(OraccGlossary.self, from: jsonData)
            return glossaryLoaded
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
    case cannotSetResourceURL
    
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
    
    enum GlossaryError: Error {
        case notAvailable
    }
    
    case Unimplemented(String)
}
