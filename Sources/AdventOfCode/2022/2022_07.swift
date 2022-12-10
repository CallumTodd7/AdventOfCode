//
//  2022_07.swift
//  
//
//  Created by Callum Todd on 07/12/2022.
//

import Foundation

fileprivate struct File {
    let name: String
    let fileSize: Int
}

fileprivate class Node: Hashable {
    let indent: Int
    let name: String?
    var children: Set<Node>?
    let fileSize: Int?
    weak var parent: Node?
    
    private init(indent: Int, name: String?, children: Set<Node>?, fileSize: Int?, parent: Node? = nil) {
        self.indent = indent
        self.name = name
        self.children = children
        self.fileSize = fileSize
        self.parent = parent
    }
    
    static var root: Node {
        Node(indent: 0, name: nil, children: .init(), fileSize: nil, parent: nil)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.name == rhs.name && lhs.parent == rhs.parent
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(fileSize)
    }
    
    var flattenedChildren: [File] {
        if let children {
            return children.flatMap { node in
                node.flattenedChildren
            }
        } else {
            return [File(name: name!, fileSize: fileSize!)]
        }
    }
    
    var totalSize: Int {
        if let children {
            return children.map(\.totalSize).reduce(0, +)
        } else {
            return fileSize!
        }
    }
    
    func walk(_ callback: (Node) -> Void) {
        callback(self)
        children?.forEach { node in
            node.walk(callback)
        }
    }
    
    @discardableResult
    func addDirectory(name: String) -> Node {
        let (_, node) = self.children!.insert(Node(indent: indent + 1, name: name, children: .init(), fileSize: nil, parent: self))
        return node
    }
    
    @discardableResult
    func addFile(name: String, size: Int) -> Node {
        let (_, node) = self.children!.insert(Node(indent: indent + 1, name: name, children: nil, fileSize: size, parent: self))
        return node
    }
}


fileprivate func buildFileSystem(from history: String) -> Node {
    let root = Node.root
    var currentNode = root
    
    var isInListCommand = false
    
    for line in history.lines {
        if isInListCommand {
            if let match = line.firstMatch(of: #/dir (?<name>.+)/#) {
                currentNode.addDirectory(name: String(match.output.name))
                continue
            } else if let match = line.firstMatch(of: #/(?<size>\d+) (?<name>.+)/#) {
                currentNode.addFile(name: String(match.output.name), size: Int(match.output.size)!)
                continue
            } else {
                isInListCommand = false
            }
        }
        
        if let match = line.firstMatch(of: #/\$ cd (?<param>.+)/#) {
            switch match.output.param {
            case "..":
                currentNode = currentNode.parent!
            case "/":
                currentNode = root
            default:
                currentNode = currentNode.addDirectory(name: String(match.output.param))
            }
        } else if line.firstMatch(of: #/\$ ls/#) != nil {
            isInListCommand = true
        } else {
            fatalError()
        }
    }
    
    
    return root
}

struct Y2022_D7_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 7
    static let part: Int? = 1
    static let expectedAnswer: PuzzleResult? = 1743217
    
    func solve(input: String) -> PuzzleResult {
        var total: Int = 0
        buildFileSystem(from: input)
            .walk { node in
//                print("\(String(repeating: ".", count: node.indent))\(node.name ?? "/") \(node.fileSize.map(String.init) ?? "dir") - \(node.totalSize) - \(node.children != nil && node.totalSize <= 100000 ? "YES" : "n")")
                if node.children != nil && node.totalSize <= 100000 {
                    total += node.totalSize
                }
            }
        return total
    }
}

struct Y2022_D7_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 7
    static let part: Int? = 2
    static let expectedAnswer: PuzzleResult? = 8319096
    
    func solve(input: String) -> PuzzleResult {
        let capacity = 70000000
        
        var options: [Int] = []
        let fileSystem = buildFileSystem(from: input)
        let sizeNeededToRemove = 30000000 - (capacity - fileSystem.totalSize)
//        print("Need to remove at least: \(sizeNeededToRemove)")
        fileSystem
            .walk { node in
                if node.children != nil && node.totalSize > sizeNeededToRemove {
                    options.append(node.totalSize)
                }
            }
        return options.min()!
    }
}
