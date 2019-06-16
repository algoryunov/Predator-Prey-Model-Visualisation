//
//  GameStatisticsManager.swift
//  PP2
//
//  Created by Alexey Goryunov on 5/29/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class GameStatisticsManager: NSObject {

    let dataStorageManager: DataStorageManagerProtocol

    init(withDataStorageManager manager: DataStorageManagerProtocol) {
        self.dataStorageManager = manager
    }

    func resetData() {
        dataStorageManager.resetData()
    }

    func getStatisticsTrend() -> GameStatisticsTrend? {
        let trend = GameStatisticsTrend()

        let lastTwoSteps = dataStorageManager.getLastTwoSteps()
        if lastTwoSteps.count == 0 {
            return nil
        }

        let lastStep = lastTwoSteps.last!
        let prevStep = lastTwoSteps.first!
        trend.preysNumber = lastStep.preyCount
        trend.predatorsNumber = lastStep.predatorCount
        trend.lastTurnDuration = lastStep.turnDuration
        trend.currentTotalCount = trend.preysNumber + trend.predatorsNumber
        trend.stepNumber = lastStep.turnNumber
        if lastStep.turnNumber != prevStep.turnNumber {
            trend.preysTrend = self.calculateTrend(fromPreviousValue: Double(prevStep.preyCount), andCurrentValue: Double(lastStep.preyCount))
            trend.predatorsTrend = self.calculateTrend(fromPreviousValue: Double(prevStep.predatorCount), andCurrentValue: Double(lastStep.predatorCount))
            trend.currentTotalTrend = self.calculateTrend(fromPreviousValue: Double(prevStep.totalCreaturesCount()), andCurrentValue: Double(lastStep.totalCreaturesCount()))
        }

        LogManager.shared.log("Predators: Previous: \(prevStep.predatorCount); Last: \(lastStep.predatorCount); Trend: \(trend.predatorsTrend)")
        LogManager.shared.log("Preys: Previous: \(prevStep.preyCount); Last: \(lastStep.preyCount); Trend: \(trend.preysTrend)")

        return trend
    }

    func storeNewStatistics(_ newStatistics: GameStatistics!) {
        if let statistics = newStatistics {
            dataStorageManager.storeGameStatistics(statistics)
        }
    }

    class func captureGameStatistics(_ creatures: Array<Creature>, _ stepNumber: Int, _ duration: TimeInterval) -> GameStatistics {
        let statistic = GameStatistics()
        for creature in creatures {
            if creature.type == CreatureType.prey {
                statistic.preyCount += 1
            }
            else if creature.type == CreatureType.predator {
                statistic.predatorCount += 1
            }
        }

        statistic.turnNumber = stepNumber
        statistic.turnDuration = Double(duration)

        return statistic
    }

    // MARK: Private

    private func calculateTrend(fromPreviousValue prevVal: Double, andCurrentValue currentVal: Double) -> Double {
        if prevVal == 0.0 {
            return currentVal
        }

        return currentVal / prevVal
    }
}
