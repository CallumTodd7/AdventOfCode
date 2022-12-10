import ArgumentParser
import Foundation

@main
struct AdventOfCode: ParsableCommand {
    static var puzzles: [Puzzle.Type] = [
        // 2020
        Y2020_D1_P1.self,
        Y2020_D1_P2.self,
        Y2020_D2_P1.self,
        Y2020_D2_P2.self,
        Y2020_D3_P1.self,
        Y2020_D3_P2.self,
        // 2021
        Y2021_D1_P1.self,
        Y2021_D1_P2.self,
        // 2022
        Y2022_D1_P1.self,
        Y2022_D1_P2.self,
        Y2022_D2_P1.self,
        Y2022_D2_P2.self,
        Y2022_D3_P1.self,
        Y2022_D3_P2.self,
        Y2022_D4_P1.self,
        Y2022_D4_P2.self,
        Y2022_D5_P1.self,
        Y2022_D5_P2.self,
        Y2022_D6_P1.self,
        Y2022_D6_P2.self,
        Y2022_D7_P1.self,
        Y2022_D7_P2.self,
        Y2022_D8_P1.self,
        Y2022_D8_P2.self,
    ]
    
    @Option var year: Int = Calendar.current.component(.year, from: Date())
    @Option var day: Int?
    @Option var part: Int?
    @Flag var runRegression: Bool = false
    
    mutating func run() throws {
        let puzzlesToRun =
            Self.puzzles
                .filter({ $0.year == year })
                .filter({ day == nil || $0.day == day! })
                .filter({ part == nil || $0.part == nil || $0.part == part! })
        
        print("\(puzzlesToRun.count) puzzle(s) match given criteria: year=\(year), day=\(day.map(String.init) ?? "*"), part=\(part.map(String.init) ?? "*")")
        
        // Run explicit puzzles
        var brokenPuzzles: [(Puzzle, Puzzle.PuzzleResult)] = []
        for puzzleType in puzzlesToRun {
            let puzzle = puzzleType.init()
            
            print("\(puzzle.description): Running...")
            let answer = puzzle.solve()
            print("\(puzzle.description): Answer: \(answer)\n")
            
            if let expectedAnswer = puzzleType.expectedAnswer {
                if answer.description != expectedAnswer.description {
                    print("WARNING: Answer for \(puzzle.description) does not match expected answer: \(expectedAnswer)")
                    brokenPuzzles.append((puzzle, answer))
                }
            }
        }
        
        if runRegression {
            // Run non-explicit puzzles for regressions
            let puzzlesForRegression =
                Self.puzzles
                    .filter({ puzzle in !puzzlesToRun.contains(where: { $0 == puzzle }) })
            
            for puzzleType in puzzlesForRegression {
                let puzzle = puzzleType.init()
                if let expectedAnswer = puzzleType.expectedAnswer {
                    let actualAnswer = puzzle.solve()
                    if actualAnswer.description != expectedAnswer.description {
                        brokenPuzzles.append((puzzle, actualAnswer))
                    }
                } else {
                    print("WARNING: No known answer for \(puzzle.description). Unable to run regression")
                }
            }
        }
        
        // Report regressions
        if brokenPuzzles.isEmpty {
            if runRegression {
                print("No regressions in other puzzles")
            }
        } else {
            print("WARNING: Regression!!")
            for (puzzle, actualAnswer) in brokenPuzzles {
                print("- Answer for \(puzzle.description) (\(actualAnswer)) does not match expected answer: \(type(of: puzzle).expectedAnswer ?? "nil")")
            }
        }
    }
}

protocol Puzzle: CustomStringConvertible {
    typealias PuzzleResult = CustomStringConvertible
    static var year: Int { get }
    static var day: Int { get }
    static var part: Int? { get }
    static var expectedAnswer: PuzzleResult? { get }
    init()
    func solve(input: String) -> PuzzleResult
}

extension Puzzle {
    static var inputPath: String {
        let dayStr = day.formatted(.number.precision(.integerLength(2...2)))
        let directory = "Inputs/\(year)"
        
        let paths = Bundle.module.paths(forResourcesOfType: "txt", inDirectory: directory)
        if let part {
            let path = "\(directory)/\(year)_\(dayStr)_\(part)_input.txt"
            if paths.contains(path) {
                return path
            }
        }
        return "\(directory)/\(year)_\(dayStr)_input.txt"
    }
    
    func solve() -> PuzzleResult {
        let url = Bundle.module.url(forResource: Self.inputPath, withExtension: nil)!
        let fileText = try! String(contentsOf: url)
        return self.solve(input: fileText)
    }
}

extension Puzzle {
    var description: String {
        "\(Self.year), Day \(Self.day.formatted(.number.precision(.integerLength(2...2))))\(Self.part.map({ " (\($0))" }) ?? "")"
    }
}
