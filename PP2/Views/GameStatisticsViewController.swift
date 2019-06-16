//
//  GameStatisticsViewController.swift
//  PP2
//
//  Created by Alexey Goryunov on 5/29/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class GameStatisticsViewController: UIViewController {

    // MARK: Variables

    var viewModel = GameStatisticsViewModel()

    @IBOutlet weak var preysNumberLabel: UILabel!
    @IBOutlet weak var preysTrendImageView: UIImageView!
    @IBOutlet weak var predatorsNumberLabel: UILabel!
    @IBOutlet weak var predatorsTrendImageView: UIImageView!
    @IBOutlet weak var totalNumberLabel: UILabel!
    @IBOutlet weak var totalNumberTrendImageView: UIImageView!
    @IBOutlet weak var stepNumberLabel: UILabel!

    // MARK: Initializers

    class func gameStatisticsViewController(withViewModel viewModel: GameStatisticsViewModel) -> GameStatisticsViewController {
        let controller = GameStatisticsViewController(nibName: "GameStatisticsViewController", bundle: nil)
        controller.viewModel = viewModel
        return controller
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateView()
    }

    // MARK: Public Utils
    func updateView() {
        guard let trend = self.viewModel.gameStatisticsTrend else {
            return
        }

        preysNumberLabel.text = "\(trend.preysNumber)"
        if let preyTrendImage = self.viewModel.preysTrendImage() {
            preysTrendImageView.image = preyTrendImage
        }
        predatorsNumberLabel.text = "\(trend.predatorsNumber)"
        predatorsTrendImageView.image = self.viewModel.predatorsTrendImage()

        totalNumberLabel.text = "\(trend.currentTotalCount)"
        if let totalTrendImage = self.viewModel.totalTrendImage() {
            totalNumberTrendImageView.image = totalTrendImage
        }
        stepNumberLabel.text = "\(trend.stepNumber)"
    }

}
