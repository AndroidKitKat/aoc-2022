//
//  main.swift
//  day08
//
//  Created by Michael Eisemann on 12/8/22.
//

import Foundation

struct Tree: Comparable {
    let height: Int
    var scenicScores: [Int]

    init(height: Int) {
        self.scenicScores = []
        self.height = height
    }

    var visibility: [String: Bool]  = [
        "N": true,
        "E": true,
        "S": true,
        "W": true
    ]

    var scenicScore: Int {
        scenicScores.reduce(1, *)
    }

    var isVisible: Bool {
        return visibility.values.contains(true)
    }

    static func < (lhs: Tree, rhs: Tree) -> Bool {
        return lhs.height < rhs.height
    }

    static func > (lhs: Tree, rhs: Tree) -> Bool {
        return lhs.height > rhs.height
    }

    static func == (lhs: Tree, rhs: Tree) -> Bool {
        return lhs.height == rhs.height
    }

    static func <= (lhs: Tree, rhs: Tree) -> Bool {
        return lhs.height <= rhs.height
    }

    static func >= (lhs: Tree, rhs: Tree) -> Bool {
        return lhs.height >= rhs.height
    }

}

class Forest {
    var treeMap: [[Tree]]
    init(_ treeMap: [[Tree]]) {
        self.treeMap = treeMap
        self.determineGlobalVisibility()
    }

    private func determineGlobalVisibility() {
        for treeRow in 1..<self.treeMap.count-1 {
            for treeCol in 1..<self.treeMap[treeRow].count-1 {
                rayCast(treeRow, treeCol)
            }
        }
    }

    private func rayCast(_ row: Int, _ col: Int) {

        // look north (row towards 0)

        var northScore: Int = 0
        for treeRow in stride(from: row-1, through: 0, by: -1) {
            if self.treeMap[treeRow][col] >= self.treeMap[row][col] {
                self.treeMap[row][col].visibility["N"] = false
                northScore += 1
                break
            } else {
                northScore += 1
            }
        }

        // look east (col towards max)
        var eastScore: Int = 0
        for treeCol in stride(from: col+1, to: self.treeMap[row].count, by: 1) {
            if self.treeMap[row][treeCol] >= self.treeMap[row][col] {
                self.treeMap[row][col].visibility["E"] = false
                eastScore += 1
                break
            } else {
                eastScore += 1
            }
        }

        // look south (row towards max)
        var southScore: Int = 0
        for treeRow in stride(from: row+1, to: self.treeMap[row].count, by: 1) {
            if self.treeMap[treeRow][col] >= self.treeMap[row][col] {
                self.treeMap[row][col].visibility["S"] = false
                southScore += 1
                break
            } else {
                southScore += 1
            }
        }

        // look west (col towards 0)
        var westScore: Int = 0
        for treeCol in stride(from: col-1, through: 0, by: -1) {
            if self.treeMap[row][treeCol] >= self.treeMap[row][col] {
                self.treeMap[row][col].visibility["W"] = false
                westScore += 1
                break
            } else {
                westScore += 1
            }
        }

        self.treeMap[row][col].scenicScores.append(northScore)
        self.treeMap[row][col].scenicScores.append(westScore)
        self.treeMap[row][col].scenicScores.append(southScore)
        self.treeMap[row][col].scenicScores.append(eastScore)
    }
}

var puzzleInput: [[Tree]] = []

while let line = readLine() {
    puzzleInput.append(line.map { Tree(height: Int(String($0))!) })
}

let forest = Forest(puzzleInput)

var visibleTrees: Int = 0
var perimeterTrees: Int = (forest.treeMap.count + forest.treeMap.first!.count) * 2 - 4

let maxRow: Int = forest.treeMap.count - 1
let maxCol: Int = forest.treeMap.first!.count - 1

for treeRow in 1..<maxRow {
    for treeCol in 1..<maxCol where forest.treeMap[treeRow][treeCol].isVisible {
            visibleTrees += 1
        }
}

print(perimeterTrees + visibleTrees)

var bestScenicScore: Int = 0

for treeRow in 1..<maxRow {
    for treeCol in 1..<maxCol {
        bestScenicScore = max(bestScenicScore, forest.treeMap[treeRow][treeCol].scenicScore)
    }
}

print(bestScenicScore)
