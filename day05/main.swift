//
//  main.swift
//  day05
//
//  Created by Michael Eisemann on 12/4/22.
//
//  Do NOT use Xcode to open input files for today!
//  It will trim whitespace and completely bork parsing!
//

import Foundation

enum ParseError: Error {
    case missingBlankLine
    case somethingWentWrong
}

enum InstructionError: Error {
    case somethingWentWrong
    case somethingWentWrongHere
    case somethingWentWrongThere
}

struct Instruction {
    let amount: Int
    let source: Int
    let destination: Int
}

// source: https://stackoverflow.com/questions/42789953/swift-3-how-do-i-extract-captured-groups-in-regular-expressions
extension String {
    func groups(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                return (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []

        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

class Crane {
    let instructions: [Instruction]
    var stack: [Int: [Character]]
    private let initialStack: [Int: [Character]]

    init(instructions: [Instruction], stack: [Int: [Character]]) {
        self.instructions = instructions
        self.stack = stack
        self.initialStack = stack

    }

    private func followInstruction(_ instr: Instruction, itsOver9000: Bool = false) throws {
        guard var sourceStack = self.stack[instr.source] else { throw InstructionError.somethingWentWrongHere }
        guard var destStack = self.stack[instr.destination] else { throw InstructionError.somethingWentWrongThere }

        var groupedCrates: [Character] = []
        for _ in 0..<instr.amount {
            guard let lastCrate = sourceStack.popLast() else { fatalError("AHH") }
            if itsOver9000 {
                groupedCrates.insert(lastCrate, at: 0)
            } else {
                destStack.append(lastCrate)
            }
        }

        destStack.append(contentsOf: groupedCrates)

        self.stack[instr.source] = sourceStack
        self.stack[instr.destination] = destStack
    }

    func partOne() throws {
        self.stack = self.initialStack
        for instruction in instructions {
            try followInstruction(instruction)
        }
        print(self.topOfStack)
    }

    func partTwo() throws {
        self.stack = self.initialStack
        for instruction in instructions {
            try followInstruction(instruction, itsOver9000: true)
        }
        print(self.topOfStack)
    }

    var topOfStack: String {
        var top: String = ""
        for idx in 1...stack.count where !stack[idx]!.isEmpty {
            top += String(stack[idx]!.last!)
        }
        return top
    }

}

// At
func parseInput(_ puzzIn: [String]) throws -> Crane {

    guard let pillarInstructionDelimiter = puzzIn.firstIndex(of: "") else { throw ParseError.missingBlankLine }
    guard let pillarCount = puzzIn[pillarInstructionDelimiter.advanced(by: -1)].trimmingCharacters(in: .whitespaces)
        .last?.wholeNumberValue else { throw ParseError.somethingWentWrong }

    // Build the initial state of the stack
    var stack: [Int: [Character]] = [:]
    for idx in 1...pillarCount {
        stack[idx] = []
    }

    for row in puzzIn[0..<pillarInstructionDelimiter.advanced(by: -1)] {
        let pretreated = Array(row).chunked(into: (row.count + 1) / pillarCount).map { $0.filter { $0.isLetter } }

        for idx in 0..<pretreated.count where !pretreated[idx].isEmpty {
            stack[idx+1]?.insert(pretreated[idx][0], at: 0)
        }
    }

    // Collect our instructions
    var instructions: [Instruction] = []

    for instruction in puzzIn[pillarInstructionDelimiter
        .advanced(by: 1)..<puzzIn.count] {
        let instructionComponets = instruction.groups(for: "move ([0-9]+) from ([0-9]+) to ([0-9]+)")[0]
            .dropFirst().map {Int($0)!}
        instructions.append(Instruction(amount: instructionComponets[0],
                                        source: instructionComponets[1], destination: instructionComponets[2]))
    }

    //    print(instructions)
    return Crane(instructions: instructions, stack: stack)
}

var puzzleInput: [String] = []
while let line = readLine(strippingNewline: true) {
    puzzleInput.append(line)
}

let elfShipyard = try parseInput(puzzleInput)
try elfShipyard.partOne()
try elfShipyard.partTwo()
