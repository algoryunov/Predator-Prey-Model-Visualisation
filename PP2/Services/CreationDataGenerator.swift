//
//  CreaturesDataGenerator.swift
//  PP2
//
//  Created by Alexey Goryunov on 23/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import Foundation

class CreaturesDataGenerator : NSObject {
    
    // MARK: Public
    
    class func generateCreaturesAndPositions(withConfiguration configuration: GameConfiguration) -> [Creature] {
        let creatures = self.generateCreatures(configuration)
        self.generatePositionsForCreatures(creatures, configuration)
        return creatures
    }
    
    // MARK: Private
    
    private class func generateCreatures(_ configuration: GameConfiguration) -> Array<Creature> {
        let tilesNumber = configuration.mapSize.width * configuration.mapSize.height
        let totalCreaturesNumber = configuration.creaturesFillConfig.fillCoef * Double(tilesNumber)

        let predatorsNumber = Int(totalCreaturesNumber * configuration.creaturesFillConfig.predatorCoef())
        let preysNumber = Int(totalCreaturesNumber * configuration.creaturesFillConfig.preyCoef)

        let initialHungerCoef = configuration.lifecycleConfig.initialHungerCoef;

        var creatures: [Creature] = []

        if predatorsNumber > 0 {
            for index in 1...predatorsNumber {
                let predator = Creature()
                predator.type = CreatureType.predator
                predator.id = index
                predator.hungerCoef = initialHungerCoef
                creatures.append(predator)
            }
        }

        if preysNumber > 0 {
            for index in 1...preysNumber {
                let prey = Creature()
                prey.type = CreatureType.prey
                prey.id = predatorsNumber + index
                prey.hungerCoef = initialHungerCoef
                creatures.append(prey)
            }
        }
        
        return creatures
    }
    
    private class func generatePositionsForCreatures(_ creatures: Array<Creature>, _ configuration: GameConfiguration) {
        var occupiedPositions = Set<Position>()
        
        for creature in creatures {
            let position = Position()
            
            func isPositionOccupied(_ position: Position) -> Bool {
                for pos in occupiedPositions {
                    if (pos.x == position.x && pos.y == position.y) {
                        return true
                    }
                }
                return false
            }

            var randomPosition = Position()
            while (isPositionOccupied(randomPosition)) {
                randomPosition = self.generateRandomPosition(tableWidth: configuration.mapSize.width, tableHeight: configuration.mapSize.height)
            }

            occupiedPositions.insert(randomPosition)
            creature.position = randomPosition
        }
    }
    
    private class func generateRandomPosition(tableWidth: Int, tableHeight: Int) -> Position {
        let position = Position()
        position.x = Int.random(in: 0 ... tableWidth - 1)
        position.y = Int.random(in: 0 ... tableHeight - 1)
        return position
    }
}
