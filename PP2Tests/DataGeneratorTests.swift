//
//  DataGeneratorTests.swift
//  PP2Tests
//
//  Created by Alexey Goryunov on 6/1/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import XCTest

class DataGeneratorTests: XCTestCase {

    var gameConfiguration = GameConfiguration()

    override func setUp() {
        gameConfiguration = GameConfiguration()
        gameConfiguration.mapSize.width = 10
        gameConfiguration.mapSize.height = 10
        gameConfiguration.creaturesFillConfig.fillCoef = 0.7
        gameConfiguration.creaturesFillConfig.preyCoef = 0.1
    }

    override func tearDown() {
    }

    func testNumberOfCreations() {
        let creatures = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: gameConfiguration)

        var preysNumber = 0
        var predatorsNumber = 0

        for creature in creatures {
            if creature.type == .prey {
                preysNumber += 1
            }
            else if creature.type == .predator {
                predatorsNumber += 1
            }
        }

        XCTAssertEqual(preysNumber, 7)
        XCTAssertEqual(predatorsNumber, 63)
        XCTAssertEqual(creatures.count, 70)
    }

    func testCreaturesOnMap() {
        let creatures = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: gameConfiguration)

        for creature in creatures {
            let position = creature.position
            if (position.x < 0 || position.x > gameConfiguration.mapSize.width ||
                position.y < 0 || position.y > gameConfiguration.mapSize.height) {
                XCTFail("creature is not on the map")
            }
        }
    }

    func testCreaturesOnMapFullFill() {
        gameConfiguration.mapSize.width = 30
        gameConfiguration.mapSize.height = 30
        gameConfiguration.creaturesFillConfig.fillCoef = 1.0
        gameConfiguration.creaturesFillConfig.preyCoef = 1.0
        let creatures = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: gameConfiguration)

        var occupiedPositions = [Position]()
        for creature in creatures {
            if !occupiedPositions.contains(creature.position) {
                occupiedPositions.append(creature.position)
            }
            else {
                XCTFail("wrong position generated")
            }
        }
        XCTAssert(occupiedPositions.count == 900)
    }

    func testCreaturesPositionsDuplicates() {
        let creatures = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: gameConfiguration)
        let occupiedPositions: [Position] = []

        func isPositionOccupied(_ positionToCheck: Position) -> Bool {
            for position in occupiedPositions {
                if positionToCheck.isEqualToPosition(position) {
                    return true
                }
            }
            return false
        }

        for creature in creatures {
            if isPositionOccupied(creature.position) {
                XCTFail("creatures positions are duplicated")
            }
        }
    }
}
