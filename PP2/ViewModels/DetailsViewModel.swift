//
//  DetailsViewModel.swift
//  PP2
//
//  Created by Alexey Goryunov on 6/2/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class DetailsViewModel: NSObject {

    var coordinationDelegate: MainCoordinationDelegate? //TODO: weak
    var gameConfiguration: GameConfiguration
    var trend: GameStatisticsTrend

    init(withConfiguration configuration: GameConfiguration, actualTrend trend: GameStatisticsTrend, coordinationDelegate delegate: MainCoordinationDelegate) {
        self.gameConfiguration = configuration
        self.trend = trend
        self.coordinationDelegate = delegate
    }

    func generateStatisticsViewModel() -> GameStatisticsViewModel {
        return GameStatisticsViewModel(withTrend: self.trend)
    }

    func generateSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(withConfiguration: self.gameConfiguration)
    }

    func didTapOnSaveBack(_ newConfiguration: GameConfiguration) {
        guard coordinationDelegate != nil else {
            return
        }

        coordinationDelegate!.didTapOnSaveBack(withNewConfiguration: newConfiguration)
    }

}
