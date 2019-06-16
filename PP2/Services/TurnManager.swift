//
//  TurnManager.swift
//  PP2
//
//  Created by Alexey Goryunov on 24/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import Foundation

typealias TurnCompletionBlock = (_ turnResult : TurnResult) -> ()
typealias TurnStatusBlock = (_ turnStatus : TurnStatus) -> ()

enum Direction {
    case upLeft
    case up
    case upRight
    case left
    case center
    case right
    case downLeft
    case down
    case downRight
}

class TurnStatus {
    var currentAction: String
    var percentageCompleted: Int

    init () {
        currentAction = "Making a turn..."
        percentageCompleted = 0
    }

    init(withActionDescription action: String, percentageCompleted percentage: Int) {
        currentAction = action
        percentageCompleted = percentage
    }
}

class TurnResult {
    var creatures: [Creature] = []
    var stepNumber = 0
    var stepDuration = 0.0
}

class TurnManager: NSObject {

    var gameConfiguration: GameConfiguration?
    var currentStepNumber = 0

    // MARK: Public

    override init () { }

    init(withConfiguration configuration: GameConfiguration) {
        gameConfiguration = configuration
    }
    
    func makeTurn(withCreatures creaturesInput: Array<Creature>, statusCallback callback: TurnStatusBlock?, completionBlock completion: TurnCompletionBlock?) throws {
        let startTime = Date.init(timeIntervalSinceNow: 0)
        guard gameConfiguration != nil else {
            throw TurnManagerError.wrongSetup(description: "no configuration")
        }

        var creatures = creaturesInput

        if let statusCallback = callback {
            statusCallback(TurnStatus(withActionDescription: "Moving creatures...", percentageCompleted: 0))
        }
        try self.moveCreatures(creatures)

        if let statusCallback = callback {
            statusCallback(TurnStatus(withActionDescription: "Generating new creatures...", percentageCompleted: 33))
        }
        try self.generateNewCreatures(from: &creatures)

        if let statusCallback = callback {
            statusCallback(TurnStatus(withActionDescription: "Eatintg preys, adjust predator's hunger coef...", percentageCompleted: 66))
        }
        try self.updateCreaturesLifecycle(&creatures)

        let duration = Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970 - startTime.timeIntervalSince1970
        currentStepNumber += 1

        let turnResult = TurnResult()
        turnResult.creatures = creatures
        turnResult.stepDuration = duration
        turnResult.stepNumber = currentStepNumber

        if let completionBlock = completion {
            completionBlock(turnResult)
        }
    }

    // MARK: Private (Steps)

    private func maxCreatureIndex(from creatures: [Creature]) -> Int {
        var max = -1
        for creature in creatures {
            if creature.id > max {
                max = creature.id
            }
        }
        return max
    }

    private func moveCreatures(_ creatures: [Creature]) throws {
        for creature in creatures {
            let directionsToExclude = self.moveDirectionsToExclude(forCreature: creature, allCreatures: creatures, withThreshold: gameConfiguration!.bornConfig.creaturesOnPositionThreshold)
            if let position = try self.generateNewPosition(fromPosition: creature.position, directionsToExclude: directionsToExclude) {
                 creature.position = position
            }
        }
    }

    private func generateNewCreatures(from creatures: inout [Creature]) throws {
        guard let configuration = gameConfiguration else {
            throw TurnManagerError.wrongSetup(description: "no configuration")
        }

        var maxCreatureIndex = self.maxCreatureIndex(from: creatures)
        let originalCreatures = creatures

        for creature in originalCreatures {
            var bornCoef = 0 as Double
            if (creature.type == CreatureType.prey) {
                bornCoef = configuration.bornConfig.preyCoef * 100
            }
            else if (creature.type == CreatureType.predator) {
                bornCoef = configuration.bornConfig.predatorCoef * 100
            }

            let randomValue = Double(Int.random(in: 0 ... 100))
            LogManager.shared.log("\(randomValue - bornCoef) ::: random value: \(randomValue) born coef: \(bornCoef)")

            if (randomValue < bornCoef) {
                let newCreature = creature.duplicate()
                let directionsToExclude = self.moveDirectionsToExclude(forCreature: newCreature, allCreatures: creatures, withThreshold: configuration.bornConfig.creaturesOnPositionThreshold)
                if let position = try self.generateNewPosition(fromPosition: creature.position, directionsToExclude: directionsToExclude) {
                    newCreature.position = position
                    newCreature.id = maxCreatureIndex
                    newCreature.hungerCoef = configuration.lifecycleConfig.initialHungerCoef
                    creatures.append(newCreature)
                    maxCreatureIndex += 1
                }
            }
        }
    }

