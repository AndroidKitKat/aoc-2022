//
//  main.swift
//  day03
//
//  Created by Michael Eisemann on 12/2/22.
//

import Foundation

// Source: https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

func checkPriority(for item: String.Element) -> Int {
    if item.isUppercase {
        return Int(item.asciiValue!) - 64 + 26
    } else {
        return Int(item.asciiValue!) - 96
    }
}

func partOne(_ input: [String]) {
    var totalPriority: Int = 0

    for line in input {
        let sacks = Array(line).chunked(into: line.count / 2).map { Set($0) }
        guard let uniqueCompartment = sacks[0].intersection(sacks[1]).first else {  break }
        
        totalPriority += checkPriority(for: uniqueCompartment)
        
    }
    
    print(totalPriority)

}


func partTwo(_ input: [String]) {
    let sackGroups = input.chunked(into: 3)
    var totalPriority: Int = 0
    for group in sackGroups {
        let sackSet = group.map { Set($0) }
        guard let uniqueItem = sackSet[0].intersection(sackSet[1].intersection(sackSet[2])).first else {
            break }
        totalPriority += checkPriority(for: uniqueItem)
    }
    print(totalPriority)
}

var puzzleInput: [String] = []

while let line = readLine() {
    puzzleInput.append(line)
}

partOne(puzzleInput)
partTwo(puzzleInput)
