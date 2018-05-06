//
//  TextEditionExtensions.swift
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

//public extension OraccTextEdition {
//    public func flattenNodes() -> [OraccCDLNode] {
//        var lines = [[OraccCDLNode]]()
//        for node in self.cdl {
//            lines.append(node.makeLine())
//        }
//        var flattenedNodes = [OraccCDLNode]()
//        for line in lines {
//            for node in line {
//                flattenedNodes.append(node)
//            }
//        }
//        return flattenedNodes
//    }
//}

//extension OraccCDLNode {
//    func makeLine() -> [OraccCDLNode] {
//        var line = [OraccCDLNode]()
//            switch self {
//            case .l(let lemma):
//                line.append(.init(lemma: lemma))
//            case .c(let chunk):
//                for node in chunk.cdl {
//                    line.append(contentsOf: node.makeLine())
//                }
//            case .d(let discontinuity):
//                switch discontinuity.type {
//                case .linestart:
//                    line.append(.init(discontinuity: discontinuity))
//                default:
//                    return []
//                }
//            case .linkbase(_):
//                return []
//            }
//        return line
//    }
//}
