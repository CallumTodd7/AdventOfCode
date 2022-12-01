//
//  Created by Callum Todd on 2020/12/04.
//

/**
--- Day 4: Passport Processing ---

You arrive at the airport only to realize that you grabbed your North Pole Credentials instead of your passport. While these documents are extremely similar, North Pole Credentials aren't issued by a country and therefore aren't actually valid documentation for travel in most of the world.

It seems like you're not the only one having problems, though; a very long line has formed for the automatic passport scanners, and the delay could upset your travel itinerary.

Due to some questionable network security, you realize you might be able to solve both of these problems at the same time.

The automatic passport scanners are slow because they're having trouble detecting which passports have all required fields. The expected fields are as follows:

byr (Birth Year)
iyr (Issue Year)
eyr (Expiration Year)
hgt (Height)
hcl (Hair Color)
ecl (Eye Color)
pid (Passport ID)
cid (Country ID)
Passport data is validated in batch files (your puzzle input). Each passport is represented as a sequence of key:value pairs separated by spaces or newlines. Passports are separated by blank lines.

Here is an example batch file containing four passports:

ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
The first passport is valid - all eight fields are present. The second passport is invalid - it is missing hgt (the Height field).

The third passport is interesting; the only missing field is cid, so it looks like data from North Pole Credentials, not a passport at all! Surely, nobody would mind if you made the system temporarily ignore missing cid fields. Treat this "passport" as valid.

The fourth passport is missing two fields, cid and byr. Missing cid is fine, but missing any other field is not, so this passport is invalid.

According to the above rules, your improved system would report 2 valid passports.

Count the number of valid passports - those that have all required fields. Treat cid as optional. In your batch file, how many passports are valid?

Your puzzle answer was 216.

The first half of this puzzle is complete! It provides one gold star: *
*/

// swift -swift-version 5 day4A.swift ./day4_input.txt

import Foundation

struct NilError: Error {}
extension Optional {
    func unwrap(or error: @autoclosure () -> Error = NilError()) throws -> Wrapped {
        switch self {
        case .some(let w): return w
        case .none: throw error()
        }
    }
}

enum Height: Decodable {
    case centimeters(value: Int)
    case inches(value: Int)
    case unknown(value: String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if string.hasSuffix("cm") {
            self = .centimeters(value: Int(string.prefix(while: { CharacterSet.decimalDigits.contains($0.unicodeScalars.first!) }))!)
        } else if string.hasSuffix("in") {
            self = .inches(value: Int(string.prefix(while: { CharacterSet.decimalDigits.contains($0.unicodeScalars.first!) }))!)
        } else {
            self = .unknown(value: string)
        }
    }
}

enum Colour: Decodable {
    case hex(value: String)
    case string(value: String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if string.starts(with: "#") {
            self = .hex(value: String(string.dropFirst()))
        } else {
            self = .string(value: string)
        }
    }
}

struct Passport: Decodable {
    enum CodingKeys: String, CodingKey {
        case birthYear = "byr"
        case issueYear = "iyr"
        case expirationYear = "eyr"
        case height = "hgt"
        case hairColour = "hcl"
        case eyeColour = "ecl"
        case passportId = "pid"
        case countryId = "cid"
    }

    let birthYear: Int
    let issueYear: Int
    let expirationYear: Int
    let height: Height
    let hairColour: Colour
    let eyeColour: Colour
    let passportId: String
    let countryId: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let birthYearString = try container.decode(String.self, forKey: .birthYear)
        self.birthYear = try Int(birthYearString).unwrap()
        let issueYearString = try container.decode(String.self, forKey: .issueYear)
        self.issueYear = try Int(issueYearString).unwrap()
        let expirationYearString = try container.decode(String.self, forKey: .expirationYear)
        self.expirationYear = try Int(expirationYearString).unwrap()
        self.height = try container.decode(Height.self, forKey: .height)
        self.hairColour = try container.decode(Colour.self, forKey: .hairColour)
        self.eyeColour = try container.decode(Colour.self, forKey: .eyeColour)
        self.passportId = try container.decode(String.self, forKey: .passportId)
        // self.passportId = try Int(passportIdString).unwrap()
        self.countryId = try container.decodeIfPresent(String.self, forKey: .countryId)
        // self.countryId = try countryIdString.map { try Int($0).unwrap() }
    }
}

let inputFilePath = CommandLine.arguments[1]
let inputText = try! String(contentsOf: URL(fileURLWithPath: inputFilePath), encoding: .utf8)
let inputLines: [String] = inputText.components(separatedBy: "\n\n")
let input: [Passport] = inputLines.compactMap {
    guard !$0.isEmpty else { return nil }

    let fields: [String : String] = $0.components(separatedBy: .whitespacesAndNewlines)
        .reduce(into: [:]) { dict, value in
            guard !value.isEmpty else { return }
            let parts = value.components(separatedBy: ":")
            dict[parts[0]] = parts[1]
        }

    guard let jsonData = try? JSONSerialization.data(withJSONObject: fields, options: []) else {
        print("Could not get json data for decoding")
        return nil
    }
    let decoder = JSONDecoder()
    do {
        return try decoder.decode(Passport.self, from: jsonData)
    } catch {
        if let error = error as? DecodingError {
            switch error {
            case .typeMismatch(_, _):
        print("Could not decode: \(error)")
            case .valueNotFound(_, _):
        print("Could not decode: \(error)")
            case .keyNotFound(_, _):
            break
            case .dataCorrupted(_):
        print("Could not decode: \(error)")
            @unknown default:
        print("Could not decode: \(error)")
            }
        } else {
        print("Could not decode: \(error)")
        }
        return nil
    }
}

// Part 1

print("\(input)")

print("There are \(input.count) valid passports")
