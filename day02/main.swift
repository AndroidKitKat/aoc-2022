//
//  main.swift
//  day02
//
//  Created by Michael Eisemann on 12/1/22.
//

import Foundation

/*
a,x = rock, b,y = paper, c,z = scissors
1           2            3

0 loss, 3 draw, 6 win

game logic
rock: beats scissor, loses to paper
paper: beats rock, loses scissors
scissors: beats paper, loses rock

x = lose, y = draw, z = win
*/

let gameLogic: [String: [String]] = [
  "A": ["Z", "X", "Y"],
  "B": ["X", "Y", "Z"],
  "C": ["Y", "Z", "X"]
]

let gameLogic2: [String: [String: Int]] = [
  "A": [
    "X": 3,
    "Y": 1,
    "Z": 2
  ],
  "B": [
    "X": 1,
    "Y": 2,
    "Z": 3
  ],
  "C": [
    "X": 2,
    "Y": 3,
    "Z": 1
  ]
]

var totalScore: Int = 0
var totalScore2: Int = 0

while let line = readLine() {
    let splitLine = line.split(separator: " ")
    guard let moveValue = Character(String(splitLine[1])).asciiValue else { break }
    let outcomeValue = gameLogic[String(splitLine[0])]!.firstIndex(of: String(splitLine[1]))! * 3

    totalScore += Int(moveValue) - 87 + outcomeValue
    let moveValue2 = gameLogic2[String(splitLine[0])]![String(splitLine[1])]!
    totalScore2 += ((Int(moveValue) - 88) * 3) + moveValue2

}

print(totalScore)
print(totalScore2)
