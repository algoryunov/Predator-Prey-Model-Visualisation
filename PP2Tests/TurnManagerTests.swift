//
//  TurnManagerTests.swift
//  PP2Tests
//
//  Created by Alexey Goryunov on 6/1/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import XCTest

class TurnManagerTests: XCTestCase {

    var gameConfiguration = GameConfiguration()

    override func setUp() {
        gameConfiguration = GameConfiguration()
        gameConfiguration.mapSize.width = 10
        gameConfiguration.mapSize.height = 10
        gameConfiguration.creaturesFillConfig.fillCoef = 0.7
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreaturesMoved() {
        gameConfiguration.creaturesFillConfig.preyCoef = 1
        let creatures = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: gameConfiguration)

        let turnManager = TurnManager(withConfiguration: gameConfiguration)
        var creaturesCopy: [Creature] = []
        for creature in creatures {
            creaturesCopy.append(creature.duplicate())
        }

        let completionInvoked = XCTestExpectation(description: "completionInvoked")
        let completion = { (_ result: TurnResult) in
            completionInvoked.fulfill()
            var movedCreationsCount = 0
            for newCreature in result.creatures {
                let oldCreatureOpt = self.findCreation(withId: newCreature.id, in: creaturesCopy)
                if let oldCreature = oldCreatureOpt {
                    if oldCreature.position.isEqualToPosition(newCreature.position) == false {
                        movedCreationsCount += 1

                        if movedCreationsCount == 3 {
                            break
                        }
                    }
                }
            }

            XCTAssert(movedCreationsCount > 0, "no creations moved")
        }

        do {
            try turnManager.makeTurn(withCreatures: creatures, statusCallback: nil, completionBlock: completion)
        }
        catch {
            XCTFail("exception is thrown")
        }
        self.wait(for: [completionInvoked], timeout: 1.0)
    }

    func testNewCreaturesGenerated() {
        gameConfiguration.creaturesFillConfig.preyCoef = 1
        gameConfiguration.bornConfig.preyCoef = 0.9

        let creatures = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: gameConfiguration)
        let initialPreysNumber = 70.0
        let expectedPreysNumber = initialPreysNumber + initialPreysNumber * gameConfiguration.bornConfig.preyCoef
        let turnManager = TurnManager(withConfiguration: gameConfiguration)

        let completionInvoked = XCTestExpectation(description: "completionInvoked")
        let completion = { (_ result: TurnResult) in
            completionInvoked.fulfill()
            var newPreysNumber = 0.0
            for newCreature in result.creatures {
                if newCreature.type == .prey {
                    newPreysNumber += 1.0
                }
            }

            XCTAssert(abs(expectedPreysNumber - newPreysNumber) < 5, "too big discrepancy")
        }

        do {
            try turnManager.makeTurn(withCreatures: creatures, statusCallback: nil, completionBlock: completion)
        }
        catch {
            XCTFail("exception is thrown")
        }

        self.wait(for: [completionInvoked], timeout: 1.0)
    }

