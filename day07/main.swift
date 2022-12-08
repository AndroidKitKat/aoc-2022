//
//  main.swift
//  day07
//
//  Created by Michael Eisemann on 12/7/22.
//

import Foundation

final class File {
    let isDirectory: Bool
    let name: String
    let absolutePath: String
    
    // only files have sizes, but if you ask for the size of a directory,
    // it will give you the size of all the children!
    let fileSize: Int
    // only directories have children
    var childrenFiles: [File]
    var usedSpace = 0

    var parentPath: String {
        absolutePath.components(separatedBy: "/").dropLast(1).joined(separator: "/") == "" ? "/" : absolutePath.components(separatedBy: "/").dropLast(1).joined(separator: "/")
    }
    
    init(isDirectory: Bool, name: String, absolutePath: String, fileSize: Int, childrenFiles: [File]) {
        self.isDirectory = isDirectory
        self.name = name
        self.absolutePath = absolutePath
        self.fileSize = fileSize
        self.childrenFiles = childrenFiles
    }
    
    func addFile(file: File) {
        childrenFiles.append(file)
    }
}

final class HistoryParser {
    private var currentDirectory: String = ""
    var dirs: [File] = []
    let root: File
    
    init(_ rawShellHistory: [String]) {
        // create the root directory
        self.root = File(isDirectory: true, name: "/", absolutePath: "/", fileSize: 0, childrenFiles: [])
        self.dirs.append(root)
        // let's hit it!
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
                // dirname is historyComponents[1]
                let newDir = File(isDirectory: true, name: historyComponents[1], absolutePath: self.currentDirectory == "/" ? self.currentDirectory + historyComponents[1] : self.currentDirectory + "/" + historyComponents[1], fileSize: 0, childrenFiles: [])
                
                if let dirParentDir = find(directory: self.dirs[0], for: newDir.parentPath) {
                    dirParentDir.addFile(file: newDir)
                } else {
                    self.dirs[0].addFile(file: newDir)
                }
                break
                
            default:
                // file size is historyComponents[0]
                // file name is historyComponents[1]
                let newFile = File(isDirectory: false, name: historyComponents[1], absolutePath: self.currentDirectory == "/" ? self.currentDirectory + historyComponents[1] : self.currentDirectory + "/" + historyComponents[1], fileSize: Int(historyComponents[0])!, childrenFiles: [])
                
                if let fileParentDir = find(directory: self.dirs[0], for: newFile.parentPath) {
                    fileParentDir.addFile(file: newFile)
                } else {
                    self.dirs[0].addFile(file: newFile)
                }
                break
            }
        }
        
        // fix the obama nation that is my disjoint tree
//        self.traverse(directory: self.dirs[0])
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
    
    private func find(directory: File, for parent: String ) -> File?{
        if directory.absolutePath == parent {
            return directory
        }
        var foundFile: File? = nil
        for child in directory.childrenFiles where child.isDirectory {
            foundFile = find(directory: child, for: parent)
        }
        
        return foundFile
    }
}

var puzzleInput: [String] = []

while let line = readLine() {
    puzzleInput.append(line)
}

let historyParser = HistoryParser(puzzleInput)

// this is where I would put my solutions
