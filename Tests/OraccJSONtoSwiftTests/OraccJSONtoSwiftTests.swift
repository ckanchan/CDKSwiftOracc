import XCTest
@testable import OraccJSONtoSwift

class OraccGithubtoSwiftTests: XCTestCase {
    let fileManager = FileManager.default
    
    // Sample project data
    struct SampleProjectData {
        let RIAo = OraccProjectEntry(pathname: "riao", abbrev: "RIAo", name: "Royal Inscriptions of Assyria online", blurb: "This project intends to present annotated editions of the entire corpus of Assyrian royal inscriptions, texts that were published in RIMA 1-3 and RINAP 1 and 3-4. This rich, open-access corpus has been made available through the kind permission of Kirk Grayson and Grant Frame and with funding provided by the <a href=\" https://www.humboldt-foundation.de/web/home.html\">Alexander von Humboldt Foundation</a>.  RIAo is based at <a href=\"http://www.en.ag.geschichte.uni-muenchen.de/chairs/chair_radner/index.html\">LMU Munich</a> (Historisches Seminar, Alte Geschichte) and is managed by Jamie Novotny and Karen Radner. Kirk Grayson, Nathan Morello, and Jamie Novotny are the primary content contributors.")
        let SAA13 = OraccProjectEntry(pathname: "saao/saa13", abbrev: "SAAo/SAA13", name: "Letters from Assyrian and Babylonian Priests to Kings Esarhaddon and Assurbanipal", blurb: "The text editions from the book S. W. Cole and P. Machinist, Letters from Assyrian and Babylonian Priests to Kings Esarhaddon and Assurbanipal (State Archives of Assyria, 13), 1998 (reprint 2014). <a href=\"http://www.eisenbrauns.com/item/COLLETTER\">Buy the book</a> from Eisenbrauns.")
    }

    override func tearDown() {
        try! fileManager.removeItem(at: fileManager.temporaryDirectory.appendingPathComponent("oraccGithubCache"))
    }
    
    func testArchiveList() throws {
        var interface: OraccGithubtoSwift
        var archiveList: [OraccGithubtoSwift.GithubArchiveEntry]
        
        do {
            interface = try OraccGithubtoSwift()
            archiveList = try interface.getArchiveList()
        } catch {
            throw error
        }
        
        XCTAssert(archiveList.contains(where: {$0.name == "saao-saa01.zip"}), "Downloads list contains `saao-saa01.zip`")
        XCTAssert(archiveList.contains(where: {$0.name == "rimanum.zip"}), "Downloads list contains `rimanum.zip`")
    }

    func testOraccProjects() throws {
        
        let testProjects = SampleProjectData()
        
        var interface: OraccGithubtoSwift
        var oraccProjects: [OraccProjectEntry]
        
        do {
            interface = try OraccGithubtoSwift()
            oraccProjects = try interface.getOraccProjects()
        } catch {
            throw error
        }
        
        XCTAssert(oraccProjects.contains(where: {$0 == testProjects.RIAo}), "Oracc projects succesfully downloaded and decoded RIAo")
        XCTAssert(oraccProjects.contains(where: {$0 == testProjects.SAA13}), "Oracc projects succesfully downloaded and decoded SAA13")
    }

    func testLoadKeyedProjectList() throws {
        let projects = SampleProjectData()
        var interface: OraccGithubtoSwift
        var archiveList: [OraccGithubtoSwift.GithubArchiveEntry]
        var keyedProjectList: [OraccProjectEntry: URL]
        
        do {
            interface = try OraccGithubtoSwift()
            archiveList = try interface.getArchiveList()
        } catch {
            throw error
        }
        
        XCTAssert(archiveList.contains(where: {$0.name == "saao-saa01.zip"}), "Downloads list contains `saao-saa01.zip`")
        
        do {
            keyedProjectList = try interface.loadKeyedProjectList(archiveList)
        } catch {
            throw error
        }
        
        XCTAssert(keyedProjectList[projects.SAA13] == URL(string: "https://raw.githubusercontent.com/oracc/json/master/saao-saa13.zip")!)
        XCTAssert(keyedProjectList[projects.RIAo] == URL(string: "https://raw.githubusercontent.com/oracc/json/master/riao.zip"))
    }
    
    func testDownloadingProjects() throws {
        var interface: OraccGithubtoSwift
        var project: OraccProjectEntry?
        var url: URL
        var catalogue: OraccCatalog
        
        
        
        do {
            interface = try OraccGithubtoSwift()
            let projects = try interface.getOraccProjects()
            project = projects.first(where: {$0.pathname == "saao/saa01"}) ?? nil
            XCTAssertNotNil(project)
            url = try interface.downloadJSONArchive(project!)
            
        } catch {
            throw error
        }
        
        XCTAssert(fileManager.fileExists(atPath: url.path), "Zip archive successfully downloaded")
        
        do {
            catalogue = try interface.unzipArchive(at: url, volume: project!)
        } catch {
            throw error
        }
        
        XCTAssert(catalogue.members.contains(where: {$0.key == "P224485"}))
        
    }
    
    
    //MARK:- Public API tests
    func testAvailableVolumesAPI() throws{
        let projects = SampleProjectData()
        var interface: OraccGithubtoSwift
        var availableVolumes = [OraccProjectEntry]()
        
        do {
            interface = try OraccGithubtoSwift()
            try interface.getAvailableVolumes(){volumes in
                availableVolumes = volumes
                XCTAssert(availableVolumes.contains(projects.RIAo), "Available volumes contains RIAo")
                XCTAssert(availableVolumes.contains(projects.SAA13), "Available volumes contains SAA13")
            }
        } catch {
            throw error
        }
    }
    
    func testGetAvailableVolumesAPI() throws {
        let projects = SampleProjectData()
        var interface: OraccGithubtoSwift
        
        
        do {
            interface = try OraccGithubtoSwift()
            try interface.loadCatalogue(projects.SAA13){ catalogue in
                XCTAssert(catalogue.project == "saao/saa13", "Catalogue SAA13 decoded sucessfully")
            }
        } catch {
            throw error
        }
    }
    
    func testLoadTextAPI() throws {
        let projects = SampleProjectData()
        var interface: OraccGithubtoSwift
        var catalogue = OraccCatalog(source: URL(string:"http://oracc.org")!, project: "", members: [String:OraccCatalogEntry](), keys: nil){
            didSet {
                let textP285574 = try? interface.loadText("P285574", inCatalogue: catalogue)
                XCTAssertNotNil(textP285574)
                XCTAssert(textP285574?.project == "saao/saa13", "Text succesfully decoded project field")
                XCTAssertNotNil(textP285574?.cuneiform)
            }
        }
        
        do {
            interface = try OraccGithubtoSwift()
            try interface.loadCatalogue(projects.SAA13) { cat in
                catalogue = cat
            }
        } catch {
            throw error
        }
    }
    
    static var allTests = [
        ("testArchiveList", testArchiveList),
        ("testOraccProjects", testOraccProjects),
        ("testDownloadingProjects", testDownloadingProjects)
    ]
}
