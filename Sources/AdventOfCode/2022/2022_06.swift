//
//  2022_06.swift
//  
//
//  Created by Callum Todd on 07/12/2022.
//

import Foundation

fileprivate func findMarker(ofCount size: Int, in input: String) -> Int {
    let windows = input.windows(ofCount: size)
    let index = windows.firstIndex(where: { Set($0).count == size })!
    return windows.distance(from: windows.startIndex, to: index) + size
}

struct Y2022_D6_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 6
    static let part: Int? = 1
    
    func solve(input: String) -> PuzzleResult {
        return findMarker(ofCount: 4, in: input)
    }
}

struct Y2022_D6_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 6
    static let part: Int? = 2
    
    func solve(input: String) -> PuzzleResult {
        return findMarker(ofCount: 14, in: input)
    }
}
