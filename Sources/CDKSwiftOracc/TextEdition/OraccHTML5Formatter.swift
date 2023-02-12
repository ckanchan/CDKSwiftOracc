//
//  OraccHTML5Formatter.swift
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

public extension OraccTextEdition {
    /// Returns an HTML formatted transliteration suitable for embedding in a web page
    
    func html5Transliteration() -> String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.transliteratedHTML5())
        }
        
        return str
    }
    
    func html5Normalisation() -> String {
        var str = ""
        
        for node in self.cdl {
            str.append(node.normalisedHTML5())
        }
        
        return str
    }
    
    func html5NormalisationPage() -> String {
        let str = self.html5Normalisation()
        
        let html = """
                    <!doctype html>
                    <html lang="en">
                        <head>
                            <meta charset="utf8">
                            <title>\(self.textid)</title>
                            <link rel="stylesheet" type="text/css" href="textedition.css" media="screen" />
                        </head>
                        <body>
                            \(str)
                        </body>
                    </html>

                    """
        
        return html
    }
}

extension GraphemeDescription {
    public func transliteratedHTML5() -> String {
        var str = ""
        
        //Determinatives
        if let determinative = isDeterminative {
            var syllable = ""
            if let components = components {
                if case let Components.sequence(sequence) = components {
                    for grapheme in sequence {
                        syllable.append(grapheme.transliteratedHTML5())
                    }
                }
            }
            
            let delimiter: String
            switch determinative {
            case .pre:
                delimiter = ""
            case .post:
                delimiter = " "
            }
            
            str.append("<sup>\(syllable)</sup>\(delimiter)")
        } else if let components = components {
            components.items.forEach{str.append($0.transliteratedHTML5())}
        } else {
            if case let Preservation.damaged(breakPosition) = self.preservation {
                if case Preservation.BreakPosition.start = breakPosition {
                    str.append("[")
                }
            }
            
            switch self.sign {
            case .value(let syllable):
                
                switch self.preservation {
                case .damaged:
                    str.append("⸢<i>\(syllable)</i>⸣")
                case .missing:
                    str.append(syllable)
                case .preserved:
                    str.append("<i>\(syllable)</i>")
                }
                
                str.append(delim ?? " ")
                
            case .name(let log):
                str.append("\(log)\(delim ?? " ")")
                
            case .number(value: let value, sexagesimal: _):
                str.append("\(value.asString)\(delim ?? " ")")
                
            case .formVariant(_, let base, _):
                if self.isLogogram {
                    str.append(base)
                } else {
                    str.append("<i>\(base)</i>")
                }
                
                str.append(delim ?? " ")
                
                
            case .null:
                break
                
            }
        }
        
        // If the sign is broken, append ']'
        if case let Preservation.damaged(breakPosition) = self.preservation {
            if case Preservation.BreakPosition.end = breakPosition {
                str.append("]")
            }
        }
        
        return str
    }

}

extension OraccCDLNode {
    func transliteratedHTML5() -> String {
        var str = ""
        
        switch self {
        case .l(let lemma):
            for grapheme in lemma.wordForm.graphemeDescriptions {
                str.append(grapheme.transliteratedHTML5())
            }
            
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.transliteratedHTML5())
            }
            
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("<b>Obverse: </b><br>")
                
            case .linestart:
                str.append("<br>\(discontinuity.label ?? "") ")
            case .reverse:
                str.append("<br><br><br><b>Reverse:</b> <br>")
            default:
                break
            }
            
        case .linkbase(_):
            break
        }
        return str
    }

    func normalisedHTML5() -> String {
        var str = ""
        let damaged = "<span class=\"damaged\">x</span>"
        
        switch self {
        case .l(let lemma):
            switch lemma.wordForm.language {
            case .Akkadian(_):
                var lemmaString: String
                if let norm = lemma.wordForm.normalisation {
                    let citationForm = lemma.wordForm.translation.citationForm ?? ""
                    let guideWord = lemma.wordForm.translation.guideWord ?? ""
                    let tooltip = "title=\"\(citationForm): \(guideWord)\""
                    let dataToggle = "data-toggle=\"tooltip\""
                    
                    lemmaString = "<span class=\"Akkadian\" \(dataToggle) data-cf=\"\(citationForm)\" data-gw=\"\(guideWord)\"\(tooltip)>\(norm) </span>"
                    
                } else {
                    lemmaString = damaged
                }
                
                str.append(lemmaString)
                
            case .Sumerian(_):
                var lemmaString: String
                if let norm = lemma.wordForm.normalisation {
                    let citationForm = lemma.wordForm.translation.citationForm ?? ""
                    let guideWord = lemma.wordForm.translation.guideWord ?? ""
                    let tooltip = "title=\"\(citationForm): \(guideWord)\""
                    
                    lemmaString = "<span class=\"Sumerian\" data-cf=\"\(citationForm)\" data-gw=\"\(guideWord)\"\(tooltip)>\(norm) </span>"
                    
                } else {
                    lemmaString = damaged
                }
                
                str.append(lemmaString)
                
            default:
                break
            }
            
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.normalisedHTML5())
            }
        case .d(let discontinuity):
            switch discontinuity.type {
            case .obverse:
                str.append("<span class=\"editorial\">Obverse:<br></span>\n")
            case .linestart:
                str.append("<br><span class=\"editorial\">\(discontinuity.label ?? "")</span>\t")
            case .reverse:
                str.append("<br><span class=\"editorial\">Reverse:<br></span>\n")
            default:
                break
            }
        case .linkbase(_):
            break
        }
        
        
        return str
    }

}

