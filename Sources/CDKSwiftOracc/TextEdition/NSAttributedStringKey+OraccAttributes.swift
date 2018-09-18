//
//  NSAttributedStringKey+OraccAttributes.swift
//  CDKSwiftOracc: Cuneiform Documents for Swift
//  Copyright (C) 2018 Chaitanya Kanchan
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

import Foundation

// Adds keys that support the encoding of Oracc lemmatisation information into attributed strings.
public extension NSAttributedString.Key {
    public static var oraccCitationForm: NSAttributedString.Key {
        return self.init("oraccCitationForm")
    }
    
    public static var oraccGuideWord: NSAttributedString.Key {
        return self.init("oraccGuideWord")
    }
    
    public static var oraccSense: NSAttributedString.Key {
        return self.init("oraccSense")
    }
    
    public static var partOfSpeech: NSAttributedString.Key {
        return self.init("partOfSpeech")
    }
    
    public static var effectivePartOfSpeech: NSAttributedString.Key {
        return self.init("effectivePartOfSpeech")
    }
    
    public static var oraccLanguage: NSAttributedString.Key {
        return self.init("oraccLanguage")
    }
    
    public static var writtenForm: NSAttributedString.Key {
        return self.init("writtenForm")
    }
    
    public static var normalisation: NSAttributedString.Key {
        return self.init("normalisation")
    }
    
    public static var instanceTranslation: NSAttributedString.Key {
        return self.init("instanceTranslation")
    }
    
    public static var reference: NSAttributedString.Key {
        return self.init("reference")
    }
}

// Adds keys that support the encoding of GDL grapheme data into attributed strings
public extension NSAttributedString.Key {
    public static var signValue: NSAttributedString.Key {
        return self.init("signValue")
    }
    
    public static var signModifiers: NSAttributedString.Key {
        return self.init("signModifiers")
    }
    
}
