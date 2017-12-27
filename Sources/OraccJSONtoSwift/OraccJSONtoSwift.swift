import Foundation

/**
 Base object for the framework. Initialise it with a source for Oracc JSON, then query it for text catalogues, individual texts within those catalogues, and cuneiform, transliteration and translation data for those texts.
 */

public class OraccJSONtoSwiftInterface {
    
    // Array of available volumes as enumerated entries.
    public var availableVolumes: [OraccVolume]
    
    let decoder = JSONDecoder()
    let path: String
    let location: JSONSource
    let downloader: OraccGithubDownloader?
    let oraccPath = URL(string:"http://www.oracc.org")!
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let fileManager = FileManager.default
    var downloadLocation: URL? = nil

    /**
     Represents possible locations that expose Oracc JSON data.
     - Oracc: Connects to http://oracc.org to get JSON data. Should be the most up to date, but most JSON isn't available yet.
     - Github: Connects to the Oracc Github repository which contains ZIP archives of JSON. Requires local disk space as the uncompressed archives are quite large.
     - Local: Takes a local path to JSON stored on disk. Useful for debugging.
     
 */
    
    public enum JSONSource {
        case github
        case oracc
        case local(String)
    }
    
    /**
     Initialises an OraccJSONtoSwiftInterface object that consumes JSON and returns Swift structs from the location specified. `.getAvailableVolumes()` must be called immediately after initialisation.
     - Parameter fromLocation: Takes a `JSONSource` value, with `local` requiring a local path specified.
 */
    
    
    public init(fromLocation location: JSONSource){
        switch location {
        case .github:
            self.location = location
            downloader = OraccGithubDownloader()
            self.path = self.downloader!.resourcePath
            availableVolumes = (downloader!.getAvailableVolumes())!
            
        case .oracc:
            self.location = location
            self.path = "http://oracc.org/"
            self.downloader = nil
            availableVolumes = []
            
        case .local(let localPath):
            self.location = location
            self.path = localPath
            self.downloader = nil
            availableVolumes = []
            
        }
    }
    
    
    /**
     Refreshes the list of available volumes from the data source. Must be called immediately after initialisation
 */
    public func getAvailableVolumes() {
        switch self.location {
        case .github:
            downloader!.interface = self
            availableVolumes = self.downloader!.getAvailableVolumes()!
        case .oracc:
            let request = URLRequest(url: oraccPath.appendingPathComponent("projects.json"))
            let task = session.dataTask(with: request) { (data, response, error) in
                if let projectJSON = data {
                        let projects = try! self.decoder.decode(OraccProjectList.self, from: projectJSON)
                        print(projects.projects)
                } else {
                    print("Error: no valid JSON downloaded")
                    if let err = error {
                        print(err)
                    }
                }
            }
            task.resume()
            
        case .local(_):
            do {
                let folders = try fileManager.subpathsOfDirectory(atPath: self.path)
                for folder in folders {
                    if let saa = OraccVolume(rawValue: folder) {
                        self.availableVolumes.append(saa)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /**
     Downloads and decodes an `OraccCatalogue` struct for the volume requested, then calls the supplied completion handler.
     
     - Parameter _: Takes an `OraccVolume` value.
     - Parameter completion: Called if an OraccCatalog has been successfully downloaded and decoded. Use the completion handler to store the returned OraccCatalog for querying.
 */
    public func loadCatalogue(_ volume: OraccVolume, completion: @escaping (OraccCatalog) -> Void){
        guard availableVolumes.contains(volume) else {
            print("Volume not available")
            return
        }
        
        switch self.location {
        case .local(let path):
            do {
                let catPath = path + volume.directoryForm + "catalogue.json"
                let data = try Data(contentsOf: URL(fileURLWithPath: catPath))
                let catalogue = try decoder.decode(OraccCatalog.self, from: data)
                completion(catalogue)
            } catch {
                print(error.localizedDescription)
            }
            
        case .oracc:
            do {
                let catPath = self.path + volume.directoryForm + "catalogue.json"
                let data = try Data(contentsOf: URL(string: catPath)!)
                let catalogue = try decoder.decode(OraccCatalog.self, from: data)
                completion(catalogue)
            } catch {
                print(error.localizedDescription)
            }
            
        case .github:
            downloader?.downloadJSONArchive(volume, completion: completion)
            }
        }    
    
    
    /**
     Queries a catalogue for the supplied Text ID and Catalogue and returns an `OraccText` struct that can be queried for text edition information.
     
     - Parameter _: Takes a string specifying the text you want, in CDLI Text ID format. Usually a P number (Pxxxxxx) but X and Q designations are also common.
     - Parameter inCatalogue: Searches an `OraccCatalog` for the text specified. If the text isnt't available then an error is printed and nothing is returned.
 */
    
    public func loadText(_ key: String, inCatalogue: OraccCatalog) -> OraccTextEdition? {
        let urlString = path + "\(inCatalogue.project)/corpusjson/\(key).json"
        let url = URL(fileURLWithPath: urlString)
        do {
            let jsonData = try Data(contentsOf: url)
            let textLoaded = try decoder.decode(OraccTextEdition.self, from: jsonData)
            return textLoaded
        } catch {
            print("\(error.localizedDescription)")
            return nil
        }
    }
}
