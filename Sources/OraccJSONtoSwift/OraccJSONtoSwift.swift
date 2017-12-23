import Foundation


public struct OraccJSONtoSwiftInterface {
    public let path = "/Users/Chaitanya/Documents/Programming/"
    public let decoder = JSONDecoder()
    let availableVolumes: [SAAVolumes] = [.saa01, .saa05, .saa16]
    
    public func loadCatalogue(_ volume: Int) -> OraccCatalog? {
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
    let source: URL
    let project: String
    let members: [String: OraccCatalogEntry]
    
    
    lazy var keys: [String] = {
        var keys = [String]()
        for entry in self.members.keys {
            keys.append(entry)
        }
        return keys
    }()
    
    mutating func sortBySAANum() {
        let sortedMembers = members.sorted {
            return $0.value.SAAid < $1.value.SAAid
        }
        keys = sortedMembers.map{$0.key}
    }
}


public enum SAAVolumes: Int {
    case saa01 = 1, saa02 = 2, saa03 = 3, saa04 = 4, saa05 = 5, saa06 = 6, saa07 = 7, saa08 = 8, saa09 = 9, saa10 = 10, saa11 = 11, saa12 = 12, saa13 = 13, saa14 = 14, saa15 = 15, saa16 = 16, saa17 = 17, saa18 = 18, saa19 = 19, saa20 = 20
}

extension SAAVolumes {
    var title: String {
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



public struct OraccCatalogEntry {
    let displayName: String
    let title: String
    let id: String
    let ancientAuthor: String?
    let SAAid: Int
    
    let chapter: Int
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



