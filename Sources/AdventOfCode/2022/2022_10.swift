//
//  2022_10.swift
//  
//
//  Created by Callum Todd on 17/12/2022.
//

import Foundation

fileprivate enum Instruction {
    case noop
    case addx(Int)
    
    var cycles: Int {
        switch self {
        case .noop:
            return 1
        case .addx(_):
            return 2
        }
    }
}

fileprivate class Clock {
    private(set) var rawValue: Int = 0
    
    func tick() {
        rawValue += 1
    }
}

fileprivate class SharedMemory {
    var clock: Int
    var registerX: Int
    
    init(clock: Int, registerX: Int) {
        self.clock = clock
        self.registerX = registerX
    }
}

fileprivate class CPU {
    let mem: SharedMemory
    
    private(set) var instructionPtr: Int = 0
    private(set) var instructionCycle: Int?
    
    let instructions: [Instruction]
    
    init(program: String, sharedMemory: SharedMemory) {
        self.instructions = program.lines
            .map { line in
                guard let match = try? #/^(?<instruction>\w+)(?: (?<param1>\S+))?$/#.firstMatch(in: line) else {
                    fatalError()
                }
                switch match.output.instruction {
                case "noop":
                    precondition(match.output.param1 == nil)
                    return Instruction.noop
                case "addx":
                    return Instruction.addx(Int(match.output.param1!)!)
                default:
                    fatalError()
                }
            }
        self.mem = sharedMemory
    }
    
    private func execute(instruction: Instruction) {
        switch instruction {
        case .noop:
            // Do nothing
            break
        case .addx(let value):
            mem.registerX += value
        }
    }
    
    func tick() -> Bool {
        guard instructionPtr < instructions.count else {
            return false
        }
        
        let instruction = instructions[instructionPtr]
        if instructionCycle == nil {
            instructionCycle = 1
        }
        
        if instructionCycle == instruction.cycles {
            execute(instruction: instruction)
            instructionPtr += 1
            instructionCycle = nil
        } else {
            instructionCycle! += 1
        }
        
        mem.clock += 1
        
        return true
    }
}

fileprivate class CRT {
    let mem: SharedMemory
    
    let width: Int
    let height: Int
    
    private(set) var vram: [Bool]
    
    init(sharedMemory: SharedMemory, width: Int, height: Int) {
        self.mem = sharedMemory
        self.width = width
        self.height = height
        self.vram = Array(repeating: false, count: width * height)
    }
    
    func draw() {
        let x = mem.clock % width
        if mem.registerX == x - 1 || mem.registerX == x || mem.registerX == x + 1 {
            guard mem.clock < vram.count else {
                fatalError()
            }
            vram[mem.clock] = true
        }
    }
    
    var stringRepresentation: String {
        let string = vram
            .map({ $0 ? "#" : "." })
            .chunks(ofCount: width)
            .joined(separator: "\n")
        return String(string)
    }
}

struct Y2022_D10_P1: Puzzle {
    static let year: Int = 2022
    static let day: Int = 10
    static let part: Int? = 1
    static let expectedAnswer: PuzzleResult? = 13680
    
    func solve(input: String) -> PuzzleResult {
        let mem = SharedMemory(clock: 1, registerX: 1)
        let cpu = CPU(program: input, sharedMemory: mem)
        
        var sum = 0
        while cpu.tick() {
            if mem.clock % 40 == 20 {
                let signalValue = mem.clock * mem.registerX
                sum += signalValue
            }
        }
        return sum
    }
}

struct Y2022_D10_P2: Puzzle {
    static let year: Int = 2022
    static let day: Int = 10
    static let part: Int? = 2
    static let expectedAnswer: PuzzleResult? = """
    .##..####..##..###..#..#.###..####.###..
    #..#....#.#..#.#..#.#.#..#..#.#....#..#.
    #..#...#..#....#..#.##...#..#.###..###..
    ###...#...#.##.###..#.#..###..#....#..#.
    #....#....#..#.#....#.#..#....#....#..#.
    #....####..###.#....#..#.#....####.###..
    """
    
    func solve(input: String) -> PuzzleResult {
        let mem = SharedMemory(clock: 0, registerX: 1)
        let cpu = CPU(program: input, sharedMemory: mem)
        let crt = CRT(sharedMemory: mem, width: 40, height: 6)
        
        while cpu.tick() {
            crt.draw()
        }
        
        return crt.stringRepresentation
    }
}
