import Foundation


public class OraccJSONtoSwiftInterface {
    public let path: String
    public let decoder = JSONDecoder()
    public var availableVolumes: [SAAVolumes]
    private let location: JSONSource
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
     Initialises an OraccJSONtoSwiftInterface object that consumes JSON and returns Swift structs from the location specified.
     - Parameter fromLocation: Takes a `JSONSource` value, with `local` requiring a local path specified.
 */
    
    
    public init(fromLocation loc: JSONSource){
        switch loc {
        case .github:
            self.location = loc
            downloader = OraccGithubDownloader()
            self.path = self.downloader!.resourcePath
            availableVolumes = (downloader!.getAvailableVolumes())!
            
        case .oracc:
            self.location = loc
            self.path = "http://oracc.org/"
            self.downloader = nil
            availableVolumes = []
            
        case .local(let localPath):
            self.location = loc
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
                    if let saa = SAAVolumes(rawValue: folder) {
                        self.availableVolumes.append(saa)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func loadCatalogue(_ cat: SAAVolumes) -> OraccCatalog? {
        guard availableVolumes.contains(cat) else {
            print("Volume not available")
            return nil
        }
        
        switch self.location {
        case .local(_):
            return self.loadCatalogue(cat, source: self.location)
            
        case .oracc:
            return self.loadCatalogue(cat, source: self.location)
            
        case .github:
            downloader?.downloadSAAVolume(cat)
            return nil
            }
        }
    
    func loadCatalogue(_ cat: SAAVolumes, source: JSONSource) -> OraccCatalog? {
        switch self.location {
        case .local(let path):
            do {
                let catPath = path + cat.directoryForm + "catalogue.json"
                let data = try Data(contentsOf: URL(fileURLWithPath: catPath))
                let catalogue = try decoder.decode(OraccCatalog.self, from: data)
                return catalogue
            } catch {
                print(error.localizedDescription)
                return nil
            }
            
        case .oracc:
            do {
                let catPath = self.path + cat.directoryForm + "catalogue.json"
                let data = try Data(contentsOf: URL(string: catPath)!)
                let catalogue = try decoder.decode(OraccCatalog.self, from: data)
                return catalogue
            } catch {
                print(error.localizedDescription)
                return nil
            }
            
        default:
            print("Error, this should not be reached")
            return nil
        }
    }
    
    
    
    public func loadSAACatalogue(_ volume: Int) -> OraccCatalog? {
        switch volume {
        case 1:
            do {
                let catalogueURL = path + "saao/saa01/catalogue.json"
                let catalogueData = try Data(contentsOf: URL(fileURLWithPath: catalogueURL))
                let catalogue = try decoder.decode(OraccCatalog.self, from: catalogueData)
                return catalogue
            } catch {
                print(error.localizedDescription)
                return nil
            }
            
        case 5:
            do {
                let catalogueURL = path + "saao/saa05/catalogue.json"
                let catalogueData = try Data(contentsOf: URL(fileURLWithPath: catalogueURL))
                let catalogue = try decoder.decode(OraccCatalog.self, from: catalogueData)
                return catalogue
            } catch {
                print(error.localizedDescription)
                return nil
            }
            
        case 16:
            do {
                let catalogueURL = path + "saao/saa16/catalogue.json"
                let catalogueData = try Data(contentsOf: URL(fileURLWithPath: catalogueURL))
                let catalogue = try decoder.decode(OraccCatalog.self, from: catalogueData)
                return catalogue
            } catch {
                print(error.localizedDescription)
                return nil
            }
        default:
            print("Invalid")
            return nil
        }
    }
    
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

public struct OraccCatalog: Decodable {
    public let source: URL
    public let project: String
    public let members: [String: OraccCatalogEntry]
    
    
    public lazy var keys: [String] = {
        var keys = [String]()
        for entry in self.members.keys {
            keys.append(entry)
        }
        return keys
    }()
    
    public mutating func sortBySAANum() {
        let sortedMembers = members.sorted {
            return $0.value.SAAid < $1.value.SAAid
        }
        keys = sortedMembers.map{$0.key}
    }
}


public enum SAAVolumes: String {
    case saa01, saa02, saa03, saa04, saa05, saa06, saa07, saa08, saa09, saa10, saa11, saa12, saa13, saa14, saa15, saa16, saa17, saa18, saa19, saa20
}

public extension SAAVolumes {
    public var title: String {
        switch self {
        case .saa01:
            return "SAA I: The Correspondence of Sargon II, Part I: Letters from Assyria and the West"
        case .saa02:
            return "SAA II: Neo-Assyrian Treaties and Loyalty Oaths"
        case .saa03:
            return "SAA III: Court Poetry and Literary Miscellanea"
        case .saa04:
            return "SAA IV: Queries to the Sungod: Divination and Politics in Sargonid Assyria"
        case .saa05:
            return "SAA V: The Correspondence of Sargon II, Part II: Letters from the Northern and Northeastern Provinces"
        case .saa06:
            return "SAA VI: Legal Transactions of the Royal Court of Nineveh: Part I: Tiglath-Pileser III  through Esarhaddon"
        case .saa07:
            return "SAA VII: Imperial Administrative Records Part I: Papalce and Temple Administration"
        case .saa08:
            return "SAA VIII: Astrological Reports to Assyrian Kings"
        case .saa09:
            return "SAA IX: Assyrian Prophecies"
        case .saa10:
            return "SAA X: Letters from Assyrian and Babylonian Scholars"
        case .saa11:
            return "SAA XI: Imperial Administrative Records, Part II: Provincial and Military Administration"
        case .saa12:
            return "SAA XII: Grants, Decrees and Gifts of the Neo-Assyrian Period"
        case .saa13:
            return "SAA XIII: Letters from Assyrian and Babylonian Priests to Kings Esarhaddon and Assurbanipal"
        case .saa14:
            return "SAA XIV: Legal Transactions of the Royal Court of Nineveh, Part II: Assurbanipal through Sin-šarru-iškun"
        case .saa15:
            return "SAA XV: The Correspondence of Sargon II, Part III: Letters from Babylonia and the Eastern Provinces"
        case .saa16:
            return "SAA XVI: The Political Correspondence of Esarhaddon"
        case .saa17:
            return "SAA XVII: The Neo-Babylonian Correspondence of Sargon and Sennacherib"
        case .saa18:
            return "SAA XVIII: The Neo-Babylonian Correspondence of Esarhaddon and Letters to Assurbanipal and Sin-šarru-iškun from Northern and Central Babylonia"
        case .saa19:
            return "SAA XIX: The Correspondence of Tiglath-Pileser III and Sargon II from Nimrud"
        case .saa20:
            return "SAA XX"
        }
    }
}

private struct OraccProjectList: Decodable {
    let type: String
    let projects: [String]
    
    enum CodingKeys: String, CodingKey {
        case projects = "public", type
    }
}


public struct OraccCatalogEntry {
    public let displayName: String
    public let title: String
    public let id: String
    public let ancientAuthor: String?
    public let SAAid: Int
    
    public let chapter: Int
}

extension OraccCatalogEntry: Decodable {
    private enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case title = "title"
        case id = "id_text"
        case ancientAuthor = "ancient_author"
        
        case chapter = "ch_no"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let displayName = try container.decode(String.self, forKey: .displayName)
        let title = try container.decode(String.self, forKey: .title)
        let id = try container.decode(String.self, forKey: .id)
        let chapterStr = try container.decode(String.self, forKey: .chapter)
        let ancientAuthor = try container.decode(String.self, forKey: .ancientAuthor)
        let chapter = Int(String(chapterStr.split(separator: " ").last!))!
        let SAAid = Int(String(displayName.split(separator: " ").last!))!
        
        
        
        self.init(displayName: displayName, title: title, id: id, ancientAuthor: ancientAuthor, SAAid: SAAid, chapter: chapter)
    }
}

extension OraccCatalogEntry: CustomStringConvertible {
    public var description: String {
        return """
        
        \(displayName) \(title)\t [\(id)]
        \(ancientAuthor ?? "")
        
        """
    }
}

public struct OraccTextEdition: Decodable {
    let type: String
    let project: String
    let cdl: [OraccCDLNode]
    let textid: String
    
}

extension OraccTextEdition {
    public var transcription: String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.normalised())
        }
        
        return str
    }
    
