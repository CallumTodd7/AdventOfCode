//
//  2022_03.swift
//  
//
//  Created by Callum Todd on 03/12/2022.
//

import Foundation
import Algorithms

fileprivate struct Item: RawRepresentable, Hashable {
    let rawValue: Character
    
    var priority: Int {
        precondition(rawValue.isASCII)
        guard let asciiValue = rawValue.asciiValue else {
            preconditionFailure()
        }
        let a = Character("a").asciiValue!
        let A = Character("A").asciiValue!
        if rawValue.isLowercase {
            return Int(asciiValue - a + 1)
        } else if rawValue.isUppercase {
            return Int(asciiValue - A + 1) + 26
        } else {
            preconditionFailure()
        }
    }
}

fileprivate struct Rucksack {
    struct Compartment {
        let items: [Item]
    }
    
    let compartments: [Compartment]
    
    var allItems: [Item] {
        compartments.flatMap(\.items)
    }
    
    init(string: String) {
        precondition(string.count % 2 == 0)
        self.compartments = [
            .init(items: Array(string.prefix(string.count / 2)).map(Item.init)),
            .init(items: Array(string.suffix(string.count / 2)).map(Item.init)),
        ]
    }
    
    func commonItemsBetweenComponents() -> Set<Item> {
        return compartments
            .map(\.items).map(Set.init) // Unique items per compartment
            .commonItems()
    }
}

struct Y2022_D3_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 3
    static let part: Int? = 1
    
    func solve(input: String) -> PuzzleResult {
        return input.lines
            .map(Rucksack.init)
            .map { rucksack -> Item in
                let duplicates = rucksack.commonItemsBetweenComponents()
                precondition(duplicates.count == 1)
                return duplicates.first!
            }
            .map(\.priority)
            .reduce(0, +)
    }
}

struct Y2022_D3_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 3
    static let part: Int? = 2
    
    func solve(input: String) -> PuzzleResult {
        return input.lines
            .map(Rucksack.init)
            .map(\.allItems)
            .map(Set.init) // Unique
            .chunks(ofCount: 3)
            .map { itemsPerGroup -> Item in
                let sharedItems = itemsPerGroup
                    .dropFirst()
                    .reduce(into: itemsPerGroup.first!, { $0 = $0.intersection($1) })
                precondition(sharedItems.count == 1)
                return sharedItems.first!
            }
            .map(\.priority)
            .reduce(0, +)
    }
}
