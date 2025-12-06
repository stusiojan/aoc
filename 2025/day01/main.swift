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

let instructions =
    content
    .split(separator: "\n")
    .map {
        $0.hasPrefix("L")
            ? $0.replacingOccurrences(of: "L", with: "-")
            : $0.replacingOccurrences(of: "R", with: "")
    }
    .map { Int($0)! }

// print("Number of instrunctions:", instructions.count)
// print(instructions[..<10])

let inputProcessingEnd = clock.now
let inputProcessingDuration = readEnd.duration(to: inputProcessingEnd)
execTimes.append("input processing: \(inputProcessingDuration)")

// Logic

func part1() {
    var currentValue: Int = 50
    var dialPointsZeroCounter: Int = 0

    for instruction in instructions {
        currentValue = (currentValue + instruction) % 100

        if currentValue == 0 {
            dialPointsZeroCounter += 1

        }
    }
    print("part 1 password", dialPointsZeroCounter, "\n")
}
part1()

let part1ExecutionEnd = clock.now
let part1ExecutionDuration = inputProcessingEnd.duration(to: part1ExecutionEnd)
execTimes.append("part 1 execution: \(part1ExecutionDuration)")

func part2() {
    var currentValue: Int = 50
    var dialPointsZeroCounter: Int = 0

    for instruction in instructions {
        let previousValue: Int = currentValue
        currentValue += instruction

        let start = Double(previousValue) / 100.0
        let end = Double(currentValue) / 100.0

        if instruction > 0 {
            dialPointsZeroCounter += Int(floor(end) - floor(start))
        } else if instruction < 0 {
            dialPointsZeroCounter += Int(ceil(start) - ceil(end))
        }

    }
    print("part 2 password", dialPointsZeroCounter, "\n")
}
part2()

let part2ExecutionEnd = clock.now
let part2ExecutionDuration = inputProcessingEnd.duration(to: part2ExecutionEnd)
execTimes.append("part 2 execution: \(part2ExecutionDuration)")

// Summary
for time in execTimes {
    print(time)
}
