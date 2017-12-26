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
    var dataLocation: URL?
    weak var interface: OraccJSONtoSwiftInterface?
    
    init() {
        self.interface = nil
    }
    
    public func getAvailableVolumes() -> [SAAVolumes]? {
        let saaoPath = resourcePath + "/saao"
        guard fileManager.fileExists(atPath: saaoPath) else {
            print("Error: No volumes available")
            return nil
        }
        
        let volumePaths = fileManager.subpaths(atPath: saaoPath)
        
        if let volumePaths = volumePaths {
            let volumes = volumePaths.map {
                SAAVolumes(rawValue: $0)!
            }
            return volumes
        } else {
            print("Error: no volumes downloaded")
            return nil
        }
        
    }
    
    func downloadSAAVolume(_ vol: SAAVolumes) {
        self.downloadJSONArchive(vol.gitHubZipForm)
    }
    
    func downloadJSONArchive(_ archive: String) {
        let archivePath = "\(githubPath)\(archive).zip?raw=true"
        //let localSuffix = archive.replacingOccurrences(of: "-", with: "/")
        guard let archiveURL = URL(string: archivePath) else {return}
        
        let request = URLRequest(url: archiveURL)
        let task = session.downloadTask(with: request) {
            (data, response, error) -> Void in
            
            if let data = data {
                let destinationString = "\(self.resourcePath)/\(archive).zip"
                let destinationURL = URL(fileURLWithPath: destinationString)
                if self.fileManager.fileExists(atPath: destinationString) {
                    self.dataLocation = try! self.fileManager.replaceItemAt(destinationURL, withItemAt: data)
                } else {
                    try! self.fileManager.moveItem(at: data, to: destinationURL)
                    self.dataLocation = destinationURL
                }
            }
            
            if let destination = self.unzipJSONData() {
                self.unzipped(destination)
            }
            
        }
        
        task.resume()
    }

    private func unzipJSONData() -> URL? {
        guard self.dataLocation != nil else {
            print("Error: no data downloaded")
            return nil
        }
        let resourceURL = URL(fileURLWithPath: self.resourcePath, isDirectory: true)
        
        do {
            try self.fileManager.unzipItem(at: self.dataLocation!, to: resourceURL)
            return resourceURL
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func unzipped(_ destination: URL) {
        
    }
    
}


extension SAAVolumes {
    var directoryForm: String {
        switch self {
        case .saa01:
            return "saa01"
        case .saa02:
            return "saa02"
        case .saa03:
            return "saa03"
        case .saa04:
            return "saa04"
        case .saa05:
            return "saa05"
        case .saa06:
            return "saa06"
        case .saa07:
            return "saa07"
        case .saa08:
            return "saa08"
        case .saa09:
            return "saa09"
        case .saa10:
            return "saa10"
        case .saa11:
            return "saa11"
        case .saa12:
            return "saa12"
        case .saa13:
            return "saa13"
        case .saa14:
            return "saa14"
        case .saa15:
            return "saa15"
        case .saa16:
            return "saa16"
        case .saa17:
            return "saa17"
        case .saa18:
            return "saa18"
        case .saa19:
            return "saa19"
        case .saa20:
            return "saa20"
        }
    }
    
    var gitHubZipForm: String {
        return "saao-\(self.directoryForm)"
    }
}

