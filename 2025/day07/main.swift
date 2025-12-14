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

let tachynionManifoldLines: [String] = content.split(separator: "\n").map { String($0) }

let inputProcessingEnd = clock.now
let inputProcessingDuration = readEnd.duration(to: inputProcessingEnd)
execTimes.append("input processing: \(inputProcessingDuration)")

// Logic

func part1() {
    var splitCounter: Int = 0
    var currentBeamLocationsIndices: Set<String.Index> = []

    for (idx, line) in tachynionManifoldLines.enumerated() {
        // Find S in first line
        if idx == 0 {
            guard let sIndex: String.Index = line.firstIndex(of: "S") else {
                fatalError("No beam start found.")
            }
            currentBeamLocationsIndices = [sIndex]
            continue
        }
        // Find splitters
        var splitterBuffer: [String.Index] = []
        let splittersIndices: RangeSet<String.Index> = line.indices(of: "^")
        if splittersIndices.isEmpty { continue }

        let hits = currentBeamLocationsIndices.filter { location in
            splittersIndices.contains(location)
        }
        for hit in hits {
            splitterBuffer.append(hit)
            splitCounter += 1
        }

        // Update current beam locations
        var beamLocationBuffer: [String.Index] = []
        for splitter in splitterBuffer {
            if let leftBeamIdx = line.index(splitter, offsetBy: -1, limitedBy: line.startIndex) {
                beamLocationBuffer.append(leftBeamIdx)
            }
            if let rightBeamIdx = line.index(
                splitter, offsetBy: 1, limitedBy: line.index(before: line.endIndex))
            {
                beamLocationBuffer.append(rightBeamIdx)
            }
        }

        currentBeamLocationsIndices.subtract(hits)
        currentBeamLocationsIndices.formUnion(beamLocationBuffer)
    }
    print("Part1 - splits", splitCounter)
}
part1()

let part1ExecutionEnd = clock.now
let part1ExecutionDuration = inputProcessingEnd.duration(to: part1ExecutionEnd)
execTimes.append("part 1 execution: \(part1ExecutionDuration)")

// This solution was based on part 1, but it is heavy, because it follows each beam
func part2() {
    var timelineCounter: Int = 1
    var currentPossibleBeamLocationsIndices: [String.Index] = []

    for (idx, line) in tachynionManifoldLines.enumerated() {
        // Find S in first line
        if idx == 0 {
            guard let sIndex: String.Index = line.firstIndex(of: "S") else {
                fatalError("No beam start found.")
            }
            currentPossibleBeamLocationsIndices = [sIndex]
            continue
        }
        // Find splitters
        var splitterBuffer: [String.Index] = []
        let splittersIndices: RangeSet<String.Index> = line.indices(of: "^")
        if splittersIndices.isEmpty { continue }

        // print("CurrentBeamLocations", currentPossibleBeamLocationsIndices)
        let hits = currentPossibleBeamLocationsIndices.filter { location in
            splittersIndices.contains(location)
        }
        // print("Hits: ", hits)
        for hit in hits {
            splitterBuffer.append(hit)
            // timelineCounter += 1
        }

        // Update current beam locations
        var beamLocationBuffer: [String.Index] = []
        for splitter in splitterBuffer {
            if let leftBeamIdx = line.index(splitter, offsetBy: -1, limitedBy: line.startIndex) {
                beamLocationBuffer.append(leftBeamIdx)
            }
            if let rightBeamIdx = line.index(
                splitter, offsetBy: 1, limitedBy: line.index(before: line.endIndex))
            {
                beamLocationBuffer.append(rightBeamIdx)
            }
        }

        // print("Hits: \(hits.count), new beams: \(beamLocationBuffer.count)")
        timelineCounter += (beamLocationBuffer.count - hits.count)
        // print("Dimentions: ", timelineCounter)

        currentPossibleBeamLocationsIndices = currentPossibleBeamLocationsIndices.filter {
            !hits.contains($0)
        }
        currentPossibleBeamLocationsIndices += beamLocationBuffer
        print(timelineCounter)
    }
    print("Part2 - timelines", timelineCounter)
}
// part2()

// Much faster solution, less loops, here all beams per column are stored, so there is no need to count multiple times per one occured splitter
func part2v2() {
    let grid: [[Character]] = tachynionManifoldLines.map { Array($0) }
    var timelineCounter: Int = 1

    var currentBeams: [Int: Int] = [:]

    for (rowIndex, line) in grid.enumerated() {
        if rowIndex == 0 {
            if let sIndex = line.firstIndex(of: "S") {
                currentBeams[sIndex] = 1
            } else {
                fatalError("No beam start found.")
            }
            continue
        }
        if currentBeams.isEmpty { break }

        var nextBeams: [Int: Int] = [:]
        let rowWidth = line.count

        for (colIndex, beamCount) in currentBeams {
            if colIndex < 0 || colIndex >= rowWidth { continue }

            let char = line[colIndex]

            if char == "^" {
                timelineCounter += beamCount

                let leftIdx = colIndex - 1
                if leftIdx >= 0 {
                    nextBeams[leftIdx, default: 0] += beamCount
                }

                let rightIdx = colIndex + 1
                if rightIdx < rowWidth {
                    nextBeams[rightIdx, default: 0] += beamCount
                }
            } else {
                nextBeams[colIndex, default: 0] += beamCount
            }
        }

        currentBeams = nextBeams
    }

    print("Part2 - timelines", timelineCounter)
}

part2v2()
let part2ExecutionEnd = clock.now
let part2ExecutionDuration = inputProcessingEnd.duration(to: part2ExecutionEnd)
execTimes.append("part 2 execution: \(part2ExecutionDuration)")

// Summary
for time in execTimes {
    print(time)
}
