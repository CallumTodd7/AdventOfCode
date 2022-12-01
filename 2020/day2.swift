//
//  Created by Callum Todd on 2020/12/02.
//

/**
--- Day 2: Password Philosophy ---

Your flight departs in a few days from the coastal airport; the easiest way down to the coast from here is via toboggan.

The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. "Something's wrong with our computers; we can't log in!" You ask if you can take a look.

Their password database seems to be a little corrupted: some of the passwords wouldn't have been allowed by the Official Toboggan Corporate Policy that was in effect when they were chosen.

To try to debug the problem, they have created a list (your puzzle input) of passwords (according to the corrupted database) and the corporate policy when that password was set.

For example, suppose you have the following list:

1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
Each line gives the password policy and then the password. The password policy indicates the lowest and highest number of times a given letter must appear for the password to be valid. For example, 1-3 a means that the password must contain a at least 1 time and at most 3 times.

In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances of b, but needs at least 1. The first and third passwords are valid: they contain one a or nine c, both within the limits of their respective policies.

How many passwords are valid according to their policies?

Your puzzle answer was 410.

--- Part Two ---

While it appears you validated the passwords correctly, they don't seem to be what the Official Toboggan Corporate Authentication System is expecting.

The shopkeeper suddenly realizes that he just accidentally explained the password policy rules from his old job at the sled rental place down the street! The Official Toboggan Corporate Policy actually works a little differently.

Each policy actually describes two positions in the password, where 1 means the first character, 2 means the second character, and so on. (Be careful; Toboggan Corporate Policies have no concept of "index zero"!) Exactly one of these positions must contain the given letter. Other occurrences of the letter are irrelevant for the purposes of policy enforcement.

Given the same example list from above:

1-3 a: abcde is valid: position 1 contains a and position 3 does not.
1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.
How many passwords are valid according to the new interpretation of the policies?

Your puzzle answer was 694.

Both parts of this puzzle are complete! They provide two gold stars: **
*/

// swift -swift-version 5 day2.swift ./day2_input.txt

import Foundation

struct PasswordAndPolicy {
    let policyLetter: Character
    let policyRange: ClosedRange<Int>
    let password: String
}

let inputFilePath = CommandLine.arguments[1]
let inputText = try! String(contentsOf: URL(fileURLWithPath: inputFilePath), encoding: .utf8)
let inputLines: [String] = inputText.components(separatedBy: .newlines)
let input: [PasswordAndPolicy] = inputLines.compactMap {
    let parts = $0.components(separatedBy: " ")
    guard parts.count == 3 else {
        return nil
    }

    let rangeParts = parts[0].components(separatedBy: "-")
    let range = Int(rangeParts[0])!...Int(rangeParts[1])!
    let letter = parts[1].first!
    let password = parts[2]
    return PasswordAndPolicy(policyLetter: letter, policyRange: range, password: password)
}

// Part 1

func getValidPasswordsRange() -> [String] {
    var validPasswords: [String] = []
    for entry in input {
        if entry.policyRange.contains(entry.password.filter({ $0 == entry.policyLetter }).count) {
            validPasswords.append(entry.password)
        }
    }
    return validPasswords
}

print("There are \(getValidPasswordsRange().count) valid passwords")

// Part 2

func getValidPasswordsXOR() -> [String] {
    var validPasswords: [String] = []
    for entry in input {
        let matchA = entry.password[entry.password.index(entry.password.startIndex, offsetBy: entry.policyRange.lowerBound - 1)] == entry.policyLetter
        let matchB = entry.password[entry.password.index(entry.password.startIndex, offsetBy: entry.policyRange.upperBound - 1)] == entry.policyLetter
        if (matchA || matchB) && (matchA != matchB) {
            validPasswords.append(entry.password)
        }
    }
    return validPasswords
}

print("There are \(getValidPasswordsXOR().count) valid passwords")
