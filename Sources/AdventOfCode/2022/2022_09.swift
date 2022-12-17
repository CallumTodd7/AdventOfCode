//
//  2022_09.swift
//  
//
//  Created by Callum Todd on 10/12/2022.
//

import Foundation

fileprivate enum Direction {
    case left
    case right
    case up
    case down
    
    init?(firstLetter: some StringProtocol) {
        switch firstLetter.uppercased() {
        case "L": self = .left
        case "R": self = .right
        case "U": self = .up
        case "D": self = .down
        default: return nil
        }
    }
}

fileprivate struct RopeSimilator {
    let knotCount: Int
    private(set) var knots: [Vector2<Int>]
    
    private(set) var locationsVisitedByTail: Set<Vector2<Int>> = [.init()]
    
    var head: Vector2<Int> { knots.first! }
    var tail: Vector2<Int> { knots.last! }
    
    init(knotCount: Int, startingPosition: Vector2<Int> = .init()) {
        precondition(knotCount > 0)
        self.knotCount = knotCount
        self.knots = Array(repeating: startingPosition, count: knotCount)
    }
    
    mutating func step(moveHead direction: Direction) {
        // Move head
        switch direction {
        case .left:
            knots[0].x -= 1
        case .right:
            knots[0].x += 1
        case .up:
            knots[0].y -= 1
        case .down:
            knots[0].y += 1
        }
        
        for i in 1..<knotCount {
            let knotA = knots[i - 1]
            let knotB = knots[i]
            
            let distance = knotA - knotB
            
            // If A and B are not touching
            if abs(distance.x) > 1 || abs(distance.y) > 1 {
                // Simulate rope movement for B
                
                let requiredDirection = distance.clampped(min: .init(-1), max: .init(1))
                
                knots[i] += requiredDirection
            }
        }
        
        locationsVisitedByTail.insert(tail)
    }
}

struct Y2022_D9_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 9
    static let part: Int? = 1
    static let expectedAnswer: PuzzleResult? = 6284
    
    func solve(input: String) -> PuzzleResult {
        var simulator = RopeSimilator(knotCount: 2)
        
        for line in input.lines {
            guard let match = line.firstMatch(of: #/(?<direction>[LRUD]) (?<count>\d+)/#) else {
                preconditionFailure("Could not parse line: \(line)")
            }
            
            let direction = Direction(firstLetter: match.output.direction)!
            let count = Int(match.output.count)!
            
            for _ in 0..<count {
                simulator.step(moveHead: direction)
            }
        }
        
        return simulator.locationsVisitedByTail.count
    }
}

struct Y2022_D9_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 9
    static let part: Int? = 2
    static let expectedAnswer: PuzzleResult? = 2661
    
    func solve(input: String) -> PuzzleResult {
        var simulator = RopeSimilator(knotCount: 10)
        
        for line in input.lines {
            guard let match = line.firstMatch(of: #/(?<direction>[LRUD]) (?<count>\d+)/#) else {
                preconditionFailure("Could not parse line: \(line)")
            }
            
            let direction = Direction(firstLetter: match.output.direction)!
            let count = Int(match.output.count)!
            
            for _ in 0..<count {
                simulator.step(moveHead: direction)
            }
        }
        
        return simulator.locationsVisitedByTail.count
    }
}
