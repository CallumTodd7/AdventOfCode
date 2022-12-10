//
//  Grid.swift
//  
//
//  Created by Callum Todd on 10/12/2022.
//

import Foundation

struct Grid<Element> {
    // Outer array = rows
    // Inner array = columns
    private let grid: [[Element]]
    
    var rows: Int {
        grid.count
    }
    var columns: Int {
        grid.first?.count ?? 0
    }
    
    init(grid: [[Element]]) {
        grid.enumerated().forEach { idx, array in
            precondition(array.count == grid.count, "Line \(idx + 1) has an incorrect length. Found \(array.count), expected \(grid.count).")
        }
        self.grid = grid
    }
    
    subscript(row rowIdx: Int) -> [Element] {
        grid[rowIdx]
    }
    
    subscript(column columnIdx: Int) -> [Element] {
        grid.map({ $0[columnIdx] })
    }
    
    var indexes: [(x: Int, y: Int)] {
        var array: [(x: Int, y: Int)] = []
        for x in 0..<columns {
            for y in 0..<rows {
                array.append((x: x, y: y))
            }
        }
        return array
    }
}
