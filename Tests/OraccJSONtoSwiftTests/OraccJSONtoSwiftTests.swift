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
        var interface: OraccGithubToSwiftInterface
        var archiveList: [OraccGithubToSwiftInterface.GithubArchiveEntry]
        
        do {
            interface = try OraccGithubToSwiftInterface()
            archiveList = try interface.getArchiveList()
        } catch {
            throw error
        }
        
        XCTAssertTrue(archiveList.contains(where: {$0.name == "saao-saa01.zip"}), "Downloads list does not contain `saao-saa01.zip`")
        XCTAssertTrue(archiveList.contains(where: {$0.name == "rimanum.zip"}), "Downloads list does not contain `rimanum.zip`")
    }

    func testOraccProjects() throws {
        
        let testProjects = SampleProjectData()
        
        var interface: OraccGithubToSwiftInterface
        var oraccProjects: [OraccProjectEntry]
        
        do {
            interface = try OraccGithubToSwiftInterface()
            oraccProjects = try interface.getOraccProjects()
        } catch {
            throw error
        }
        
        XCTAssertTrue(oraccProjects.contains(where: {$0 == testProjects.RIAo}), "Oracc projects succesfully downloaded and decoded RIAo")
        XCTAssertTrue(oraccProjects.contains(where: {$0 == testProjects.SAA13}), "Oracc projects succesfully downloaded and decoded SAA13")
    }

    func testLoadKeyedProjectList() throws {
        let projects = SampleProjectData()
        var interface: OraccGithubToSwiftInterface
        var archiveList: [OraccGithubToSwiftInterface.GithubArchiveEntry]
        var keyedProjectList: [OraccProjectEntry: URL]
        
        do {
            interface = try OraccGithubToSwiftInterface()
            archiveList = try interface.getArchiveList()
        } catch {
            throw error
        }
        
        XCTAssertTrue(archiveList.contains(where: {$0.name == "saao-saa01.zip"}), "Downloads list contains `saao-saa01.zip`")
        
        do {
            keyedProjectList = try interface.loadKeyedProjectList(archiveList)
        } catch {
            throw error
        }
        
        XCTAssertEqual(keyedProjectList[projects.SAA13],  URL(string: "https://raw.githubusercontent.com/oracc/json/master/saao-saa13.zip")!)
        XCTAssertEqual(keyedProjectList[projects.RIAo], URL(string: "https://raw.githubusercontent.com/oracc/json/master/riao.zip"))
    }
    
    func testDownloadingProjects() throws {
        var interface: OraccGithubToSwiftInterface
        var project: OraccProjectEntry?
        var url: URL
        var catalogue: OraccCatalog
        
        
        
        do {
            interface = try OraccGithubToSwiftInterface()
            let projects = try interface.getOraccProjects()
            project = projects.first(where: {$0.pathname == "saao/saa01"}) ?? nil
            XCTAssertNotNil(project)
            url = try interface.downloadJSONArchive(project!)
            
        } catch {
            throw error
        }
        
        XCTAssertTrue(fileManager.fileExists(atPath: url.path), "Zip archive successfully downloaded")
        
        do {
            catalogue = try interface.unzipArchive(at: url, volume: project!)
        } catch {
            throw error
        }
        
        XCTAssertTrue(catalogue.members.contains(where: {$0.key == "P224485"}))
        
    }
    
    
    //MARK:- Public API tests
    func testAvailableVolumesAPI() throws{
        let projects = SampleProjectData()
        var interface: OraccGithubToSwiftInterface
        var availableVolumes = [OraccProjectEntry]()
        
        do {
            interface = try OraccGithubToSwiftInterface()
            try interface.getAvailableVolumes(){volumes in
                availableVolumes = volumes
                XCTAssertTrue(availableVolumes.contains(projects.RIAo), "Available volumes does not contain RIAo")
                XCTAssertTrue(availableVolumes.contains(projects.SAA13), "Available volumes does not contain SAA 13")
            }
        } catch {
            throw error
        }
    }
    
    func testLoadCatalogueAPI() throws {
        let projects = SampleProjectData()
        var interface: OraccGithubToSwiftInterface

        do {
            interface = try OraccGithubToSwiftInterface()
            try interface.loadCatalogue(projects.SAA13){ catalogue in
                XCTAssertEqual(catalogue.project, "saao/saa13")
            }
        } catch {
            throw error
        }
    }
    
    func testLoadTextAPI() throws {
        let projects = SampleProjectData()
        
        var interface: OraccGithubToSwiftInterface
        var catalogue: OraccCatalog? = nil
        let catalogueLoaded = expectation(description: "Catalogue successfully loaded")
        
        do {
            interface = try OraccGithubToSwiftInterface()
            try interface.loadCatalogue(projects.SAA13) { cat in
                print("Entering completion handler")
                catalogue = cat
                XCTAssertNotNil(catalogue)
                XCTAssertEqual(catalogue!.project, "saao/saa13")
                catalogueLoaded.fulfill()

                
            }
        } catch {
            throw error
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let textP285574 = try? interface.loadText("P285574", inCatalogue: catalogue!)
                XCTAssertNotNil(textP285574)
                XCTAssertEqual(textP285574?.project, "saao/saa13")
                XCTAssertNotNil(textP285574?.transliteration)
                print(textP285574!.transliteration)
            }
        }
    }
    
    func measureTextLoad() {
        let projects = SampleProjectData()
        
        let interface = try! OraccGithubToSwiftInterface()
        var catalogue: OraccCatalog? = nil
        let catalogueLoaded = expectation(description: "Catalogue successfully loaded")
        
        measure {
            try! interface.loadCatalogue(projects.SAA13) { cat in
                print("Entering completion handler")
                catalogue = cat
                XCTAssertNotNil(catalogue)
                XCTAssertEqual(catalogue!.project, "saao/saa13")
                catalogueLoaded.fulfill()
            }
        }
        
        measure {
            waitForExpectations(timeout: 10) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let textP285574 = try? interface.loadText("P285574", inCatalogue: catalogue!)
                    XCTAssertNotNil(textP285574)
                    XCTAssertEqual(textP285574?.project, "saao/saa13")
                    XCTAssertNotNil(textP285574?.cuneiform)
                }
            }
        }
    }
    
    
    static var allTests = [
        ("testArchiveList", testArchiveList),
        ("testOraccProjects", testOraccProjects),
        ("testLoadKeyedProjectList", testLoadKeyedProjectList),
        ("testDownloadingProjects", testDownloadingProjects),
        ("testAvailableVolumesAPI", testAvailableVolumesAPI),
        ("testLoadCatalogueAPI", testLoadCatalogueAPI),
        ("testLoadTextAPI", testLoadTextAPI),
        ("measureTextLoad", measureTextLoad)
        
    ]
}