    public var literalTranslation: String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.literalTranslation())
        }
        
        return str
    }
    
    public var cuneiform: String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.cuneiform())
        }
        
        return str
    }
    
    var discontinuityTypes: Set<String> {
        var types = Set<String>()
        
        for node in self.cdl {
            types.formUnion(node.discontinuityTypes())
        }
        return types
    }
    
    var chunkTypes: Set<String> {
        var types = Set<String>()
        
        for node in self.cdl {
            types.formUnion(node.chunkTypes())
        }
        return types
    }
}

public struct OraccCDLNode {
    struct Lemma {
        let frag: String
        let inst: String?
        struct f: Decodable {
            let form: String
            struct GraphemeDescription: Decodable {
                let gdl_utf8: String?
            }
            let gdl: [GraphemeDescription]
            let sense: String?
            let norm: String?
        }
        let f: f
    }
    
    struct Chunk {
        enum Chunktype: String {
            case sentence, text, phrase, discourse
        }
        
        let type: Chunktype
        let cdl: [OraccCDLNode]
    }
    
    struct Discontinuity {
        enum DiscontinuityType: String {
            case bottom, edge, nonw, nonx, obverse, object, linestart = "line-start", punct, right, reverse, surface, top
        }
        let type: DiscontinuityType
        let label: String?
    }
    
    struct Linkset: Decodable {
        struct Link: Decodable {
            let type: String
            let xlink_title: String
        }
    }
    
