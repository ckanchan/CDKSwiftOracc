//
//  OraccToSwiftInterface.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 04/01/2018.
//

import Foundation

public class OraccToSwiftInterface: OraccInterface {
    public func loadCatalogueSync(_ volume: OraccProjectEntry) throws -> OraccCatalog {
        throw InterfaceError.Unimplemented("Oracc isn't providing a JSON API right now.")
    }
    
    public func loadGlossary(_ glossary: OraccGlossaryType, inCatalogue catalogue: OraccCatalog) throws -> OraccGlossary {
        throw InterfaceError.Unimplemented("Oracc doesn't provide glossaries right now")
    }
    
    public func loadGlossary(_ glossary: OraccGlossaryType, catalogueEntry: OraccCatalogEntry) throws -> OraccGlossary {
        throw InterfaceError.Unimplemented("Oracc doesn't provide glossaries right now")
    }
    
    
    public let decoder = JSONDecoder()
    lazy public var oraccProjects: [OraccProjectEntry] = {
        do {
            return try getOraccProjects()
        } catch {
            return []
        }
    }()
    
    lazy public var availableVolumes: [OraccProjectEntry] = {
        return oraccProjects
    }()
    
    public func getAvailableVolumes(_ completion: @escaping ([OraccProjectEntry]) -> Void) throws {
        completion(availableVolumes)
    }
    
    public func loadCatalogue(_ volume: OraccProjectEntry) throws -> OraccCatalog  {
        throw InterfaceError.Unimplemented("Oracc.org isn't serving JSON catalogues right now")
    }
    
    public func loadText(_ key: String, inCatalogue catalogue: OraccCatalog) throws -> OraccTextEdition {
        throw InterfaceError.Unimplemented("Oracc.org isn't serving JSON texts right now")
    }
    
    public func loadText(_ textEntry: OraccCatalogEntry) throws -> OraccTextEdition {
        throw InterfaceError.Unimplemented("Oracc.org isn't serving JSON right now.")
    }
}

