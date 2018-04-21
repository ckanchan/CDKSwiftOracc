////
////  OraccToSwiftInterface.swift
////  OraccJSONtoSwift
////
////  Created by Chaitanya Kanchan on 04/01/2018.
////
//
//import Foundation
//
//public class OraccToSwiftInterface: OraccInterface {
//    
//    public let decoder = JSONDecoder()
//    lazy public var oraccProjects: [OraccProjectEntry] = {
//        do {
//            return try getOraccProjects()
//        } catch {
//            return []
//        }
//    }()
//    
//    lazy public var availableVolumes: [OraccProjectEntry] = {
//        return oraccProjects
//    }()
//    
//    public func loadCatalogue(_ volume: OraccProjectEntry) throws -> OraccCatalog  {
//        if volume.pathname == "rinap/rinap4" {
//            let catalogueURL = URL(string: "http://oracc.museum.upenn.edu/rinap/rinap4/catalogue.json")!
//            
//            do {
//                let data = try Data(contentsOf: catalogueURL)
//                return try decoder.decode(OraccCatalog.self, from: data)
//            } catch {
//                throw error
//            }
//        }
//        
//        throw InterfaceError.Unimplemented("Oracc.org isn't serving JSON catalogues right now")
//    }
//
//    
//    public func loadGlossary(_ glossary: OraccGlossaryType, inCatalogue catalogue: OraccCatalog) throws -> OraccGlossary {
//        throw InterfaceError.Unimplemented("Oracc doesn't provide glossaries right now")
//    }
//    
//    public func loadGlossary(_ glossary: OraccGlossaryType, catalogueEntry: OraccCatalogEntry) throws -> OraccGlossary {
//        throw InterfaceError.Unimplemented("Oracc doesn't provide glossaries right now")
//    }
//    
//    public func getAvailableVolumes(_ completion: @escaping ([OraccProjectEntry]) -> Void) throws {
//        completion(availableVolumes)
//    }
//    
//    public func loadText(_ key: String, inCatalogue catalogue: OraccCatalog) throws -> OraccTextEdition {
//        
//        let url = URL(string: "http://oracc.museum.upenn.edu")!.appendingPathComponent(catalogue.project).appendingPathComponent("corpusjson").appendingPathComponent(key).appendingPathExtension("json")
//        guard let data = try? Data(contentsOf: url) else {  throw InterfaceError.Unimplemented("Oracc.org isn't serving JSON texts right now")}
//        
//        do {
//            return try decoder.decode(OraccTextEdition.self, from: data)
//        } catch {
//            throw InterfaceError.JSONError.unableToDecode(swiftError: error.localizedDescription)
//        }
//
//    }
//    
//    public func loadText(_ textEntry: OraccCatalogEntry) throws -> OraccTextEdition {
//        throw InterfaceError.Unimplemented("Oracc.org isn't serving JSON right now.")
//    }
//    
//    public init() {
//        print("Warning: Oracc does not serve JSON for most of its projects. This is implemented for future support only.")
//    }
//}
//
