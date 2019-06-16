//
//  MapViewModel.swift
//  PP2
//
//  Created by Alexey Goryunov on 20/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import Foundation

class MapViewModel {

    var mapSize = MapSize()
    var cellViewModels: Array<MapCellViewModel> = [] //TODO: redo to dict?

    private var numberOfCreaturesOnPositions = Dictionary<Position, Int>()
    
    init(withMainViewModel mainModel: MainControllerViewModel?) {
        if let mainModel = mainModel {
            self.mapSize = mainModel.gameConfiguration.mapSize

            for i in 0...self.totalCreaturesNumber() {
                let cellViewModel = self.cellViewModelForCreatureAtIndex(i, fromCreatures: mainModel.creatures.value)
                cellViewModels.append(cellViewModel)
            }
        }
    }

    convenience init() {
        self.init(withMainViewModel: nil)
    }

    func totalCreaturesNumber() -> Int {
        return mapSize.height * mapSize.width
    }

    func cellViewModel(forIndexPath indexPath: IndexPath) -> MapCellViewModel {
        let position = self.calculatePosition(fromIndexPath: indexPath)
        return self.cellViewModel(forPosition: position)
    }

    func cellViewModel(forPosition position: Position) -> MapCellViewModel {
        for cellViewModel in cellViewModels {
            if position.isEqualToPosition(cellViewModel.position) {
                return cellViewModel
            }
        }

        return MapCellViewModel(withCreature: nil)
    }

    private func calculatePosition(fromIndexPath indexPath: IndexPath) -> Position {
        let position = Position()
        position.x = indexPath.row % self.mapSize.width
        position.y = indexPath.row / self.mapSize.width
        return position
    }

    private func cellViewModelForCreatureAtIndex(_ index: Int, fromCreatures creatures: [Creature]) -> MapCellViewModel {
        // TODO: optimize
        let path = IndexPath(row: index, section: 0)
        let position = self.calculatePosition(fromIndexPath: path)
        var creatureToReturn: Creature? = nil
        var numberOfCreaturesAtPosition = 0
        for creature in creatures {
            if creature.position.isEqualToPosition(position) {
                creatureToReturn = creature
                numberOfCreaturesAtPosition += 1
            }
        }
        return MapCellViewModel(withCreature: creatureToReturn, numberOfCreaturesAtPosition: numberOfCreaturesAtPosition)
    }
}
