//
//  TextEditionExtensions.swift
//  OraccJSONtoSwift
//
//  Created by Chaitanya Kanchan on 08/01/2018.
//

import Foundation

public extension OraccTextEdition {
    public func flattenNodes() -> [OraccCDLNode] {
        var lines = [[OraccCDLNode]]()
        for node in self.cdl {
            lines.append(node.makeLine())
        }
        var flattenedNodes = [OraccCDLNode]()
        for line in lines {
            for node in line {
                flattenedNodes.append(node)
            }
        }
        return flattenedNodes
    }
}

extension OraccCDLNode {
    func makeLine() -> [OraccCDLNode] {
        var line = [OraccCDLNode]()
            switch self.node {
            case .l(let lemma):
                line.append(.init(lemma: lemma))
            case .c(let chunk):
                for node in chunk.cdl {
                    line.append(contentsOf: node.makeLine())
                }
            case .d(let discontinuity):
                switch discontinuity.type {
                case .linestart:
                    line.append(.init(discontinuity: discontinuity))
                default:
                    return []
                }
            case .linkbase(_):
                return []
            }
        return line
    }
}