    enum CDLNode {
        case l(Lemma)
        case c(Chunk)
        case d(Discontinuity)
        case linkbase([Linkset])
    }
    
    let node: CDLNode
    
    
    init(lemma l: Lemma) {
        self.node = CDLNode.l(l)
    }
    
    init(chunk c: Chunk) {
        self.node = CDLNode.c(c)
    }
    
    init(discontinuity d: Discontinuity) {
        self.node = CDLNode.d(d)
    }
    
    init(linkbase lb: [Linkset]){
        self.node = CDLNode.linkbase(lb)
    }
}

extension OraccCDLNode: Decodable {
    enum CodingKeys: String, CodingKey {
        case frag = "frag"
        case inst = "inst"
        case f = "f"
        case sense = "sense"
        case norm = "norm"
        case type = "type"
        case cdl = "cdl"
        case node = "node"
        case linkbase = "linkbase"
        case label = "label"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let node = try container.decodeIfPresent(String.self, forKey: .node)
        
        if let node = node {
            switch node {
            case "d":
                let type = try container.decode(String.self, forKey: .type)
                let label = try container.decodeIfPresent(String.self, forKey: .label)
                let d = OraccCDLNode.Discontinuity(type: OraccCDLNode.Discontinuity.DiscontinuityType(rawValue: type)!, label: label)
                self = OraccCDLNode(discontinuity: d)
                
            case "l":
                let frag = try container.decode(String.self, forKey: .frag)
                let inst = try container.decodeIfPresent(String.self, forKey: .inst)
                let f = try container.decode(OraccCDLNode.Lemma.f.self, forKey: .f)
                let l = OraccCDLNode.Lemma(frag: frag, inst: inst, f: f)
                self = OraccCDLNode(lemma: l)
                
            case "c":
                let type = try container.decode(String.self, forKey: .type)
                let cdl = try container.decode([OraccCDLNode].self, forKey: .cdl)
                let chunktype = OraccCDLNode.Chunk.Chunktype(rawValue: type)!
                let c = OraccCDLNode.Chunk(type: chunktype, cdl: cdl)
                self = OraccCDLNode(chunk: c)
                
            default:
                let error: Error = "Error!" as! Error
                throw error
            }
        } else {
            let linkbase = try container.decodeIfPresent([Linkset].self, forKey: .linkbase)
            
            if let linksets = linkbase {
                self = OraccCDLNode.init(linkbase: linksets)
                
            } else {
                let error: Error = "Error!" as! Error
                throw error
            }
        }
    }
}

extension OraccCDLNode { //Text analysis functions
    func normalised() -> String {
        var str = ""
        
        switch self.node {
        case .l(let lemma):
            str.append(lemma.f.norm ?? lemma.inst ?? "[x]")
            str.append(" ")
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.normalised())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("Obverse: \n")
            case .linestart:
                str.append("\n\(discontinuity.label!) ")
            case .reverse:
                str.append("Reverse: \n")
            default:
                break
            }
            
        case .linkbase(_):
            break
        }
        
        return str
    }
    
    func literalTranslation() -> String {
        var str = ""
        
        switch self.node {
            
        case .linkbase(_):
            break
            
        case .l(let lemma):
            str.append(lemma.f.sense ?? "[?]")
            str.append(" ")
            
        case .c(let chunk):
            for node in chunk.cdl{
                str.append(node.literalTranslation())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("Obverse: \n")
            case .linestart:
                str.append("\n\(discontinuity.label!) ")
            case .reverse:
                str.append("Reverse: \n")
            default:
                break
            }
        }
        return str
    }
    
    func cuneiform() -> String {
        var str = ""
        
        switch self.node {
        case .linkbase(_):
            break
            
        case .l(let lemma):
            for entry in lemma.f.gdl {
                str.append(entry.gdl_utf8 ?? "[]")
            }
            str.append(" ")
            
        case .c(let chunk):
            for node in chunk.cdl{
                str.append(node.cuneiform())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("Obverse: \n")
            case .linestart:
                str.append("\n\(discontinuity.label!) ")
            case .reverse:
                str.append("\n\nReverse:")
            default:
                break
            }
        }
        return str
    }
    
    func discontinuityTypes() -> Set<String> {
        var types = Set<String>()
        
        switch self.node {
            
        case .linkbase(_):
            break
            
        case .l(_):
            break
            
        case .c(let chunk):
            for node in chunk.cdl{
                types.formUnion(node.discontinuityTypes())
            }
        case .d(let discontinuity):
            types.insert(discontinuity.type.rawValue)
        }
        
        return types
    }
    
    func chunkTypes() -> Set<String> {
        var types = Set<String>()
        
        switch self.node {
            
        case .linkbase(_):
            break
            
        case .l(_):
            break
            
        case .c(let chunk):
            for node in chunk.cdl{
                types.insert(chunk.type.rawValue)
                types.formUnion(node.chunkTypes())
            }
        case .d(_):
            break
        }
        
        return types
    }
}