    private func updateCreaturesLifecycle(_ creatures: inout [Creature]) throws {
        guard let configuration = gameConfiguration else {
            throw TurnManagerError.wrongSetup(description: "no configuration")
        }

        for creature in creatures {
            if creature.type == CreatureType.predator {
                var preysToEatCount = 0.0
                for creatureToRemove in creatures {
                    if (creatureToRemove.type == CreatureType.prey &&
                        creatureToRemove.position.isEqualToPosition(creature.position)) {
                        creatureToRemove.hungerCoef = -1 // temporarily set to -1 to indicate that creature needs to be removed
                        preysToEatCount += 1.0
                    }
                }

                if preysToEatCount > 0 {
                    creature.hungerCoef += configuration.lifecycleConfig.eatenPreyValue * Double(preysToEatCount)
                }
                else {
                    creature.hungerCoef -= configuration.lifecycleConfig.stepHungerConsumption
                }
            }
        }

        creatures.removeAll { (creatureToRemove) -> Bool in
            return creatureToRemove.hungerCoef <= 0
        }
    }

    // MARK: Utils

    private func generateNewPosition(fromPosition position: Position, directionsToExclude excludeDirections: [Direction] = []) throws -> Position? {
        guard let mapSize = gameConfiguration?.mapSize else {
            throw TurnManagerError.wrongSetup(description: "no map size")
        }

        func isNewPositionValid(_ position: Position) -> Bool {
            if (position.x > mapSize.width  || position.x < 0 ||
                position.y > mapSize.height || position.y < 0) {
                return false
            }
            return true
        }

        let newPosition = Position()
        repeat {
            newPosition.x = position.x
            newPosition.y = position.y

            // TODO: can make a enum of Directions
            var directions = [Direction]()

            directions = [.upLeft,   .up,     .upRight,
                          .left,     .center, .right,
                          .downLeft, .down,   .downRight]

            var directionsToRemove: [Direction] = excludeDirections

            if position.x == 0 {
                directionsToRemove.append(contentsOf: [.upLeft, .left, .downLeft])
            }
            if position.x == mapSize.width - 1 {
                directionsToRemove.append(contentsOf: [.upRight, .right, .downRight])
            }
            if position.y == 0 {
                directionsToRemove.append(contentsOf: [.upLeft, .up, .upRight])
            }
            if position.y == mapSize.height - 1 {
                directionsToRemove.append(contentsOf: [.downLeft, .down, .downRight])
            }

            directions.removeAll { (value) -> Bool in
                return directionsToRemove.contains(value)
            }

            if directions.count == 0 {
                return nil
            }

            let direction = directions.randomElement()
            switch direction! {
            case .upLeft:
                newPosition.x -= 1
                newPosition.y -= 1
            case .up:
                newPosition.y -= 1
            case .upRight:
                newPosition.x += 1
                newPosition.y -= 1
            case .left:
                newPosition.x -= 1
            case .center:
                break
            case .right:
                newPosition.x += 1
            case .downLeft:
                newPosition.x -= 1
                newPosition.y += 1
            case .down:
                newPosition.y += 1
            case .downRight:
                newPosition.x += 1
                newPosition.y += 1
            }
        } while (!isNewPositionValid(newPosition))

        return newPosition
    }

    // TODO: test!
    private func moveDirectionsToExclude(forCreature creature: Creature,
                                         allCreatures creatures: [Creature],
                                         withThreshold positionTreshold: Int) -> [Direction] {
        if positionTreshold == 0 {
            return []
        }

        let position = creature.position
        var positionsAroundData = Dictionary<Direction, Int>()
        var directionsToExclude = [Direction]()
        for checkPosCreature in creatures {
            if let direction = position.directionTo(checkPosCreature.position) {
                if directionsToExclude.contains(direction) {
                    continue
                }
                if var currentValue = positionsAroundData[direction] {
                    currentValue = currentValue + 1
                    positionsAroundData[direction] = currentValue
                    if currentValue >= positionTreshold {
                        directionsToExclude.append(direction)
                    }

                    if directionsToExclude.count == 9 {
                        break
                    }
                }
                else {
                    positionsAroundData[direction] = 1
                }
            }
        }

        return directionsToExclude
    }
}