//    func testBornThreshold1() {
//        gameConfiguration.creaturesFillConfig.fillCoef = 1
//        gameConfiguration.creaturesFillConfig.preyCoef = 0.5
//
//    }

    func testPreysNumberDecreased() {
        gameConfiguration.creaturesFillConfig.fillCoef = 1
        gameConfiguration.creaturesFillConfig.preyCoef = 0.5

        let creatures = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: gameConfiguration)
        let initialPreysNumber = 50
        let turnManager = TurnManager(withConfiguration: gameConfiguration)
        let completionInvoked = XCTestExpectation(description: "completionInvoked")
        let completion = { (_ result: TurnResult) in
            completionInvoked.fulfill()
            var newPreysNumber = 0
            for newCreature in result.creatures {
                if newCreature.type == .prey {
                    newPreysNumber += 1
                }
            }

            XCTAssert((initialPreysNumber - newPreysNumber) > 0, "no preys were eaten")
        }

        do {
            try turnManager.makeTurn(withCreatures: creatures, statusCallback: nil, completionBlock: completion)
        }
        catch {
            XCTFail("exception is thrown")
        }
        self.wait(for: [completionInvoked], timeout: 1.0)
    }

    func testHungerCoefChanged() {
        gameConfiguration.lifecycleConfig.initialHungerCoef = 1
        gameConfiguration.lifecycleConfig.stepHungerConsumption = 0.5
        gameConfiguration.creaturesFillConfig.fillCoef = 0.1
        gameConfiguration.creaturesFillConfig.preyCoef = 0.0

        let creatures = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: gameConfiguration)
        let turnManager = TurnManager(withConfiguration: gameConfiguration)
        let completionInvoked = XCTestExpectation(description: "completionInvoked")
        let completion = { (_ result: TurnResult) in
            completionInvoked.fulfill()
            for newCreature in result.creatures {
                XCTAssert(newCreature.type == .predator, "should not be any preys")
                XCTAssert(newCreature.hungerCoef == 0.5, "wrong hunger coef")
            }
        }

        do {
            try turnManager.makeTurn(withCreatures: creatures, statusCallback: nil, completionBlock: completion)
        }
        catch {
            XCTFail("exception is thrown")
        }
        self.wait(for: [completionInvoked], timeout: 1.0)
    }

    func testCallbackAndCompletionCalled() {
        gameConfiguration.creaturesFillConfig.fillCoef = 0.1
        gameConfiguration.bornConfig.predatorCoef = 0.0
        gameConfiguration.creaturesFillConfig.preyCoef = 0.0

        let creatures = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: gameConfiguration)
        let turnManager = TurnManager(withConfiguration: gameConfiguration)
        let statusInvoked = XCTestExpectation(description: "statusInvoked")
        let statusCallback = { (_ status: TurnStatus) in
            XCTAssert(status.percentageCompleted >= 0, "wrong percentage")
            XCTAssert(status.percentageCompleted <= 100, "wrong percentage")
            XCTAssert(status.currentAction.count > 0, "wrong description")
            statusInvoked.fulfill()
        }

        let completionInvoked = XCTestExpectation(description: "completionInvoked")
        let completion = { (_ result: TurnResult) in
            completionInvoked.fulfill()
            XCTAssert(result.creatures.count == creatures.count, "wrong creatures number")
        }

        do {
            try turnManager.makeTurn(withCreatures: creatures, statusCallback: statusCallback, completionBlock: completion)
        }
        catch {
            XCTFail("exception is thrown")
        }

        self.wait(for: [statusInvoked, completionInvoked], timeout: 1.0)
    }

    func testStatistics() {
        gameConfiguration.creaturesFillConfig.fillCoef = 0.1
        gameConfiguration.creaturesFillConfig.preyCoef = 0.0
        gameConfiguration.bornConfig.predatorCoef = 0.0

        let creatures = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: gameConfiguration)
        let turnManager = TurnManager(withConfiguration: gameConfiguration)
        let completionInvoked = XCTestExpectation(description: "completionInvoked")
        let completion = { (_ result: TurnResult) in
            XCTAssert(result.creatures.count == creatures.count, "wrong creatures number")
            let stat = GameStatisticsManager.captureGameStatistics(result.creatures, result.stepNumber, result.stepDuration)
            XCTAssert(stat.predatorCount == result.creatures.count, "wrong statistics")
            XCTAssert(stat.preyCount == 0, "wrong statistics")
            XCTAssert(stat.turnNumber == 1, "wrong statistics")
            XCTAssert(stat.turnDuration > 0, "wrong statistics")
            completionInvoked.fulfill()
        }

        do {
            try turnManager.makeTurn(withCreatures: creatures, statusCallback: nil, completionBlock: completion)
        }
        catch {
            XCTFail("exception is thrown")
        }

        self.wait(for: [completionInvoked], timeout: 1.0)
    }

    // MARK: Utils

    private func findCreation(withId id: Int, in array: [Creature]) -> Creature? {
        for creature in array {
            if creature.id == id {
                return creature
            }
        }
        return nil
    }
}
