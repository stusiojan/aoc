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

let ingredientInput: [String] = content.split(separator: "\n", omittingEmptySubsequences: false).map
{ String($0) }

guard let dividerIndex: Array.Index = ingredientInput.firstIndex(of: "") else {
    fatalError("No empty line in the input.")
}

let freshIngredients: [ClosedRange<Int>] = Array(ingredientInput[..<dividerIndex])
    .compactMap { rangeString -> ClosedRange<Int>? in
        let parts = rangeString.split(separator: "-")

        guard parts.count == 2,
            let start = Int(parts[0]),
            let end = Int(parts[1])
        else {
            return nil
        }

        return start...end
    }
let ingredientList: [Int] = Array(ingredientInput[(dividerIndex + 1)...])
    .compactMap {

        if $0 == "" { return nil }
        guard let ingredientNumber = Int($0) else { fatalError("Ingredient ID is nan") }
        return ingredientNumber
    }
print("Fresh: ", freshIngredients[...2])
print("Ingredients: ", ingredientList[...2])

let inputProcessingEnd = clock.now
let inputProcessingDuration = readEnd.duration(to: inputProcessingEnd)
execTimes.append("input processing: \(inputProcessingDuration)")

// Logic

func part1() {
    var freshIngredientsTotal: Int = 0

    // NOTE: I've tried approach with Set hoping for O{N+M), but in bigger numbers we are storing too much in memory

    // var freshIngredientSet = Set<Int>()
    // for range in freshIngredients {
    //     for val in range {
    //         freshIngredientSet.insert(Int(val))
    //     }
    // }
    //
    // for ingredient in ingredientList {
    //     if freshIngredientSet.contains(ingredient) {
    //         freshIngredientsTotal += 1
    //     }
    // }

    // NOTE: O(N*M) but more memmory efficient
    for ingredient in ingredientList {
        let isFresh = freshIngredients.contains { range in
            range.contains(ingredient)
        }

        if isFresh {
            freshIngredientsTotal += 1
        }
    }
    print("Part1:", freshIngredientsTotal)
}
part1()

let part1ExecutionEnd = clock.now
let part1ExecutionDuration = inputProcessingEnd.duration(to: part1ExecutionEnd)
execTimes.append("part 1 execution: \(part1ExecutionDuration)")

func part2() {
    var freshIngredientsTotal: Int = 0

    // NOTE: once again I can not use set for huge ranges

    // var freshIngredientSet = Set<Int>()
    // for range in freshIngredients {
    //     for val in range {
    //         freshIngredientSet.insert(Int(val))
    //     }
    // }
    // freshIngredientsTotal = freshIngredientSet.count

    let freshIngredientsRanges: [ClosedRange<Int>] = merge(ranges: freshIngredients)
    for range in freshIngredientsRanges {
        freshIngredientsTotal += range.count

    }

    print("Part2:", freshIngredientsTotal)
}
part2()

let part2ExecutionEnd = clock.now
let part2ExecutionDuration = inputProcessingEnd.duration(to: part2ExecutionEnd)
execTimes.append("part 2 execution: \(part2ExecutionDuration)")

// Summary
for time in execTimes {
    print(time)
}

func merge(ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
    let sortedRanges = ranges.sorted { $0.lowerBound < $1.lowerBound }

    guard let first = sortedRanges.first else { return [] }

    var mergedRanges = [ClosedRange<Int>]()
    var currentRange = first

    for nextRange in sortedRanges.dropFirst() {
        if currentRange.overlaps(nextRange) {
            let newUpperBound = max(currentRange.upperBound, nextRange.upperBound)
            currentRange = currentRange.lowerBound...newUpperBound
        } else {
            mergedRanges.append(currentRange)
            currentRange = nextRange
        }
    }
    mergedRanges.append(currentRange)

    return mergedRanges
}
