//
//  OraccGithubArchivetoSwift.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 01/01/2018.
//

import Foundation
import ZIPFoundation


// Class that connects to Github and manages the decoding of texts from archives hosted there.

public class OraccGithubToSwiftInterface: OraccInterface {

    
    //MARK:- Helper type
    
    /// Represents a project archive that can be downloaded from Github
    struct GithubArchiveEntry: Decodable {
        let name: String
        
        /// Direct download URL for the zip file
        let downloadURL: URL
        
        private enum CodingKeys: String, CodingKey {
            case name, downloadURL = "download_url"
        }
    }
    
    
    //MARK: - Properties
    // Internet-related properties
    public let decoder = JSONDecoder()
    let session = URLSession(configuration: .default)
    let githubArchivePath = URL(string: "https://raw.githubusercontent.com/oracc/json/master/")!
    
    // File management properties
    let fileManager: FileManager
    var resourceURL: URL
    
    // Oracc directory properties
    
    /// Array of all projects hosted on Oracc
    lazy public var oraccProjects: [OraccProjectEntry] = {
        return try! self.getOraccProjects()
    }()
    
    /// Dictionary of Oracc projects keyed to their Github archive download URLs.
    lazy var keyedProjectList: [OraccProjectEntry: URL] = {
        let archiveList = try! getArchiveList()
        return try! loadKeyedProjectList(archiveList)
    }()
    
    
    //MARK:- Internal functions
    // Oracc directory loading functions
    
    func getArchiveList() throws -> [GithubArchiveEntry] {
        let listURL = URL(string: "https://api.github.com/repos/oracc/json/contents")!
        var data: Data
        do {
            data = try Data(contentsOf: listURL)
        } catch {
            throw InterfaceError.ArchiveError.unableToDownloadList
        }
        
        do {
            let archiveList = try self.decoder.decode([GithubArchiveEntry].self, from: data)
            
            return archiveList
        } catch {
            throw InterfaceError.JSONError.unableToDecode(swiftError: error.localizedDescription)
        }
    }

    func loadKeyedProjectList(_ archives: [GithubArchiveEntry]) throws -> [OraccProjectEntry: URL] {
        
        do {
            let archiveList = try getArchiveList()
            var keyedProjectList = [OraccProjectEntry: URL]()
            
            for archive in archiveList {
                if let project = oraccProjects.first(where: {$0.githubKey == archive.name}) {
                    keyedProjectList[project] = archive.downloadURL
                }
            }
            
            return keyedProjectList
            
        } catch {
            throw error
        }
    }
    

    // File management functions
    func downloadJSONArchive(_ vol: OraccProjectEntry) throws -> URL {
        let downloadURL = githubArchivePath.appendingPathComponent(vol.githubKey)
        let destinationURL = resourceURL.appendingPathComponent(vol.githubKey)
        
        
        guard let archive = try? Data(contentsOf: downloadURL) else { throw InterfaceError.ArchiveError.unableToDownloadArchive }
        guard !self.fileManager.fileExists(atPath: destinationURL.absoluteString) else { throw InterfaceError.ArchiveError.alreadyExists }
        
        do {
            try archive.write(to: destinationURL)
            return destinationURL
        } catch {
            throw InterfaceError.ArchiveError.unableToWriteArchiveToFile
        }
    }

