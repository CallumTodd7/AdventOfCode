//
//  Created by Callum Todd on 2020/12/04.
//

/**
--- Part Two ---

The line is moving more quickly now, but you overhear airport security talking about how passports with invalid data are getting through. Better add some data validation, quick!

You can continue to ignore the cid field, but each other field has strict rules about what values are valid for automatic validation:

byr (Birth Year) - four digits; at least 1920 and at most 2002.
iyr (Issue Year) - four digits; at least 2010 and at most 2020.
eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
hgt (Height) - a number followed by either cm or in:
If cm, the number must be at least 150 and at most 193.
If in, the number must be at least 59 and at most 76.
hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
pid (Passport ID) - a nine-digit number, including leading zeroes.
cid (Country ID) - ignored, missing or not.
Your job is to count the passports where all required fields are both present and valid according to the above rules. Here are some example values:

byr valid:   2002
byr invalid: 2003

hgt valid:   60in
hgt valid:   190cm
hgt invalid: 190in
hgt invalid: 190

hcl valid:   #123abc
hcl invalid: #123abz
hcl invalid: 123abc

ecl valid:   brn
ecl invalid: wat

pid valid:   000000001
pid invalid: 0123456789
Here are some invalid passports:

eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
Here are some valid passports:

pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
Count the number of valid passports - those that have all required fields and valid values. Continue to treat cid as optional. In your batch file, how many passports are valid?

Your puzzle answer was 150.

Both parts of this puzzle are complete! They provide two gold stars: **
*/

// swift -swift-version 5 day4B.swift ./day4_input.txt

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

struct HeightError: Error {}
struct ValidationError: Error {}

enum Height: Decodable {
    case centimeters(value: Int)
    case inches(value: Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if string.hasSuffix("cm") {
            let intValue = try Int(string.dropLast(2)).unwrap()
            guard intValue >= 150 && intValue <= 193 else {
                throw ValidationError()
            }
            self = .centimeters(value: intValue)
        } else if string.hasSuffix("in") {
            let intValue = try Int(string.dropLast(2)).unwrap()
            guard intValue >= 59 && intValue <= 76 else {
                throw ValidationError()
            }
            self = .inches(value: intValue)
        } else {
            throw HeightError()
        }
    }
}

enum EyeColour: String, CaseIterable, Decodable {
    case amb, blu, brn, gry, grn, hzl, oth
}

enum HairColour: Decodable {
    case hex(value: String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if string.starts(with: "#") {
            let hexString = String(string.dropFirst())
            guard hexString.count == 6 && hexString.unicodeScalars.allSatisfy({ CharacterSet(charactersIn: "0123456789abcdefABCDEF").contains($0) }) else {
                throw ValidationError()
            }
            self = .hex(value: hexString)
        } else {
            throw ValidationError()
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

    var birthYear: Int
    var issueYear: Int
    var expirationYear: Int
    let height: Height
    let hairColour: HairColour
    let eyeColour: EyeColour
    var passportId: Int
    let countryId: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let birthYearString = try container.decode(String.self, forKey: .birthYear)
        let birthYear = try Int(birthYearString).unwrap()
        guard birthYear >= 1920 && birthYear <= 2002 else { throw ValidationError() }
        self.birthYear = birthYear

        let issueYearString = try container.decode(String.self, forKey: .issueYear)
        let issueYear = try Int(issueYearString).unwrap()
        guard issueYear >= 2010 && issueYear <= 2020 else { throw ValidationError() }
        self.issueYear = issueYear

        let expirationYearString = try container.decode(String.self, forKey: .expirationYear)
        let expirationYear = try Int(expirationYearString).unwrap()
        guard expirationYear >= 2020 && expirationYear <= 2030 else { throw ValidationError() }
        self.expirationYear = expirationYear

        self.height = try container.decode(Height.self, forKey: .height)

        self.hairColour = try container.decode(HairColour.self, forKey: .hairColour)
        
        self.eyeColour = try container.decode(EyeColour.self, forKey: .eyeColour)

        let passportIdString = try container.decode(String.self, forKey: .passportId)
        guard passportIdString.count == 9 else { throw ValidationError() }
        self.passportId = try Int(passportIdString).unwrap()
        
        let countryIdString = try container.decodeIfPresent(String.self, forKey: .countryId)
        self.countryId = countryIdString.flatMap { Int($0) }
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

// Part 2

print("\(input)")

print("There are \(input.count) valid passports")
