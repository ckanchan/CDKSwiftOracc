//
//  OraccToSwiftInterface.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 04/01/2018.
//

import Foundation

public class OraccToSwiftInterface: OraccInterface {
    
    let decoder = JSONDecoder()
    lazy var oraccProjects: [OraccProjectEntry] = {
        do {
            return try getOraccProjects()
        } catch {
            return []
        }
    }()
    
    lazy var availableVolumes: [OraccProjectEntry] = {
        return oraccProjects
    }()
    
    public func getAvailableVolumes(_ completion: @escaping ([OraccProjectEntry]) -> Void) throws {
        completion(availableVolumes)
    }
    
    public func loadCatalogue(_ volume: OraccProjectEntry, completion: @escaping (OraccCatalog) -> Void) throws {
        throw InterfaceError.Unimplemented("Oracc.org isn't serving JSON catalogues right now")
    }
    
    public func loadText(_ key: String, inCatalogue catalogue: OraccCatalog) throws -> OraccTextEdition {
        throw InterfaceError.Unimplemented("Oracc.org isn't serving JSON texts right now")
    }
}

