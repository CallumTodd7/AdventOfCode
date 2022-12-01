//
//  2022_01.swift
//  
//
//  Created by Callum Todd on 01/12/2022.
//

import Foundation

fileprivate func caloriesPerElf(input: String) -> [Int] {
    let lines: [String] = input.components(separatedBy: .newlines)
    let caloriesOfFoodItems: [Int?] = lines.map(Int.init)
    let caloriesOfFoodItemsPerElf: [[Int]] = caloriesOfFoodItems
        .split(separator: nil) // This would have been the empty line, but since it's not a number it becomes nil
        .map({ $0.compactMap({ $0 }) }) // Map from `ArraySlice<Int?>` to `[Int]`
    
    let caloriesPerElf = caloriesOfFoodItemsPerElf.map { caloriesOfFoodItems -> Int in
        caloriesOfFoodItems.reduce(into: 0, { $0 += $1 }) // Sum
    }
    
    return caloriesPerElf
}

struct Y2022_D1_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 1
    static let part: Int? = 1
    
    func solve(input: String) -> PuzzleResult {
        return caloriesPerElf(input: input)
            .max()!
    }
}

struct Y2022_D1_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 1
    static let part: Int? = 2
    
    func solve(input: String) -> PuzzleResult {
        return caloriesPerElf(input: input)
            .sorted(by: >) // Most calories first
            .prefix(3) // Take the top three
            .reduce(into: 0, { $0 += $1 }) // Sum
    }
}
