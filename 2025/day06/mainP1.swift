import Foundation

// Time measurement
let clock = ContinuousClock()
let start = clock.now
var execTimes: [String] = []

// Get input
// let inputFileName = "input.txt"
let inputFileName = "testInput.txt"
let currentFileURL = URL(filePath: #filePath)
let directoryURL = currentFileURL.deletingLastPathComponent()
let inputFileURL = directoryURL.appending(path: inputFileName)

guard let content = try? String(contentsOf: inputFileURL, encoding: .utf8) else {
    fatalError("Błąd: Nie znaleziono pliku \(inputFileURL) w folderze: \(directoryURL.path())")
}

let readEnd = clock.now
let readDuration = start.duration(to: readEnd)
execTimes.append("read input: \(readDuration)")

var operations: [String] = []
var values: [[Int]] = []

let _ = content.split(separator: "\n")
    .forEach { row in
        var rowValues: [Int] = []
        var currentNumberBuffer: String = ""

        for (idx, r) in row.enumerated() {
            let isLast = idx == row.count - 1

            if ["*", "+"].contains(r) {
                operations.append(String(r))
                continue
            }
            if r == " " {
                if currentNumberBuffer.isEmpty {
                    continue
                }
                guard let number: Int = Int(currentNumberBuffer) else {
                    fatalError("\(r) Nan")
                }
                rowValues.append(number)
                currentNumberBuffer = ""
                continue
            }
            if r.isWholeNumber {
                currentNumberBuffer += String(r)
            }
            if isLast && !currentNumberBuffer.isEmpty {
                guard let number: Int = Int(currentNumberBuffer) else {
                    fatalError("\(r) Nan")
                }
                rowValues.append(number)
                currentNumberBuffer = ""
            }
        }
        if rowValues.isEmpty { return }
        values.append(rowValues)
    }

guard validateRowNum(values) == true else { fatalError("Rows has not equal length.") }

var problems: [(String, [Int])] = []

for (idx, op) in operations.enumerated() {
    var vals: [Int] = []

    for row in values {
        vals.append(row[idx])
    }
    problems.append((op, vals))
}

let inputProcessingEnd = clock.now
let inputProcessingDuration = readEnd.duration(to: inputProcessingEnd)
execTimes.append("input processing: \(inputProcessingDuration)")

// Logic

func part1() {
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
    print("Part1 - total result", totalResult)
}
part1()

let part1ExecutionEnd = clock.now
let part1ExecutionDuration = inputProcessingEnd.duration(to: part1ExecutionEnd)
execTimes.append("part 1 execution: \(part1ExecutionDuration)")

// Summary
for time in execTimes {
    print(time)
}
func validateRowNum(_ rowCollection: [[Int]]) -> Bool {
    guard let firstItem = rowCollection.first else { fatalError("collection is empty.") }
    let rowItemCount: Int = firstItem.count
    for r in rowCollection {
        if r.count != rowItemCount {
            return false
        }
    }
    return true
}
