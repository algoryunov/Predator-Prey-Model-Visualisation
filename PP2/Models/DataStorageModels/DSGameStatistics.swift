//
//  DSGameStatistics.swift
//  PP2
//
//  Created by Alexey Goryunov on 6/3/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import RealmSwift

class DSGameStatistics: Object {
    @objc dynamic var turnNumber:    Int = 0
    @objc dynamic var preyCount:     Int = 0
    @objc dynamic var predatorCount: Int = 0
    @objc dynamic var turnDuration:  Double = 0.0

    func totalCreaturesCount() -> Int {
        return preyCount + predatorCount
    }

    override static func primaryKey() -> String? {
        return "turnNumber"
    }


    class func create(fromStatistics statistics: GameStatistics) -> DSGameStatistics {
        let dsStatistics = DSGameStatistics()
        dsStatistics.turnNumber = statistics.turnNumber
        dsStatistics.preyCount = statistics.preyCount
        dsStatistics.predatorCount = statistics.predatorCount
        dsStatistics.turnDuration = statistics.turnDuration
        return dsStatistics
    }

    func convertToStatistics() -> GameStatistics {
        let statistics = GameStatistics()
        statistics.turnNumber = self.turnNumber
        statistics.preyCount = self.preyCount
        statistics.predatorCount = self.predatorCount
        statistics.turnDuration = self.turnDuration
        return statistics
    }
}
