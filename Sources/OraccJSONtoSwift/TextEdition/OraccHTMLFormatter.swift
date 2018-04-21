import Foundation

public extension OraccTextEdition {
    /// Returns an HTML formatted transliteration suitable for embedding in a web page
    
    public func htmlTransliteration() -> String {
        var str = ""

        for node in self.cdl {
            str.append(node.transliteratedHTML())
        }
        
        return str
    }
}

extension GraphemeDescription {
    public func transliteratedHTML() -> String {
        var str = ""
        
        //Determinatives
        if let determinative = isDeterminative {
            var syllable = ""
            if let sequence = sequence {
                for grapheme in sequence {
                    syllable.append(grapheme.transliteratedHTML())
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
        } else if let group = group {
            group.forEach{str.append($0.transliteratedHTML())}
        } else if let gdl = gdl {
            gdl.forEach{str.append($0.transliteratedHTML())}
        } else if let sequence = sequence {
            sequence.forEach{str.append($0.transliteratedHTML())}
        } else {
            switch breakPosition {
            case .start?:
                switch self.preservation {
                case .missing:
                    str.append("[")
                default:
                    break
                }
                
            default: break
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
                
            case .number(let number):
                str.append("\(number)\(delim ?? " ")")
                
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
        
        switch breakPosition {
        case .end?:
            switch self.preservation {
            case .missing:
                str.append("]")
            default:
                break
            }
        default: break
        }
        
        return str
    }
}

extension OraccCDLNode {
    func transliteratedHTML() -> String {
        var str = ""
        
        switch self.node {
        case .l(let lemma):
            for grapheme in lemma.wordForm.graphemeDescriptions {
                str.append(grapheme.transliteratedHTML())
            }
            
        case .c(let chunk):
            for node in chunk.cdl {
                str.append(node.transliteratedHTML())
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
}
