//
//  OraccVolumes.swift
//  OraccJSONtoSwiftPackageDescription
//
//  Created by Chaitanya Kanchan on 27/12/2017.
//

import Foundation

public enum OraccVolume: String {
    case saa01, saa02, saa03, saa04, saa05, saa06, saa07, saa08, saa09, saa10, saa11, saa12, saa13, saa14, saa15, saa16, saa17, saa18, saa19, saa20, rimanum
}

public extension OraccVolume {
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
        case .rimanum:
            return "Rīm-Anum: The House of Prisoners"
        }
    }
}


internal extension OraccVolume {
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
        case .rimanum:
            return "rimanum"
        }
    }
    
    var gitHubZipForm: String {
        switch self {
        case .rimanum:
            return self.directoryForm
        default:
            return "saao-\(self.directoryForm)"
        }
    }
}


