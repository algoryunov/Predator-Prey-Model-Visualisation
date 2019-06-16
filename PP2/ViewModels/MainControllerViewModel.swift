//
//  MainControllerViewModel.swift
//  PP2
//
//  Created by Alexey Goryunov on 21/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import Foundation
import RxSwift

class MainControllerViewModel {

    // MARK: Variables
    var coordinationDelegate: MainCoordinationDelegate?
    var turnManager = TurnManager()
    let gameStatisticsManager: GameStatisticsManager

    var gameConfiguration = GameConfiguration()
    var creatures = Variable<[Creature]>.init([])
    var statisticsTrend = Variable<GameStatisticsTrend>.init(GameStatisticsTrend())

    // MARK: Initializers

    init(withConfiguration configuration: GameConfiguration, coordinationDelegate delegate: MainCoordinationDelegate?) {
        self.gameConfiguration = configuration
        turnManager = TurnManager(withConfiguration: configuration)
        self.coordinationDelegate = delegate
        self.gameStatisticsManager = GameStatisticsManager(withDataStorageManager: DataStorageManager() as DataStorageManagerProtocol)

        self.gameStatisticsManager.resetData()
        self.generateCreatures()
        let newStatistics = GameStatisticsManager.captureGameStatistics(self.creatures.value, 0, 0.0)
        self.storeAndUpdateStatisticsTrend(withNewStatistics: newStatistics)
    }

    // MARK: Public Utils

    func generateMapViewModel() -> MapViewModel {
        return MapViewModel(withMainViewModel: self)
    }
    
    func handleNextTurn(withStatusUpdateCallback callback: @escaping TurnStatusBlock, completionBlock completion: @escaping  () -> Void ) {
        DispatchQueue.global(qos: .default).async {
            autoreleasepool {
                do {
                    let internalCompletion = { (_ result: TurnResult) in
                        DispatchQueue.main.async {
                            self.creatures.value = result.creatures
                            let newStatistics = GameStatisticsManager.captureGameStatistics(result.creatures, result.stepNumber, result.stepDuration)
                            self.storeAndUpdateStatisticsTrend(withNewStatistics: newStatistics)
                            completion()
                        }
                    }
                    
                    try self.turnManager.makeTurn(withCreatures:self.creatures.value, statusCallback: callback, completionBlock: internalCompletion)
                }
                catch {
                    LogManager.shared.error("oops")
                }
            }
        }
    }
    
    func restartGame() {
        self.turnManager.currentStepNumber = 0
        let dataStorageManager = DataStorageManager()
        dataStorageManager.resetData();
        self.generateCreatures()
        let newStatistics = GameStatisticsManager.captureGameStatistics(self.creatures.value, 0, 0.0)
        self.storeAndUpdateStatisticsTrend(withNewStatistics: newStatistics)
    }

    func didTapOnDetails() {
        guard coordinationDelegate != nil else {
            return
        }

        coordinationDelegate!.didTapOnDetails(currentConfiguration: gameConfiguration, actualTrend: statisticsTrend.value)
    }

    func update(withNewConfiguration configuration: GameConfiguration) {
        self.gameConfiguration = configuration
        turnManager.gameConfiguration = configuration
    }

    // MARK: Private Utils
    
    private func generateCreatures() {
        self.creatures.value = CreaturesDataGenerator.generateCreaturesAndPositions(withConfiguration: self.gameConfiguration)
    }

    private func storeAndUpdateStatisticsTrend(withNewStatistics newStatistics: GameStatistics) {
        gameStatisticsManager.storeNewStatistics(newStatistics)
        if let newTrend = gameStatisticsManager.getStatisticsTrend() {
            self.statisticsTrend.value = newTrend
        }
        else {
            self.generateStatisticsFromLocalData()
        }
    }

    private func generateStatisticsFromLocalData() {
        let trend = GameStatisticsTrend()
        for creature in creatures.value {
            if creature.type == .predator {
                trend.predatorsNumber += 1
            }
            else if creature.type == .prey {
                trend.preysNumber += 1
            }
        }
        trend.stepNumber = 0
        trend.currentTotalCount = creatures.value.count

        self.statisticsTrend.value = trend
    }
}
