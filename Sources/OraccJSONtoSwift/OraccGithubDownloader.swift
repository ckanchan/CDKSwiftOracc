//
//  OraccGithubDownloader.swift
//  OraccJSONtoSwiftPackageDescription
//
//  Created by Chaitanya Kanchan on 25/12/2017.
//

import Foundation
import ZIPFoundation

class OraccGithubDownloader {
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let githubPath = "https://github.com/oracc/json/blob/master/"
    let resourcePath = Bundle.main.resourcePath!
    private let fileManager = FileManager.default
    private var dataLocation: URL?
    
    
    private func downloadJSONArchive(_ archive: String) {
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
            
            _ = self.unzipJSONData()
            
        }
        
        task.resume()
    }
    
    func downloadSAAVolume(_ vol: Int) {
        guard let volume = SAAVolumes(rawValue: vol) else {
            print("Error: Volume not valid")
            return
        }
        self.downloadJSONArchive(volume.gitHubZipForm)
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
}


extension SAAVolumes {
    var gitHubZipForm: String {
        switch self {
        case .saa01:
            return "saao-saa01"
        case .saa02:
            return "saao-saa02"
        case .saa03:
            return "saao-saa03"
        case .saa04:
            return "saao-saa04"
        case .saa05:
            return "saao-saa05"
        case .saa06:
            return "saao-saa06"
        case .saa07:
            return "saao-saa07"
        case .saa08:
            return "saao-saa08"
        case .saa09:
            return "saao-saa09"
        case .saa10:
            return "saao-saa10"
        case .saa11:
            return "saao-saa1q"
        case .saa12:
            return "saao-saa12"
        case .saa13:
            return "saao-saa13"
        case .saa14:
            return "saao-saa14"
        case .saa15:
            return "saao-saa15"
        case .saa16:
            return "saao-saa16"
        case .saa17:
            return "saao-saa17"
        case .saa18:
            return "saao-saa18"
        case .saa19:
            return "saao-saa19"
        case .saa20:
            return "saao-saa20"
        }
    }
}