    func unzipArchive(at url: URL, volume: OraccProjectEntry) throws -> OraccCatalog {
        let destinationPath = resourceURL.appendingPathComponent(volume.pathname)
        if fileManager.fileExists(atPath: destinationPath.path) {
            try! fileManager.removeItem(at: destinationPath)
        }
        
        do {
            try fileManager.unzipItem(at: url, to: resourceURL)
            let paths  = try fileManager.contentsOfDirectory(at: destinationPath, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
            if let catalogueURL = paths.first(where: {$0.lastPathComponent == "catalogue.json"}) {
                let catalogueData = try Data(contentsOf: catalogueURL)
                do {
                    return try decoder.decode(OraccCatalog.self, from: catalogueData)
                } catch {
                    throw InterfaceError.JSONError.unableToDecode(swiftError: error.localizedDescription)
                }
            } else {
                throw InterfaceError.ArchiveError.errorReadingArchive(swiftError: "No catalogue file found")
            }
        } catch {
            throw InterfaceError.ArchiveError.errorReadingArchive(swiftError: error.localizedDescription)
        }
    }
    
    func decompressItem(_ itemPath: String, inArchive archiveURL: URL) throws -> URL {
        guard let archive = Archive(url: archiveURL, accessMode: .read) else {
            throw InterfaceError.ArchiveError.errorReadingArchive(swiftError: "Does not exist")
        }
        
        guard let item = archive[itemPath] else {throw InterfaceError.ArchiveError.errorReadingArchive(swiftError: "File does not exist in archive")}
        
        let destinationURL = resourceURL.appendingPathComponent(itemPath)
        do {
            _ = try archive.extract(item, to: destinationURL)
        } catch {
            throw InterfaceError.ArchiveError.unableToWriteArchiveToFile
        }
        
        return destinationURL
        
    }
    
    
    // MARK: - Public API
    public lazy var availableVolumes: [OraccProjectEntry] = {
        return Array(keyedProjectList.keys)
    }()

    /** Returns a list of all the volume available for download from Github.
     
     - Parameter completion: completion handler which is passed the `OraccProjectEntry` array if and when loaded.
     
     */
    public func getAvailableVolumes(_ completion: @escaping ([OraccProjectEntry])  -> Void) throws {
        completion(availableVolumes)
    }
    
    
    
    
    /**
     Returns a decoded `OraccCatalog` object, from the local file if present, otherwise downloads the archive from Github, extracts the catalogue, and decodes and returns.
     
     - Parameter volume: An `OraccProjectEntry` from `availableVolumes` representing the desired volume.

     */
    
    public func loadCatalogue(_ volume: OraccProjectEntry) throws -> OraccCatalog {
        let cataloguePath = volume.pathname + "/catalogue.json"
        let localURL = resourceURL.appendingPathComponent(cataloguePath)
        let data: Data
        let catalogue: OraccCatalog
        do {
            if fileManager.fileExists(atPath: localURL.path) {
                data = try Data(contentsOf: localURL)
                catalogue = try decoder.decode(OraccCatalog.self, from: data)
            } else {
                let localArchiveURL = try downloadJSONArchive(volume)
                let catalogueURL = try decompressItem(cataloguePath, inArchive: localArchiveURL)
                data = try Data(contentsOf: catalogueURL)
                catalogue = try decoder.decode(OraccCatalog.self, from: data)
            }
            return catalogue
        } catch {
            throw error
        }
    }
    
    
    /**
     Loads the specified text ID from a given catalogue.
     - Parameter key: CDLI Text id of the text to be loaded
     - Parameter inCatalogue: Catalogue containing the text to be loaded.
     - Throws: Throws `InterfaceError.JSONError` if text cannot be decoded, `.TextError.notAvailable` if text cannot be found, `.ArchiveError` if retrieving the text directly from the Zip archive fails.
    */
    
    public func loadText(_ key: String, inCatalogue catalogue: OraccCatalog) throws -> OraccTextEdition {
        do {
            return try loadTextFromLocalFile(project: catalogue.project, key: key)
        } catch {
            throw error
        }
    }
    
    public func loadGlossary(_ glossary: OraccGlossaryType, inCatalogue catalogue: OraccCatalog) throws -> OraccGlossary {
        
        let itemPath = catalogue.project + "/" + glossary.jsonName
        let glossaryURL = resourceURL.appendingPathComponent(itemPath)
        var glossary: OraccGlossary? = nil
        
        
        if fileManager.fileExists(atPath: glossaryURL.path) {
            do {
                glossary = try loadGlossary(glossaryURL)
            } catch {
                throw error
            }
        } else {
            let archiveName = catalogue.project.replacingOccurrences(of: "/", with: "-") + ".zip"
            let archiveURL = resourceURL.appendingPathComponent(archiveName)
            do {
                let itemURL = try decompressItem(itemPath, inArchive: archiveURL)
                glossary = try loadGlossary(itemURL)
            } catch {
                throw InterfaceError.ArchiveError.errorReadingArchive(swiftError: error.localizedDescription)
            }
        }
        
        if let result = glossary {
            return result
        } else {
            throw InterfaceError.GlossaryError.notAvailable
        }
    }
    
    public func loadText(_ textEntry: OraccCatalogEntry) throws -> OraccTextEdition {
        do {
            return try loadTextFromLocalFile(project: textEntry.project, key: textEntry.id)
        } catch {
            throw error
        }
    }
    
    private func loadTextFromLocalFile(project: String, key: String) throws -> OraccTextEdition {
        let itemPath = project + "/corpusjson/" + key + ".json"
        let textURL = resourceURL.appendingPathComponent(itemPath)
        var text: OraccTextEdition? = nil
        let location: URL
        
        
        if fileManager.fileExists(atPath: textURL.path) {
            do {
                text = try loadText(textURL)
                location = textURL
            } catch {
                throw error
            }
        } else {
            let archiveName = project.replacingOccurrences(of: "/", with: "-") + ".zip"
            let archiveURL = resourceURL.appendingPathComponent(archiveName)
            do {
                let itemURL = try decompressItem(itemPath, inArchive: archiveURL)
                text = try loadText(itemURL)
                location = itemURL
            } catch {
                throw InterfaceError.ArchiveError.errorReadingArchive(swiftError: error.localizedDescription)
            }
        }
        
        if var result = text {
            result.loadedFrom = location
            return result
        } else {
            throw InterfaceError.TextError.notAvailable
        }
    }
    
    
    
    /** Changes the directory where archives are downloaded to another one specified by the user, if required. The default value is the user's temporary directory.
     - Parameter url: A URL object representing the desired resource path
     - Throws: `InterfaceError.cannotSetResourceURL`
 */
    public func setResourceURL(to url: URL) throws {
        guard fileManager.fileExists(atPath: url.path) else {throw InterfaceError.cannotSetResourceURL}
        self.resourceURL = url
    }
    
    
    /**
     Clears downloaded volumes from disk.
     */
    
    public func clearCaches() throws {
        do {
            try fileManager.removeItem(at: resourceURL)
        } catch {
            throw error
        }
    }
    
    public init() throws {
        self.fileManager = FileManager.default
        self.resourceURL = fileManager.temporaryDirectory.appendingPathComponent("oraccGithubCache")
        
        if !fileManager.fileExists(atPath: resourceURL.absoluteString) {
            do {
                try fileManager.createDirectory(at: resourceURL, withIntermediateDirectories: true, attributes: nil)} catch {
                    throw error
            }
        }
    }
}
