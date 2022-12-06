//
//  main.swift
//  day06
//
//  Created by Michael Eisemann on 12/6/22.
//

import Foundation
import Algorithms

while let line = readLine() {
    var packetStartIndex: Int = 4
    for window in line.windows(ofCount: 4) {
        if Set(window).count == window.count {
            print(packetStartIndex)
            break
        }
        packetStartIndex += 1
    }
    
    var messageStartIndex: Int = 14
    for window in line.windows(ofCount: 14) {
        if Set(window).count == window.count {
            print(messageStartIndex)
            break
        }
        messageStartIndex += 1
    }
}


