//
//  2022_04.swift
//  
//
//  Created by Callum Todd on 04/12/2022.
//

import Foundation

extension ClosedRange where Bound: FixedWidthInteger {
    init(hyphenatedString: String) {
        let parts = hyphenatedString.components(separatedBy: "-")
        precondition(parts.count == 2)
        let lower = Bound(parts[0])!
        let upper = Bound(parts[1])!
        precondition(lower <= upper)
        self.init(uncheckedBounds: (lower: lower, upper: upper))
    }
}

fileprivate func toClosedRangePairs(line: String) -> (first: ClosedRange<Int>, second: ClosedRange<Int>) {
    let parts = line.components(separatedBy: CharacterSet(charactersIn: ","))
    precondition(parts.count == 2)
    return (first: .init(hyphenatedString: parts[0]),
            second: .init(hyphenatedString: parts[1]))
}

struct Y2022_D4_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 4
    static let part: Int? = 1
    
    func solve(input: String) -> PuzzleResult {
        return input.lines
            .map(toClosedRangePairs)
            .filter({ (first: ClosedRange<Int>, second: ClosedRange<Int>) in
                (first.contains(second.lowerBound) && first.contains(second.upperBound))
                || (second.contains(first.lowerBound) && second.contains(first.upperBound))
            })
            .count
    }
}

struct Y2022_D4_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 4
    static let part: Int? = 2
    
    func solve(input: String) -> PuzzleResult {
        return input.lines
            .map(toClosedRangePairs)
            .filter({ $0.first.overlaps($0.second) })
            .count
    }
}
