//
//  2022_08.swift
//  
//
//  Created by Callum Todd on 10/12/2022.
//

import Foundation

fileprivate enum Tree {
    typealias Height = Int
}

fileprivate struct TreeDetails {
    let x: Int
    let y: Int
    
    let height: Tree.Height
    
    let neighboursLeft: [Tree.Height]
    let neighboursRight: [Tree.Height]
    let neighboursTop: [Tree.Height]
    let neighboursBottom: [Tree.Height]
}

fileprivate struct TreeGrid {
    let treeHeights: Grid<Tree.Height>
    
    init(string: String) {
        let grid = string.lines
            .map { line in
                line.map { char in
                    Int("\(char)")!
                }
            }
        self.treeHeights = Grid(grid: grid)
    }
    
    func treeDetails(x: Int, y: Int) -> TreeDetails {
        precondition(x < treeHeights.columns)
        precondition(y < treeHeights.rows)
        
        let row = treeHeights[row: y]
        let column = treeHeights[column: x]
        
        let height = row[x]
        
        let left = Array(row[row.startIndex..<x].reversed())
        precondition(left.count == x)
        
        let right = Array(row[(x + 1)..<row.endIndex])
        precondition(right.count == row.count - x - 1)
        
        let top = Array(column[column.startIndex..<y].reversed())
        precondition(top.count == y)

        let bottom = Array(column[(y + 1)..<column.endIndex])
        precondition(bottom.count == column.count - y - 1)
        
        return TreeDetails(
            x: x,
            y: y,
            height: height,
            neighboursLeft: left,
            neighboursRight: right,
            neighboursTop: top,
            neighboursBottom: bottom
        )
    }
    
    func isTreeVisibleFromOutSideGrid(row y: Int, column x: Int) -> Bool {
        let details = treeDetails(x: x, y: y)
        
        let visibleFromLeft = details.neighboursLeft.map({ $0 < details.height }).reduce(true, { $0 && $1 })
        let visibleFromRight = details.neighboursRight.map({ $0 < details.height }).reduce(true, { $0 && $1 })
        let visibleFromTop = details.neighboursTop.map({ $0 < details.height }).reduce(true, { $0 && $1 })
        let visibleFromBottom = details.neighboursBottom.map({ $0 < details.height }).reduce(true, { $0 && $1 })
        
        let visible = visibleFromLeft || visibleFromRight || visibleFromTop || visibleFromBottom
        
//        print("(\(x), \(y)) is \(visible ? "visible from \([visibleFromLeft ? "left" : nil, visibleFromRight ? "right" : nil, visibleFromTop ? "top" : nil, visibleFromBottom ? "bottom" : nil].compactMap({ $0 }).joined(separator: ", "))" : "hidden")")
        
        return visible
    }
    
    private static func viewingDistance(view: some Collection<Tree.Height>, height: Tree.Height) -> Int {
        var visibleTrees = 0
        for treeHeight in view {
            visibleTrees += 1
            if treeHeight >= height {
                break
            }
        }
        return visibleTrees
    }
    
    func treeScenicScore(row y: Int, column x: Int) -> Int {
        let details = treeDetails(x: x, y: y)
        
        let leftViewingDistance = TreeGrid.viewingDistance(view: details.neighboursLeft, height: details.height)
        let rightViewingDistance = TreeGrid.viewingDistance(view: details.neighboursRight, height: details.height)
        let topViewingDistance = TreeGrid.viewingDistance(view: details.neighboursTop, height: details.height)
        let bottomViewingDistance = TreeGrid.viewingDistance(view: details.neighboursBottom, height: details.height)
        
        return leftViewingDistance * rightViewingDistance * topViewingDistance * bottomViewingDistance
    }
}

struct Y2022_D8_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 8
    static let part: Int? = 1
    static let expectedAnswer: PuzzleResult? = 1794
    
    func solve(input: String) -> PuzzleResult {
        let grid = TreeGrid(string: input)
        return grid.treeHeights
            .indexes
            .map { (x, y) in
                grid.isTreeVisibleFromOutSideGrid(row: x, column: y)
            }
            .filter({ $0 })
            .count
    }
}

struct Y2022_D8_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 8
    static let part: Int? = 2
    static let expectedAnswer: PuzzleResult? = 199272
    
    func solve(input: String) -> PuzzleResult {
        let grid = TreeGrid(string: input)
        return grid.treeHeights
            .indexes
            .map { (x, y) in
                grid.treeScenicScore(row: x, column: y)
            }
            .max()!
    }
}
