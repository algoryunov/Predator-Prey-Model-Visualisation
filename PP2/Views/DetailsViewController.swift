//
//  DetailsViewController.swift
//  PP2
//
//  Created by Alexey Goryunov on 6/1/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var viewModel: DetailsViewModel

    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var settingsView: UIView!

    var statisticsViewController: GameStatisticsViewController
//    var chartViewController: TrendChartViewController
    var settingsViewController: SettingsViewController

    init(withViewModel viewModel: DetailsViewModel) {
        self.viewModel = viewModel

        let statisticsViewModel = self.viewModel.generateStatisticsViewModel()
        let statisticsViewController = GameStatisticsViewController.gameStatisticsViewController(withViewModel: statisticsViewModel)
        self.statisticsViewController = statisticsViewController

        let settingsViewModel = self.viewModel.generateSettingsViewModel()
        self.settingsViewController = SettingsViewController.settingsViewController(withViewModel: settingsViewModel)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.layoutChildControllers()
    }

    private func layoutChildControllers() {
        self.addChild(self.settingsViewController)
        self.settingsViewController.willMove(toParent: self)
        self.settingsViewController.view.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: self.settingsView.frame.size)
        self.settingsView.addSubview(self.settingsViewController.view)
        self.settingsViewController.didMove(toParent: self)

        self.addChild(self.statisticsViewController)
        self.statisticsViewController.willMove(toParent: self)
        self.statisticsViewController.view.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: self.statisticsView.frame.size)
        self.statisticsView.addSubview(self.statisticsViewController.view)
        self.statisticsViewController.didMove(toParent: self)
    }

    @IBAction func didTapSaveBack(_ sender: Any) {
        let newConfiguration = self.settingsViewController.captureConfiguration()
        self.viewModel.didTapOnSaveBack(newConfiguration)
    }
}
