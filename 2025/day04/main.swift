//Convert input to ranges
// Check each field we also check if in previous, current and next line there are values <current_index-1, current_index+1> except the current_index in current line

import Foundation

// Time measurement
let clock = ContinuousClock()
let start = clock.now
var execTimes: [String] = []

// Get input
let inputFileName = "input.txt"
// let inputFileName = "testInput.txt"
let currentFileURL = URL(filePath: #filePath)
let directoryURL = currentFileURL.deletingLastPathComponent()
let inputFileURL = directoryURL.appending(path: inputFileName)

guard let content = try? String(contentsOf: inputFileURL, encoding: .utf8) else {
    fatalError("Błąd: Nie znaleziono pliku \(inputFileURL) w folderze: \(directoryURL.path())")
}

let readEnd = clock.now
let readDuration = start.duration(to: readEnd)
execTimes.append("read input: \(readDuration)")

let rolesLines: [String] = content.split(separator: "\n").map { "." + String($0) + "." }

let inputProcessingEnd = clock.now
let inputProcessingDuration = readEnd.duration(to: inputProcessingEnd)
execTimes.append("input processing: \(inputProcessingDuration)")

// Logic

func part1() {
    var accessibleRolesCounter: Int = 0

    guard let lineLen: Int = rolesLines.first?.count else { fatalError("Can't access first line.") }
    let dotLine: String = String(repeating: ".", count: lineLen)
    let paddedRoleLines: [String] = [dotLine] + rolesLines

    for (previousLine, (currentLine, nextLine)) in zip(
        paddedRoleLines, zip(rolesLines, rolesLines.dropFirst() + [dotLine]))
    {
        // print("previous: ", previousLine, "current: ", currentLine, "next: ", nextLine)

        let prevChars = Array(previousLine)
        let currChars = Array(currentLine)
        let nextChars = Array(nextLine)

        for (i, role) in currChars.enumerated() {
            // print("Analyzing \(i) symbol: \(role)")

            if role == "." { continue }

            var neighborCount = 0

            let start = max(0, i - 1)
            let end = min(currChars.count - 1, i + 1)

            for x in start...end {
                if prevChars[x] == "@" { neighborCount += 1 }
            }
            for x in start...end {
                if nextChars[x] == "@" { neighborCount += 1 }
            }
            if i > 0 && currChars[i - 1] == "@" { neighborCount += 1 }
            if i < currChars.count - 1 && currChars[i + 1] == "@" { neighborCount += 1 }

            // print("Has \(neighborCount) neighbours.")
            if neighborCount < 4 {
                accessibleRolesCounter += 1
                // print("Role \(i) is accassible!")
            }
        }
    }

    print("Part1 - Accessible Roles: \(accessibleRolesCounter)")
}
part1()

let part1ExecutionEnd = clock.now
let part1ExecutionDuration = inputProcessingEnd.duration(to: part1ExecutionEnd)
execTimes.append("part 1 execution: \(part1ExecutionDuration)")

func part2() {
    var accessibleRolesCounter: Int = 0
    var lastAccessibleRolesNumber: Int = 0

    guard let lineLen: Int = rolesLines.first?.count else { fatalError("Can't access first line.") }
    let dotLine: String = String(repeating: ".", count: lineLen)

    var currentRoleLines: [String] = rolesLines

    while accessibleRolesCounter != lastAccessibleRolesNumber || accessibleRolesCounter == 0 {
        lastAccessibleRolesNumber = accessibleRolesCounter

        currentRoleLines.replaceAll("x", to: ".")
        let previousRoleLines: [String] = [dotLine] + currentRoleLines
        let nextRoleLines: [String] = currentRoleLines.dropFirst() + [dotLine]

        for (previousLine, ((currLineNum, currentLine), nextLine)) in zip(
            previousRoleLines, zip(currentRoleLines.enumerated(), nextRoleLines))
        {

            let prevChars = Array(previousLine)
            let currChars = Array(currentLine)
            let nextChars = Array(nextLine)

            for (i, role) in currChars.enumerated() {

                if role == "." { continue }

                var neighborCount = 0

                let start = max(0, i - 1)
                let end = min(currChars.count - 1, i + 1)

                for x in start...end {
                    if prevChars[x] == "@" { neighborCount += 1 }
                }
                for x in start...end {
                    if nextChars[x] == "@" { neighborCount += 1 }
                }
                if i > 0 && currChars[i - 1] == "@" { neighborCount += 1 }
                if i < currChars.count - 1 && currChars[i + 1] == "@" { neighborCount += 1 }

                // print("Has \(neighborCount) neighbours.")
                if neighborCount < 4 {
                    accessibleRolesCounter += 1
                    currentRoleLines.replaceRole(line: currLineNum, charIndexNum: i, with: "x")
                }
            }
        }
    }

    print("Part2 - Accessible Roles: \(accessibleRolesCounter)")
}
part2()

let part2ExecutionEnd = clock.now
let part2ExecutionDuration = inputProcessingEnd.duration(to: part2ExecutionEnd)
execTimes.append("part 2 execution: \(part2ExecutionDuration)")

// Summary
for time in execTimes {
    print(time)
}

extension Array where Element == String {
    mutating func replaceRole(line: Int, charIndexNum: Int, with newChar: Character) {
        let stringIndex = self[line].index(self[line].startIndex, offsetBy: charIndexNum)

        self[line].replaceSubrange(stringIndex...stringIndex, with: String(newChar))
    }

    mutating func replaceAll(_ existingPhrase: String, to newPhrase: String) {
        for (i, element) in self.enumerated() {
            self[i] = element.replacingOccurrences(of: existingPhrase, with: newPhrase)
        }
    }
}
