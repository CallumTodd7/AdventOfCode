//
//  2022_02.swift
//  
//
//  Created by Callum Todd on 03/12/2022.
//

import Foundation

fileprivate enum Play: Hashable, CaseIterable {
    case rock
    case paper
    case sissors
    
    static func from(_ char: Character) -> Play {
        if char == "A" || char == "X" {
            return .rock
        } else if char == "B" || char == "Y" {
            return .paper
        } else if char == "C" || char == "Z" {
            return .sissors
        } else {
            preconditionFailure()
        }
    }
    
    var playValue: Int {
        switch self {
        case .rock:
            return 1
        case .paper:
            return 2
        case .sissors:
            return 3
        }
    }
    
    var beats: Play {
        switch self {
        case .rock:
            return .sissors
        case .paper:
            return .rock
        case .sissors:
            return .paper
        }
    }
}

fileprivate enum Winner {
    case us
    case draw
    case them
    
    static func from(_ char: Character) -> Winner {
        if char == "X" {
            return .them
        } else if char == "Y" {
            return .draw
        } else if char == "Z" {
            return .us
        } else {
            preconditionFailure()
        }
    }
}

fileprivate struct Round {
    let ourPlay: Play
    let theirPlay: Play
    
    init(ourPlay: Play, theirPlay: Play) {
        self.ourPlay = ourPlay
        self.theirPlay = theirPlay
    }
    
    var winner: Winner {
        if ourPlay.beats == theirPlay {
            return .us
        } else if theirPlay.beats == ourPlay {
            return .them
        } else {
            return .draw
        }
    }
    
    var ourScore: Int {
        switch winner {
        case .us:
            return 6 + ourPlay.playValue
        case .draw:
            return 3 + ourPlay.playValue
        case .them:
            return 0 + ourPlay.playValue
        }
    }
}

struct Y2022_D2_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 2
    static let part: Int? = 1
    
    func solve(input: String) -> PuzzleResult {
        let strategy = input
            .components(separatedBy: .newlines)
            .filter({ !$0.isEmpty })
            .map({ string -> (theirs: Play, ours: Play) in
                precondition(string.count == 3)
                let theirs = Play.from(string[string.startIndex])
                precondition(string[string.index(after: string.startIndex)] == " ")
                let ours = Play.from(string[string.index(before: string.endIndex)])
                return (theirs, ours)
            })
            .map({ Round(ourPlay: $0.ours, theirPlay: $0.theirs) })
        return strategy
            .map(\.ourScore)
            .reduce(0, +)
    }
}

struct Y2022_D2_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 2
    static let part: Int? = 2
    
    func solve(input: String) -> PuzzleResult {
        let strategy = input
            .components(separatedBy: .newlines)
            .filter({ !$0.isEmpty })
            .map({ string -> (theirPlay: Play, desiredWinner: Winner) in
                precondition(string.count == 3)
                let theirPlay = Play.from(string[string.startIndex])
                precondition(string[string.index(after: string.startIndex)] == " ")
                let desiredWinner = Winner.from(string[string.index(before: string.endIndex)])
                return (theirPlay, desiredWinner)
            })
            .map({ roundStrategy in
                let theirPlay = roundStrategy.theirPlay
                let desiredWinner = roundStrategy.desiredWinner
                
                let ourPlay: Play
                switch desiredWinner {
                case .them:
                    ourPlay = theirPlay.beats
                case .draw:
                    ourPlay = theirPlay
                case .us:
                    ourPlay = Play.allCases
                        .filter({ $0 != theirPlay && $0 != theirPlay.beats })
                        .first!
                }
                return Round(ourPlay: ourPlay, theirPlay: theirPlay)
            })
        return strategy
            .map(\.ourScore)
            .reduce(0, +)
    }
}
