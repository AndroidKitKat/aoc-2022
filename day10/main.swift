//
//  main.swift
//  day10
//
//  Created by Michael Eisemann on 12/10/22.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

enum Operation: String {
    case addx
    case noop
}

struct Instruction {
    let opcode: Operation
    let value: Int?
}

final class CPU {
    var rgx: Int = 1
    var cycle: Int = 1
    var history: [Int: Int] = [1: 1]

    let instructions: [Instruction]

    init(instructions: [Instruction]) {
        self.instructions = instructions
        for instruction in self.instructions {
            switch instruction.opcode {
            case .addx:
                self.addx(value: instruction.value!)
            case .noop:
                self.noop()
            }
        }
    }

    private func addx(value: Int) {
        // advance our cycle
        self.history[self.cycle] = self.rgx
        self.cycle += 1

        // advance our cycle
        self.history[self.cycle] = self.rgx
        self.rgx += value
        self.cycle += 1

    }

    private func noop() {
        // noop advances cycle
        self.history[self.cycle] = self.rgx
        self.cycle += 1

    }

    var signalStrength: Int {
        var signalStrength: Int = 0
        for idx in 0..<cycle where (idx-19) % 40 == 0 {
            signalStrength += (self.history[idx+1]! * (idx + 1))
        }
        return signalStrength
    }

    var picture: String {

        var finalImageArray: [String] = []

        for scanline in self.history.keys.sorted().chunked(into: 40) {
            var electronGunPosition: Int = 0
            var finalImageRow: String = ""
            for pixel in scanline {
                guard let registerValue = self.history[pixel] else { fatalError("invalid pixel!")}

                if self.isPixelVisible(at: electronGunPosition, for: registerValue) {
                    finalImageRow += "#"
                } else {
                    finalImageRow += "."
                }
                electronGunPosition += 1
            }
            finalImageArray.append(finalImageRow)
        }

        return finalImageArray.joined(separator: "\n")
    }

    private func isPixelVisible(at position: Int, for registerValue: Int) -> Bool {
        return position == registerValue - 1 || position == registerValue || position == registerValue + 1
    }
}

var puzzleInput: [Instruction] = []

while let line = readLine() {
    let rawInstruction = line.components(separatedBy: " ")

    if rawInstruction.count == 2 {
        puzzleInput.append(Instruction(opcode: Operation(rawValue: rawInstruction[0])!, value: Int(rawInstruction[1])))
    } else {
        puzzleInput.append(Instruction(opcode: Operation(rawValue: rawInstruction[0])!, value: nil))
    }

}

let cpu = CPU(instructions: puzzleInput)

print(cpu.signalStrength)
print(cpu.picture)
