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

let banks: [String] = content.split(separator: "\n").map { String($0) }

let inputProcessingEnd = clock.now
let inputProcessingDuration = readEnd.duration(to: inputProcessingEnd)
execTimes.append("input processing: \(inputProcessingDuration)")

// Logic

func part1() {
    var totalJoltage: Int = 0

    for bank in banks {
        let joltages: [Int] = bank.map {
            guard let number = $0.wholeNumberValue else {
                fatalError("Could not convert '\($0)' to an Int")
            }
            return number
        }

        // find highest number in bank except last battery
        guard let firstBattery: Int = joltages.dropLast().sorted(by: >).first else {
            fatalError("No batteries in a bank")
        }

        // make slice from the highest number + 1 index to the end
        guard let firstBetteryIdx: Int = joltages.firstIndex(of: firstBattery) else {
            fatalError("Index oor")
        }

        let remainingJoltages = joltages[(firstBetteryIdx + 1)...]

        // find highest number
        guard let secondBettery: Int = remainingJoltages.sorted(by: >).first else {
            fatalError("No batteries in a bank")
        }

        let highestJoltage = firstBattery * 10 + secondBettery
        totalJoltage += highestJoltage
    }
    print("Part1 - total joltage: \(totalJoltage)")
}
part1()

let part1ExecutionEnd = clock.now
let part1ExecutionDuration = inputProcessingEnd.duration(to: part1ExecutionEnd)
execTimes.append("part 1 execution: \(part1ExecutionDuration)")

func part2() {
    let batteriesOnTargetNum: Int = 12
    var totalJoltage: Int = 0

    for bank in banks {
        var bankJoltage: Int = 0
        var joltages: [Int] = bank.map {
            guard let number = $0.wholeNumberValue else {
                fatalError("Could not convert '\($0)' to an Int")
            }
            return number
        }

        for batteryNum in 0..<batteriesOnTargetNum {
            // Pick highest joltage battery leaving room for more picks
            guard
                let battery: Int = joltages.dropLast(batteriesOnTargetNum - batteryNum - 1).sorted(
                    by: >
                ).first
            else {
                fatalError("No batteries in a bank")
            }

            // updating bank
            guard let pickedBetteryIdx: Int = joltages.firstIndex(of: battery) else {
                fatalError("Battery is unexpetedly out of an bank.")
            }
            joltages = Array(joltages[(pickedBetteryIdx + 1)...])

            //updating bank joltage
            bankJoltage += battery * Int(pow(10.0, Double(batteriesOnTargetNum - batteryNum - 1)))
        }
        totalJoltage += bankJoltage

    }
    print("Part2 - total joltage: \(totalJoltage)")
}
part2()

let part2ExecutionEnd = clock.now
let part2ExecutionDuration = inputProcessingEnd.duration(to: part2ExecutionEnd)
execTimes.append("part 2 execution: \(part2ExecutionDuration)")

// Summary
for time in execTimes {
    print(time)
}
