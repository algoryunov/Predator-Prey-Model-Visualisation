//
//  GameStatistic.swift
//  PP2
//
//  Created by Alexey Goryunov on 26/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import Foundation

class GameStatistics: NSObject {
    var turnNumber:    Int = 0
    var preyCount:     Int = 0
    var predatorCount: Int = 0
    var turnDuration:  Double = 0.0

    func totalCreaturesCount() -> Int {
        return preyCount + predatorCount
    }
}
