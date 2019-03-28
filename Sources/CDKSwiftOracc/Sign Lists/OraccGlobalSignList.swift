//
//  OraccGlobalSignList.swift
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

/// Namespace for Oracc Sign List types
public enum OSL {
    enum DecodeError: Error {
        case InvalidASL
    }
}

extension OSL {
    typealias CommandLine = (command: OSL.Command, content: [String])
    
    /// Oracc Sign
    struct Sign: Codable {
        var sign: String
        var unicodeName: String
        var characterCode: String
        var utf8: String
        var values: Set<String>
    }
    
    
    /// Commands for parsing ASL files
    enum Command: String {
        case sign = "@sign"
        case list = "@list"
        case uphase = "@uphase"
        case uname = "@uname"
        case ucode = "@ucode"
        case value = "@v"
        case questionedValue = "@?v"
        case deprecatedValue = "@v-"
        
        case end = "@end"
    }
    
    static func makeCommandBlocks(_ string: String) -> [[OSL.CommandLine]] {
        let rawLines = string.split(separator: Character("\n"))
        let commands = rawLines.compactMap{String($0).parseOSLLine()}
        
        var blocks: [[OSL.CommandLine]] = []
        
        var currentBlock: [OSL.CommandLine] = []
        for (command, content) in commands {
            switch command {
            case .end:
                currentBlock.append((command: command, content: content))
                blocks.append(currentBlock)
                currentBlock.removeAll(keepingCapacity: true)
            default:
                currentBlock.append((command: command, content: content))
            }
        }
        
        return blocks
    }
    
    static func makeSign(commands: [OSL.CommandLine]) -> Sign? {
        var commands = commands
        let openingCommand = commands.removeFirst()
        guard case Command.sign = openingCommand.command else {return nil}
        guard commands.count != 0 else {return nil}
        
        let sign = openingCommand.content.joined()
        var unicodeName: String? = nil
        var characterCode: String? = nil
        var utf8: String? = nil
        var values = Set<String>()
        
        for (command, content) in commands {
            switch command {
            case .uname:
                unicodeName = content.joined(separator: " ")
            case .ucode:
                switch content.count {
                case 1:
                    characterCode = content[0]
                    let hexIntStr = content[0].dropFirst() // Hex string
                    let unicodeScalarInt = UInt32(hexIntStr, radix: 16) ?? 0 // Int
                    let sca = Unicode.Scalar(unicodeScalarInt) ?? "?"
                    utf8 = String(sca)
                case 2:
                    characterCode = content[0]
                    utf8 = content[1]
                default:
                    characterCode = "?"
                    utf8 = "?"
                }
                
            case .value:
                for value in content {
                    values.insert(value)
                }
                
            case .end:
                guard let u = unicodeName,
                    let cC = characterCode,
                    let utf = utf8 else {return nil}
                
                let cuneiformSign = Sign(sign: sign, unicodeName: u, characterCode: cC, utf8: utf, values: values)
                return cuneiformSign
                
            default:
                continue
            }
        }
        return nil
    }
    
    static func makeSignList(_ string: String) -> [Sign] {
        var signs: [Sign] = []
        
        let blocks = OSL.makeCommandBlocks(string)
        for block in blocks {
            guard let sign = OSL.makeSign(commands: block) else {continue}
            signs.append(sign)
        }
        
        return signs
    }
}

public extension OSL {
    
    /// Converts an Oracc [`.asl` sign list format](https://github.com/oracc/oracc/blob/master/doc/ns/sl/1.0/sl.xdf) to JSON format for use by the `Cuneifier` struct.
    /// - Parameter asl: Valid Oracc SL file in ASCII or UTF8 encoding.
    /// - Returns: Encoded JSON as a `Data` value suitable for writing to a file.
    static func convertToJSON(_ asl: Data) throws -> Data {
        guard let str = String(data: asl, encoding: .utf8) else {throw OSL.DecodeError.InvalidASL}
        let signs = OSL.makeSignList(str)
        let encoder = JSONEncoder()
        let encodedJSON = try encoder.encode(signs)
        return encodedJSON
    }
}

