//
//  GameStatisticsViewModel.swift
//  PP2
//
//  Created by Alexey Goryunov on 5/29/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class GameStatisticsViewModel: NSObject {

    var gameStatisticsTrend: GameStatisticsTrend?

    override init() {
        
    }

    init(withTrend trend: GameStatisticsTrend) {
        gameStatisticsTrend = trend
    }

    func preysTrendImage() -> UIImage? {
        guard let trend = gameStatisticsTrend else {
            return nil
        }

        return self.imageForTrendValue(trend.preysTrend)
    }

    func predatorsTrendImage() -> UIImage? {
        guard let trend = gameStatisticsTrend else {
            return nil
        }

        return self.imageForTrendValue(trend.predatorsTrend)
    }

    func totalTrendImage() -> UIImage? {
        guard let trend = gameStatisticsTrend else {
            return nil
        }

        return self.imageForTrendValue(trend.currentTotalTrend)
    }

    // MARK: Private

    private func imageForTrendValue(_ val: Double) -> UIImage? {
        var imageName = ""
        if val == 1 || val == 0 {
            imageName = "Dash"
        }
        else {
            imageName = val > 1 ? "UpArrow" : "DownArrow"
        }
        return UIImage(named: imageName)
    }

}
