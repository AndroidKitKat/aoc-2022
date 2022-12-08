//
//  main.swift
//  day07-2
//
//  Created by Michael Eisemann on 12/7/22.
//
//  Fuck you eric
//

import Foundation


final class HistoryParser {
    private var currentDirectory: String = ""
    
    var directories: [String: Int] = [:]
    
    init(_ rawShellHistory: [String]) {
        self.buildFileTree(from: rawShellHistory)
    }
    
    private func buildFileTree(from shellHistory: [String]) {
        for line in shellHistory {
            let historyComponents = line.components(separatedBy: " ")
            
            switch historyComponents[0] {
            case "$":
                switch historyComponents[1] {
                case "cd":
                    changeDirectory(to: historyComponents[2])
                    break
                    // I originally had an ls case here, but its not needed
                case "ls":
                    break
//                    print("ls of \(currentDirectory)")
                default:
                    fatalError("Unsupported command! \(historyComponents[1])")
                }
            case "dir":
                break
            default:
                // file size is 0
                let fileSize = Int(historyComponents[0])!
                var splitCurDur = currentDirectory.split(separator: "/")
                for pathPartIdx in 0...splitCurDur.count {
                    let dirPath = "/" + splitCurDur[0..<pathPartIdx].joined(separator: "/")
                    directories[dirPath, default: 0] += fileSize
                    
                }
                break
            }
        }
    }
    
    private func changeDirectory(to destinationDirectory: String) {
        var pathComponents = self.currentDirectory.components(separatedBy: "/").filter { !$0.isEmpty }
        // go up
        if destinationDirectory == ".." {
            _ = pathComponents.popLast()
        } else {
            pathComponents.append(destinationDirectory)
        }
        
        let newPath = pathComponents.joined(separator: "/")
        
        // handle the root case
        if newPath == "/" {
            self.currentDirectory = newPath
        } else {
            // general case, dirty hack to deal with the leading /
            // this does, however, break for files in the root dir lol
            self.currentDirectory = "/\(newPath)"
        }
    }
}

var puzzleInput: [String] = []

while let line = readLine() {
    puzzleInput.append(line)
}

let historyParser = HistoryParser(puzzleInput)

let needToFree: Int = historyParser.directories["/"]! - 40_000_000
var smallestDirSize: Int = Int.max

print("Part 1: " + String(historyParser.directories.values.filter { $0 < 100_000}.reduce(0, +)))

for dirSize in historyParser.directories.values {
    if dirSize >= needToFree {
        smallestDirSize = min(dirSize, smallestDirSize)
    }
}


print("Part 2: " + String(smallestDirSize))


