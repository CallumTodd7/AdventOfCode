//
//  2022_05.swift
//  
//
//  Created by Callum Todd on 05/12/2022.
//

import Foundation

fileprivate struct DockYard {
    typealias Crate = Character
    
    var stacksOfCrates: [[Crate]]
    
    init(parse strings: [String]) {
        let stackCount: Int = strings.last!.split(separator: #/\s+/#).count
        var tempStacks: [[Crate]] = Array(repeating: [], count: stackCount)
        
        for line in strings {
//            print("Parsing \(line)")
            if line.contains(where: { $0 == Character("[") }) {
                for match in line.matches(of: #/(?<crateChar>[\w])/#) {
                    // 4 because: [d]_
                    let stackIdx = line.distance(from: line.startIndex, to: match.range.lowerBound) / 4
                    let char = match.output.crateChar.first!
//                    print("Adding match \(char) to stack \(stackIdx)")
                    tempStacks[stackIdx].append(char)
                }
            }
        }
        self.stacksOfCrates = tempStacks.map({ $0.reversed() })
    }
    
    mutating func move(_ count: Int = 1, from origin: Int, to destination: Int) {
        let cratesInTransit = stacksOfCrates[origin - 1].suffix(count)
        stacksOfCrates[origin - 1].removeLast(count)
        stacksOfCrates[destination - 1].append(contentsOf: cratesInTransit)
    }
    
    var cratesAtTop: [Crate?] {
        stacksOfCrates.map({ $0.last })
    }
}

fileprivate struct Instruction {
    let count: Int
    let originStack: Int
    let destinationStack: Int
    
    init(parse string: String) {
        let regex = #/move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/#
        let result = try! regex.wholeMatch(in: string)!
        self.count = Int(result.count)!
        self.originStack = Int(result.from)!
        self.destinationStack = Int(result.to)!
    }
}

fileprivate func parseStacksAndInstructions(input: String) -> (DockYard, [Instruction]) {
    let sectionLines = input.lines.split(separator: "", maxSplits: 1, omittingEmptySubsequences: true)
    precondition(sectionLines.count == 2)
    let dockYard: DockYard = DockYard(parse: Array(sectionLines[0]))
    let instructions: [Instruction] = sectionLines[1].map(Instruction.init)
    return (dockYard, instructions)
}

struct Y2022_D5_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 5
    static let part: Int? = 1
    static let expectedAnswer: PuzzleResult? = "MQTPGLLDN"
    
    func solve(input: String) -> PuzzleResult {
        var (dockYard, instructions) = parseStacksAndInstructions(input: input)
        for instruction in instructions {
            for _ in 0..<instruction.count {
                dockYard.move(from: instruction.originStack, to: instruction.destinationStack)
            }
        }
        return String(dockYard.cratesAtTop.compactMap({$0}))
    }
}

struct Y2022_D5_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 5
    static let part: Int? = 2
    static let expectedAnswer: PuzzleResult? = "LVZPSTTCZ"
    
    func solve(input: String) -> PuzzleResult {
        var (dockYard, instructions) = parseStacksAndInstructions(input: input)
        for instruction in instructions {
            dockYard.move(instruction.count, from: instruction.originStack, to: instruction.destinationStack)
        }
        return String(dockYard.cratesAtTop.compactMap({$0}))
    }
}
