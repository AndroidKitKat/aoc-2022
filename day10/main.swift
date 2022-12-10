//
//  main.swift
//  day10
//
//  Created by Michael Eisemann on 12/10/22.
//

import Foundation

enum Operation: String {
    case addx = "addx"
    case noop = "noop"
}

struct Instruction {
    let opcode: Operation
    let value: Int?
}

final class CPU {
    var rgx: Int = 1
    var cycle: Int = 1
    var history: [Int: Int] = [1:1]
    
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
        self.cycle += 1
        self.history[self.cycle] = self.rgx
        
        // advance our cycle
        self.cycle += 1
        self.rgx += value
        self.history[self.cycle] = self.rgx
    }
    
    private func noop() {
        // noop advances cycle
        self.cycle += 1
        self.history[self.cycle] = self.rgx
    }
    
    var signalStrength:Int  {
        var signalStrength: Int = 0
        for idx in 0..<cycle {
            if (idx-19) % 40 == 0 {
                signalStrength += (self.history[idx+1]! * (idx + 1))
            }
        }
        return signalStrength
    }
    
    var picture: String {
        var scanLines: [[String]] = []
        print(self.history.keys.sorted())
        
        return ""
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
print(cpu.history[241])
