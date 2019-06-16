//
//  GameStatisticsManagerTests.swift
//  PP2Tests
//
//  Created by Alexey Goryunov on 6/1/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import XCTest

class GameStatisticsManagerTests: XCTestCase {

    func testStoreResetData() {
        let gameStatisticsManager = GameStatisticsManager(withDataStorageManager: DataStorageTestStub())

        var trend = gameStatisticsManager.getStatisticsTrend()
        XCTAssert(trend == nil)

        let statistics = GameStatistics()
        statistics.turnNumber = 1

        gameStatisticsManager.storeNewStatistics(statistics)
        trend = gameStatisticsManager.getStatisticsTrend()
        XCTAssert(trend != nil)

        gameStatisticsManager.resetData()
        trend = gameStatisticsManager.getStatisticsTrend()
        XCTAssert(trend == nil)
    }

    func testStatisticsTrendOneStep() {
        let gameStatisticsManager = GameStatisticsManager(withDataStorageManager: DataStorageTestStub())

        let statistics = GameStatistics()
        statistics.turnNumber    = 1
        statistics.preyCount     = 2
        statistics.predatorCount = 3
        statistics.turnDuration  = 4

        gameStatisticsManager.storeNewStatistics(statistics)
        if let trend = gameStatisticsManager.getStatisticsTrend() {
            XCTAssert(trend.preysNumber == 2, "wrong trend")
            XCTAssert(trend.predatorsNumber == 3, "wrong trend")
            XCTAssert(trend.lastTurnDuration == 4, "wrong trend")
            XCTAssert(trend.currentTotalCount == 5, "wrong trend")
            XCTAssert(trend.stepNumber == 1, "wrong trend")
            XCTAssert(trend.preysTrend == 0.0, "wrong trend")
            XCTAssert(trend.predatorsTrend == 0.0, "wrong trend")
            XCTAssert(trend.currentTotalTrend == 0.0, "wrong trend")
        }
        else {
            XCTFail()
        }
    }

    func testStatisticsTrendManySteps() {
        let gameStatisticsManager = GameStatisticsManager(withDataStorageManager: DataStorageTestStub())

        let statistics1 = GameStatistics()
        statistics1.turnNumber    = 1
        statistics1.preyCount     = 10
        statistics1.predatorCount = 10
        statistics1.turnDuration  = 1
        gameStatisticsManager.storeNewStatistics(statistics1)

        let statistics2 = GameStatistics()
        statistics2.turnNumber    = 2
        statistics2.preyCount     = 15
        statistics2.predatorCount = 10
        statistics2.turnDuration  = 2
        gameStatisticsManager.storeNewStatistics(statistics2)

        let statistics3 = GameStatistics()
        statistics3.turnNumber    = 3
        statistics3.preyCount     = 20
        statistics3.predatorCount = 5
        statistics3.turnDuration  = 3
        gameStatisticsManager.storeNewStatistics(statistics3)

        if let trend = gameStatisticsManager.getStatisticsTrend() {
            XCTAssert(trend.preysNumber == 20, "wrong trend")
            XCTAssert(trend.predatorsNumber == 5, "wrong trend")
            XCTAssert(trend.lastTurnDuration == 3, "wrong trend")
            XCTAssert(trend.currentTotalCount == 25, "wrong trend")
            XCTAssert(trend.stepNumber == 3, "wrong trend")

            let expectedPreysTrend = 20.0 / 15.0
            XCTAssert(trend.preysTrend == expectedPreysTrend, "wrong trend")
            XCTAssert(trend.predatorsTrend == 0.5, "wrong trend")
            XCTAssert(trend.currentTotalTrend == 1.0, "wrong trend")
        }
        else {
            XCTFail()
        }
    }


}
