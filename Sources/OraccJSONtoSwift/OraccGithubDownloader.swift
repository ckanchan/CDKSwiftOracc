//
//  OraccGithubDownloader.swift
//  OraccJSONtoSwiftPackageDescription
//
//  Created by Chaitanya Kanchan on 25/12/2017.
//

import Foundation
import ZIPFoundation

public class OraccGithubDownloader {
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let githubPath = "https://github.com/oracc/json/blob/master/"
    let resourcePath = Bundle.main.resourcePath!
    let fileManager = FileManager.default
    weak var interface: OraccJSONtoSwiftInterface?
    
    init() {
        self.interface = nil
    }
    
    /// Gets a simple list of ZIP archives from Github. Deprecated.
    func getDownloadList(_ completion: @escaping ([OraccGithubtoSwift.GithubArchiveEntry]) -> Void) {
        let listURL = URL(string: "https://api.github.com/repos/oracc/json/contents")!
        
        do {
            let data = try Data(contentsOf: listURL)
            let ziplist = try interface!.decoder.decode([OraccGithubtoSwift.GithubArchiveEntry].self, from: data)
            completion(ziplist)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /*
 
    public func getAvailableVolumes() -> [OraccProjectEntry]? {
        let saaoPath = resourcePath + "/saao"
        guard fileManager.fileExists(atPath: saaoPath) else {
            print("Error: No volumes have been downloaded for local use")
            return nil
        }
        
        do {
            let volumePaths = try fileManager.contentsOfDirectory(atPath: saaoPath)
            let volumes = volumePaths.flatMap {OraccVolume(rawValue: $0)}
            return volumes
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    
    func downloadJSONArchive(_ vol: OraccVolume, completion: @escaping (OraccCatalog) -> Void) {
        let archive = vol.gitHubZipForm
        let archivePath = "\(githubPath)\(archive).zip?raw=true"
        var downloadLocation: URL?
        guard let archiveURL = URL(string: archivePath) else {return}
        
        //Initialise an asynchronous session to download the JSON ZIP archive
        let request = URLRequest(url: archiveURL)
        let task = session.downloadTask(with: request) {
            (data, response, error) -> Void in
            
            if let data = data {
                let destinationString = "\(self.resourcePath)/\(archive).zip"
                let destinationURL = URL(fileURLWithPath: destinationString)
                if self.fileManager.fileExists(atPath: destinationString) {
                    downloadLocation = try! self.fileManager.replaceItemAt(destinationURL, withItemAt: data)
                } else {
                    try! self.fileManager.moveItem(at: data, to: destinationURL)
                    downloadLocation = destinationURL
                }
            }
            
            // Unzip the JSON and, if successful, decode a catalogue from it and call the supplied completion handler.
            if let destination = self.unzipJSONData(at: downloadLocation!) {
                
                do {
                let data = try Data(contentsOf: destination)
                    let catalogue = try self.interface!.decoder.decode(OraccCatalog.self, from: data)
                completion(catalogue)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }

    private func unzipJSONData(at url: URL) -> URL? {
        let resourceURL = URL(fileURLWithPath: self.resourcePath, isDirectory: true)
        
        do {
            try self.fileManager.unzipItem(at: url, to: resourceURL)
            return resourceURL
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
 
 */
    
}




