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

let cleanedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
let ranges: [ClosedRange<Int>] =
    cleanedContent
    .split(separator: ",")
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

let inputProcessingEnd = clock.now
let inputProcessingDuration = readEnd.duration(to: inputProcessingEnd)
execTimes.append("input processing: \(inputProcessingDuration)")

// Logic

func part1() {
    var invalidIdCount: Int = 0

    for range in ranges {
        for id in range {
            if !id.isValidIdPt1() {
                invalidIdCount += id
            }
        }

    }
    print("Part 1:", invalidIdCount)
}
part1()

let part1ExecutionEnd = clock.now
let part1ExecutionDuration = inputProcessingEnd.duration(to: part1ExecutionEnd)
execTimes.append("part 1 execution: \(part1ExecutionDuration)")

func part2() {
    var invalidIdCount: Int = 0

    for range in ranges {
        for id in range {
            if !id.isValidIdPt2() {
                invalidIdCount += id
            }
        }

    }
    print("Part 2:", invalidIdCount)
}
part2()

let part2ExecutionEnd = clock.now
let part2ExecutionDuration = inputProcessingEnd.duration(to: part2ExecutionEnd)
execTimes.append("part 2 execution: \(part2ExecutionDuration)")

// Summary
for time in execTimes {
    print(time)
}

extension Int {
    func isValidIdPt1() -> Bool {

        let strint = String(abs(self))
        let count = strint.count
        if count % 2 == 1 {
            return true
        }
        let firstHalf = strint.prefix(count / 2)
        let secondHalf = strint.suffix(count / 2)
        if firstHalf != secondHalf {
            return true
        }
        return false
    }

    func isValidIdPt2() -> Bool {
        let strint = String(abs(self))
        var currentIdx: Int = 1

        while currentIdx < strint.count {
            let bufferEndIdx: String.Index = strint.index(strint.startIndex, offsetBy: currentIdx)
            let bodyDigitsBuffer: Substring = strint[strint.startIndex..<bufferEndIdx]

            let isDividabe: Bool = strint.count % bodyDigitsBuffer.count == 0
            let maxBufferChunksInStrint = strint.count / bodyDigitsBuffer.count
            if maxBufferChunksInStrint < 2 {
                return true
            }

            for chunkNum in 2...maxBufferChunksInStrint {
                let nextChunkIdx: String.Index = strint.index(
                    strint.startIndex, offsetBy: chunkNum * bodyDigitsBuffer.count)
                let nextDigitsBuffer: Substring = strint[bufferEndIdx..<nextChunkIdx]

                if bodyDigitsBuffer == nextDigitsBuffer {
                    if chunkNum == maxBufferChunksInStrint && isDividabe {
                        return false
                    }
                    if strint.replacingOccurrences(of: bodyDigitsBuffer, with: "").isEmpty {
                        return false
                    }
                    if !isDividabe {
                        return true

                    }
                } else {
                    currentIdx += 1
                    break
                }
            }
        }
        return true
    }
}
