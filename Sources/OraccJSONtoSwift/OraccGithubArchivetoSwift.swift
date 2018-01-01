//
//  OraccGithubArchivetoSwift.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 01/01/2018.
//

import Foundation
import ZIPFoundation

public class OraccGithubtoSwift: Interface {
    
    let decoder = JSONDecoder()
    let session = URLSession(configuration: .default)
    let githubArchivePath = URL(string: "https://raw.githubusercontent.com/oracc/json/master/")
    
    let fileManager = FileManager.default
    let resourcePath = Bundle.main.resourcePath!

    
    
    // MARK: - Public API
    public var availableVolumes: [OraccProjectEntry]
    
    /// Downloads a list of available JSON ZIP archives from Github, and calls the supplied completion handler on them.
    func getArchiveList(_ completion: @escaping ([GithubArchiveEntry]) -> Void) throws {
        let listURL = URL(string: "https://api.github.com/repos/oracc/json/contents")!
        var data: Data
        do {
            data = try Data(contentsOf: listURL)
        } catch {
            throw InterfaceError.ArchiveError.unableToDownloadList
        }
        
        do {
            let archiveList = try self.decoder.decode([GithubArchiveEntry].self, from: data)
            
            completion(archiveList)
        } catch {
            throw InterfaceError.JSONError.unableToDecode(swiftError: error.localizedDescription)
        }
    }
    
    
    
    /// Presents a list of
    public func getAvailableVolumes(_ completion: @escaping (OraccProjectList) throws -> Void) {
        <#code#>
    }
    
    public func loadCatalogue(_ volume: OraccVolume, completion: @escaping (OraccCatalog) throws -> Void) {
        <#code#>
    }
    
    public func loadText(_ key: String, inCatalogue: OraccCatalog) throws -> OraccTextEdition {
        <#code#>
    }
    
    
}

struct GithubArchiveEntry: Decodable {
    public let name: String
    public let downloadURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case name, downloadURL = "download_url"
    }
}
