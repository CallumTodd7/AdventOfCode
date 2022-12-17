//
//  2022_11.swift
//  
//
//  Created by Callum Todd on 17/12/2022.
//

import Foundation

fileprivate struct Item {
    var worryLevel: Int
}

fileprivate class Monkey {
    typealias ID = Int
    
    let id: Monkey.ID
    var items: [Item]
    let operation: (Item) -> Item
    let divisibleTestValue: Int
    let divisibleTestPassMonkeyId: Monkey.ID
    let divisibleTestFailMonkeyId: Monkey.ID
    
    var itemsInspected = 0
    
    func nextMonkey(for item: Item) -> Monkey.ID {
        if item.worryLevel % divisibleTestValue == 0 {
            return divisibleTestPassMonkeyId
        } else {
            return divisibleTestFailMonkeyId
        }
    }
    
    init(input: [String]) {
        precondition(input.count == 6)
        if let match = input[0].firstMatch(of: /Monkey (?<id>\d+):/) {
            self.id = Int(match.output.id)!
        } else { fatalError() }
        if input[1].firstMatch(of: /Starting items:/) != nil {
            let matches = input[1].matches(of: /\ (?<value>\d+)/)
            self.items = matches
                .map(\.output.value)
                .map({ (substring: Substring) -> String in String(substring) })
                .map({ Item(worryLevel: Int($0)!) })
        } else { fatalError() }
        
        if let match = input[2].firstMatch(of: /Operation: new = (?<lhs>\S+)\ (?<op>\S+)\ (?<rhs>\S+)/) {
            let parseVal: (Substring) -> Int? = {
                $0 == "old" ? nil : Int($0)!
            }
            typealias Operator = (Int, Int) -> Int
            let parseOp: (Substring) -> Operator = {
                switch $0 {
                case "*": return (*)
                case "/": return (/)
                case "+": return (+)
                case "-": return (-)
                default: fatalError()
                }
            }
            let lhs: Int? = parseVal(match.output.lhs)
            let rhs: Int? = parseVal(match.output.rhs)
            let op = parseOp(match.output.op)
            
            self.operation = { old in
                Item(worryLevel: op(lhs ?? old.worryLevel, rhs ?? old.worryLevel))
            }
        } else { fatalError() }
        
        if let match = input[3].firstMatch(of: /Test: divisible by (?<value>\d+)/) {
            self.divisibleTestValue = Int(match.output.value)!
        } else { fatalError() }
        if let match = input[4].firstMatch(of: /If true: throw to monkey (?<id>\d+)/) {
            self.divisibleTestPassMonkeyId = Int(match.output.id)!
        } else { fatalError() }
        if let match = input[5].firstMatch(of: /If false: throw to monkey (?<id>\d+)/) {
            self.divisibleTestFailMonkeyId = Int(match.output.id)!
        } else { fatalError() }
    }
}

fileprivate func simulate(monkeys: [Monkey], worryReducer: (inout Int) -> Void, rounds: Int) -> Int {
    let monkeysLookup: [Monkey.ID: Monkey] = Dictionary(uniqueKeysWithValues: zip(monkeys.map(\.id), monkeys))
    
    for _ in 0..<rounds {
        for monkey in monkeysLookup.values.sorted(using: KeyPathComparator(\.id)) {
            while !monkey.items.isEmpty {
                var item = monkey.items.removeFirst()
            
                monkey.itemsInspected += 1
                
                item = monkey.operation(item)
                worryReducer(&item.worryLevel)
                
                let newMonkeyId = monkey.nextMonkey(for: item)
                monkeysLookup[newMonkeyId]!.items.append(item)
            }
        }
    }
    
    return monkeys.map(\.itemsInspected).sorted().suffix(2).reduce(1, *)
}

struct Y2022_D11_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 11
    static let part: Int? = 1
    static let expectedAnswer: PuzzleResult? = 119715
    
    func solve(input: String) -> PuzzleResult {
        let monkeys = input.lines
            .split(separator: "", omittingEmptySubsequences: true)
            .map(Array.init)
            .map(Monkey.init)
        
        return simulate(
            monkeys: monkeys,
            worryReducer: { $0 /= 3 },
            rounds: 20
        )
    }
}

struct Y2022_D11_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 11
    static let part: Int? = 2
    static let expectedAnswer: PuzzleResult? = 18085004878
    
    func solve(input: String) -> PuzzleResult {
        let monkeys = input.lines
            .split(separator: "", omittingEmptySubsequences: true)
            .map(Array.init)
            .map(Monkey.init)
        
        let testValues = monkeys.map(\.divisibleTestValue)
        for testValue in testValues {
            precondition([2, 3, 5, 7, 11, 13, 17, 19, 23, 29].contains(testValue), "Test value \(testValue) is not prime")
        }
        
        return simulate(
            monkeys: monkeys,
            worryReducer: { $0 %= testValues.reduce(1, *) },
            rounds: 10_000
        )
    }
}
