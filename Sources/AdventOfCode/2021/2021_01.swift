//
//  2021_01.swift
//  
//
//  Created by Callum Todd on 28/11/2022.
//

import Foundation

struct Y2021_D1_P1: Puzzle {
    static let year: Int = 2021
    static let day: Int = 1
    static let part: Int? = 1
    
    func solve(input: String) -> PuzzleResult {
        let lines = input.split(separator: "\n").map { Int($0)! }
        return countIncreases(in: lines)
    }
}

struct Y2021_D1_P2: Puzzle {
    static let year: Int = 2021
    static let day: Int = 1
    static let part: Int? = 2
    
    func solve(input: String) -> PuzzleResult {
        let lines = input.split(separator: "\n").map { Int($0)! }
        
        let tuples = lines.tupleView(lookahead: 2)
        let mapped = tuples.compactMap({ tuple -> Int? in
            guard tuple.count == 3 else { return nil } // If 3 full values...
            return tuple.reduce(into: 0) { $0 += $1 } // Sum together
        })
        
        return countIncreases(in: mapped)
    }
}

fileprivate func countIncreases(in array: [Int]) -> Int {
    var increasedCount = 0
    var priorNumber = Int.max
    for number in array {
        if number > priorNumber {
            increasedCount += 1
        }
        priorNumber = number
    }
    return increasedCount
}

extension Array {
    fileprivate func tupleView(lookahead: Int) -> [SubSequence] {
        precondition(lookahead >= 0)
        return self.indices.compactMap { idx -> SubSequence? in
            guard idx + lookahead < endIndex else {
                return nil
            }
            return self[idx...(idx + lookahead)]
        }
    }
}
