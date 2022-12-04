//
//  main.swift
//  day04
//
//  Created by Michael Eisemann on 12/3/22.
//

import Foundation

var totalFullSubRanges: Int = 0
var totalAnySubRanges: Int = 0

while let line = readLine() {
    let sectionRanges = line.components(separatedBy: ",").map { $0.components(separatedBy: "-").map { Int($0) ?? -1 } }
    let rangeOne = Set(Array(sectionRanges[0][0]...sectionRanges[0][1]))
    let rangeTwo = Set(Array(sectionRanges[1][0]...sectionRanges[1][1]))
    if rangeOne.isSubset(of: rangeTwo) || rangeTwo.isSubset(of: rangeOne) {
        totalFullSubRanges += 1
    }
    
    if !rangeOne.intersection(rangeTwo).isEmpty {
        totalAnySubRanges += 1
    }
}

print(totalFullSubRanges)
print(totalAnySubRanges)
