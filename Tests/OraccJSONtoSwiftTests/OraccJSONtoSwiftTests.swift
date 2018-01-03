import XCTest
@testable import OraccJSONtoSwift

class OraccGithubtoSwiftTests: XCTestCase {
    let fileManager = FileManager.default

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
        struct TestProject {
            let RIAo = OraccProjectEntry(pathname: "riao", abbrev: "RIAo", name: "Royal Inscriptions of Assyria online", blurb: "This project intends to present annotated editions of the entire corpus of Assyrian royal inscriptions, texts that were published in RIMA 1-3 and RINAP 1 and 3-4. This rich, open-access corpus has been made available through the kind permission of Kirk Grayson and Grant Frame and with funding provided by the <a href=\" https://www.humboldt-foundation.de/web/home.html\">Alexander von Humboldt Foundation</a>.  RIAo is based at <a href=\"http://www.en.ag.geschichte.uni-muenchen.de/chairs/chair_radner/index.html\">LMU Munich</a> (Historisches Seminar, Alte Geschichte) and is managed by Jamie Novotny and Karen Radner. Kirk Grayson, Nathan Morello, and Jamie Novotny are the primary content contributors.")
            let SAA13 = OraccProjectEntry(pathname: "saao/saa13", abbrev: "SAAo/SAA13", name: "Letters from Assyrian and Babylonian Priests to Kings Esarhaddon and Assurbanipal", blurb: "The text editions from the book S. W. Cole and P. Machinist, Letters from Assyrian and Babylonian Priests to Kings Esarhaddon and Assurbanipal (State Archives of Assyria, 13), 1998 (reprint 2014). <a href=\"http://www.eisenbrauns.com/item/COLLETTER\">Buy the book</a> from Eisenbrauns.")
        }
        let testProjects = TestProject()
        
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
    
    
    static var allTests = [
        ("testArchiveList", testArchiveList),
        ("testOraccProjects", testOraccProjects),
        ("testDownloadingProjects", testDownloadingProjects)
    ]
}
