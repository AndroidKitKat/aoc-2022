//
//  main.swift
//  day09
//
//  Created by Michael Eisemann on 12/9/22.
//

import Foundation

enum Direction: String {
    case up = "U"
    case down = "D"
    case left = "L"
    case right = "R"
}

struct Move {
    // Vector!
    let magnitude: Int
    let direction: Direction
}

struct Position: Hashable {
    var x: Int
    var y: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    func isAdjacent(to other: Position) -> Bool {
        return (x == other.x && y == other.y) ||
               (y == other.y && abs(x - other.x) == 1) ||
               (x == other.x && abs(y - other.y) == 1) ||
               (abs(y - other.y) == 1 && abs(x - other.x) == 1)
    }
}

final class Board {
    private var headPosition: Position = Position(x: 0, y: 0)
    private var tailPosition: Position = Position(x: 0, y: 0)

    var headVisited: [Position] = []
    var tailVisited: [Position] = []
    
    var knots: [Int: Position] = [:]

    let moves: [Move]

    init(moves: [Move]) {
        self.moves = moves

        headVisited.append(headPosition)
        tailVisited.append(headPosition)
        for move in moves {
            self.moveHead(move: move)
        }
    }

    private func moveHead(move: Move) {
        switch move.direction {
        case .up:
            self.stepHead(to: move, in: "y", by: 1)
        case .down:
            self.stepHead(to: move, in: "y", by: -1)
        case .left:
            self.stepHead(to: move, in: "x", by: -1)
        case.right:
            self.stepHead(to: move, in: "x", by: 1)
        }

    }

    private func stepHead(to move: Move, in axis: Character, by amount: Int) {
        for _ in 1...move.magnitude {
            self.headVisited.append(headPosition)
            switch axis.lowercased().first {
            case "x":
                self.headPosition.x += amount
            case "y":
                self.headPosition.y += amount
            default:
                fatalError("Not a valid axis!")
            }

            // check to see if the head cannot see the tail
            if !tailPosition.isAdjacent(to: headPosition) {
                tailPosition = headVisited.last!
                tailVisited.append(tailPosition)
            }
        }
    }
}

var headMoves: [Move] = []

while let line = readLine() {
    let lineComponents = line.components(separatedBy: " ")
    headMoves.append(Move(magnitude: Int(lineComponents[1])!, direction: Direction(rawValue: lineComponents[0])!))
}

var board = Board(moves: headMoves)

//print(board.headVisited)

for move in board.tailVisited {
    print(move)
}

print(Set(board.tailVisited.map {$0}).count)
