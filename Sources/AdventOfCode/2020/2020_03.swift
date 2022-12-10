//
//  Created by Callum Todd on 2020/12/03.
//

/**
--- Day 3: Toboggan Trajectory ---

With the toboggan login problems resolved, you set off toward the airport. While travel by toboggan might be easy, it's certainly not safe: there's very minimal steering and the area is covered in trees. You'll need to see which angles will take you near the fewest trees.

Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a map (your puzzle input) of the open squares (.) and trees (#) you can see. For example:

..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
These aren't the only trees, though; due to something you read about once involving arboreal genetics and biome stability, the same pattern repeats to the right many times:

..##.........##.........##.........##.........##.........##.......  --->
#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........#.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...##....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
You start on the open square (.) in the top-left corner and need to reach the bottom (below the bottom-most row on your map).

The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

The locations you'd check in the above example are marked here with O where there was an open square and X where there was a tree:

..##.........##.........##.........##.........##.........##.......  --->
#..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
.#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
.#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
.#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
.#........#.#........X.#........#.#........#.#........#.#........#
#.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
#...##....##...##....##...#X....##...##....##...##....##...##....#
.#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
In this example, traversing the map using this slope would cause you to encounter 7 trees.

Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?

Your puzzle answer was 145.

--- Part Two ---

Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

Right 1, down 1.
Right 3, down 1. (This is the slope you already checked.)
Right 5, down 1.
Right 7, down 1.
Right 1, down 2.
In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

What do you get if you multiply together the number of trees encountered on each of the listed slopes?

Your puzzle answer was 3424528800.

Both parts of this puzzle are complete! They provide two gold stars: **
*/


import Foundation

fileprivate extension Array {
    subscript(index: Int, wrap: Bool) -> Element {
        get {
            if wrap {
                return self[index % self.count]
            } else {
                return self[index]
            }
        }
        set(newValue) {
            if wrap {
                self[index % self.count] = newValue
            } else {
                self[index] = newValue
            }
        }
    }
}

struct Y2020_D3_P1: Puzzle {
    static let year: Int = 2020
    static let day: Int = 3
    static let part: Int? = 1
    static let expectedAnswer: PuzzleResult? = 145
    
    func solve(input: String) -> PuzzleResult {
        let treeMap: [[Character]] = input.components(separatedBy: .newlines).compactMap {
            guard !$0.isEmpty else { return nil }
            return Array($0)
        }
        return countTreesOnSlope(treeMap, 3, 1)
    }
}

struct Y2020_D3_P2: Puzzle {
    static let year: Int = 2020
    static let day: Int = 3
    static let part: Int? = 2
    static let expectedAnswer: PuzzleResult? = 3424528800
    
    func solve(input: String) -> PuzzleResult {
        let treeMap: [[Character]] = input.components(separatedBy: .newlines).compactMap {
            guard !$0.isEmpty else { return nil }
            return Array($0)
        }
        
        let slopes = [
            (1, 1),
            (3, 1),
            (5, 1),
            (7, 1),
            (1, 2)
        ]

        var result = 1
        for (x, y) in slopes {
            result *= countTreesOnSlope(treeMap, x, y)
        }
        return result
    }
}

fileprivate func isTreeAtPosition(_ treeMap: [[Character]], _ x: Int, _ y: Int) -> Bool? {
    guard y < treeMap.count else {
        return nil
    }
    let row = treeMap[y]
    return row[x, true] == "#"
}

fileprivate func countTreesOnSlope(_ treeMap: [[Character]], _ xSlope: Int, _ ySlope: Int) -> Int {
    var count = 0

    var tree: Bool?
    var x: Int = xSlope
    var y: Int = ySlope
    repeat {
        tree = isTreeAtPosition(treeMap, x, y)
        if tree == .some(true) {
            count += 1
        }
        x += xSlope
        y += ySlope
    } while tree != nil

    return count
}

