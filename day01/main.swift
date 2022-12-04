//
//  main.swift
//  day01
//
//  Created by Michael Eisemann on 11/30/22.
//

import Foundation

var calories: [Int] = []
var calorieCounts: [Int] = []
while let line = readLine(strippingNewline: true) {
    if !line.isEmpty {
        guard let intLine = Int(line) else { continue }
        calories.append(intLine)
    } else {
        let totalCalories: Int = calories.reduce(0, +)
        calorieCounts.append(totalCalories)
        calories.removeAll()
    }
}

calorieCounts.sort(by: >)
print(calorieCounts[0])
print(calorieCounts[0] + calorieCounts[1] + calorieCounts[2])
