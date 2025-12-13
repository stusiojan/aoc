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

// Get rows
// Function that gets only number with spaces, trims the rows from this part + next whitespace (only one)
// Iterate through all rows except for the last one
// Rotate the matrix of numbers and whitespaces, each row is new value

// OR (this is better)
// Get rows
// Rotate all rows left
// each line is a value, last row is a value and a sign
// skip empty rows (math problems can be separated by sign or by empty row)

let lines = content.split(separator: "\n").map { Array($0) }

guard let firstLine = lines.first else { fatalError("Collection is empty.") }
let rowCount = lines.count
let colCount = firstLine.count
var rotatedLines: [String] = []

for x in (0..<colCount).reversed() {
    var newRow = ""
    for y in 0..<rowCount {
        let character = lines[y][x]
        newRow.append(character)
    }
    rotatedLines.append(newRow)
}

var operations: [String] = []
var values: [[Int]] = []
var problemComponents: [Int] = []

for line in rotatedLines {
    if line.replacing(" ", with: "").isEmpty {
        guard problemComponents != [] else { fatalError("Unexpected: No problem components.") }
        values.append(problemComponents)
        problemComponents = []
        continue
    }
    let number: String = line.trimmingCharacters(in: .whitespaces)
    if line.contains("+") || line.contains("*") {
        operations.append(String(line.suffix(1)))
        guard let component: Int = Int(number.dropLast().trimmingCharacters(in: .whitespaces))
        else { fatalError("\(line) is nan.") }
        problemComponents.append(component)
        continue
    }
    guard let component: Int = Int(number) else { fatalError("\(line) nan.") }
    problemComponents.append(component)
}
guard problemComponents != [] else { fatalError("Unexpected: No problem components.") }
values.append(problemComponents)
problemComponents = []

var problems: [(String, [Int])] = []
for (idx, op) in operations.enumerated() {
    problems.append((op, values[idx]))
}

let inputProcessingEnd = clock.now
let inputProcessingDuration = readEnd.duration(to: inputProcessingEnd)
execTimes.append("input processing: \(inputProcessingDuration)")

// Logic

func part2() {
    var totalResult: Int = 0

    for (operation, values) in problems {
        switch operation {
        case "*":
            totalResult += values.reduce(1, *)

        case "+":
            totalResult += values.reduce(0, +)

        default: fatalError("Symbol not recognized")
        }

    }
    print("Part2 - total result", totalResult)
}
part2()

let part2ExecutionEnd = clock.now
let part2ExecutionDuration = inputProcessingEnd.duration(to: part2ExecutionEnd)
execTimes.append("part 2 execution: \(part2ExecutionDuration)")

// Summary
for time in execTimes {
    print(time)
}
