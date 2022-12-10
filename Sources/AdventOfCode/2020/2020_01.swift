//
//  Created by Callum Todd on 2020/12/01.
//

/**
--- Day 1: Report Repair ---

After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island. Surely, Christmas will go on without you.

The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow, you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.

To save your vacation, you need to get all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input); apparently, something isn't quite adding up.

Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.

For example, suppose your expense report contained the following:

1721
979
366
299
675
1456

In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together produces 1721 * 299 = 514579, so the correct answer is 514579.

Of course, your expense report is much larger. Find the two entries that sum to 2020; what do you get if you multiply them together?

Your puzzle answer was 787776.

--- Part Two ---

The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.

Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.

In your expense report, what is the product of the three entries that sum to 2020?

Your puzzle answer was 262738554.

Both parts of this puzzle are complete! They provide two gold stars: **
*/


import Foundation

struct Y2020_D1_P1: Puzzle {
    static let year: Int = 2020
    static let day: Int = 1
    static let part: Int? = 1
    static let expectedAnswer: PuzzleResult? = 787776
    
    func solve(input: String) -> PuzzleResult {
        calculateTwo(input.components(separatedBy: .newlines).compactMap(Int.init))
    }
}

struct Y2020_D1_P2: Puzzle {
    static let year: Int = 2020
    static let day: Int = 1
    static let part: Int? = 2
    static let expectedAnswer: PuzzleResult? = 262738554
    
    func solve(input: String) -> PuzzleResult {
        calculateThree(input.components(separatedBy: .newlines).compactMap(Int.init))
    }
}


fileprivate let sumTarget = 2020


// Part 1

fileprivate func calculateTwo(_ input: [Int]) -> Int {
    for (indexA, entryA) in input.enumerated() {
        for entryB in input.suffix(from: indexA) {
            if entryA + entryB == sumTarget {
                return entryA * entryB
            }
        }
    }
    fatalError("Result not found")
}


// Part 2

fileprivate func calculateThree(_ input: [Int]) -> Int {
    for (indexA, entryA) in input.enumerated() {
        for (indexB, entryB) in input.suffix(from: indexA).enumerated() {
            for entryC in input.suffix(from: indexB) {
                if entryA + entryB + entryC == sumTarget {
                    return entryA * entryB * entryC
                }
            }
        }
    }
    fatalError("Result not found")
}

