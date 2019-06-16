//
//  MainViewController.swift
//  PP2
//
//  Created by Alexey Goryunov on 20/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit
import RxSwift

class MainViewController : UIViewController {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var statisticsView: UIView!

    var viewModel: MainControllerViewModel
    var mapViewController: MapViewController
    var statisticsViewController: GameStatisticsViewController

    let disposeBag = DisposeBag()

    init(withViewModel viewModel: MainControllerViewModel) {
        self.viewModel = viewModel

        let mapViewModel = self.viewModel.generateMapViewModel()
        let mapViewController = MapViewController.mapViewController(withViewModel: mapViewModel)
        self.mapViewController = mapViewController

        let statisticsViewModel = GameStatisticsViewModel()
        self.statisticsViewController = GameStatisticsViewController.gameStatisticsViewController(withViewModel: statisticsViewModel)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.layoutChildControllers()
        self.bindViewModel()
    }
    
    // MARK: IBActions
    
    @IBAction func didTapNextTurn(_ sender: Any) {
        let activityIndicator = ActivityIndicator(withMessage: "Start...")
        let statusUpdateBlock = { (_ update: TurnStatus) in
            DispatchQueue.main.async { activityIndicator.updateText("\(update.percentageCompleted)%\n\(update.currentAction)")
            }
        }

        let completion = { () in
            DispatchQueue.main.async {
                activityIndicator.hide()
            }
        }

        activityIndicator.show(onView: self.view)
        self.viewModel.handleNextTurn(withStatusUpdateCallback: statusUpdateBlock, completionBlock: completion)
    }
    
    @IBAction func didTapRestart(_ sender: Any) {
        self.viewModel.restartGame()
    }
    
    @IBAction func didTapDetails(_ sender: Any) {
        self.viewModel.didTapOnDetails()
    }
    // MARK: Private

    private func layoutChildControllers() {
        self.addChild(self.mapViewController)
        self.mapViewController.willMove(toParent: self)
        let width = self.viewModel.gameConfiguration.mapSize.width * 35
        let height = self.viewModel.gameConfiguration.mapSize.height * 35 - 1
        let size = CGSize(width: width, height: height)
        self.mapViewController.collectionView.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
        self.mapView.addSubview(self.mapViewController.collectionView)
        self.mapViewController.didMove(toParent: self)

        self.addChild(self.statisticsViewController)
        self.statisticsViewController.willMove(toParent: self)
        self.statisticsViewController.view.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: self.statisticsView.frame.size)
        self.statisticsView.addSubview(self.statisticsViewController.view)
        self.statisticsViewController.didMove(toParent: self)
    }
    
    private func bindViewModel() {
        viewModel.creatures.asObservable().subscribe(onNext: { ([Creature]) in
            self.reloadMapController()
        }, onError: { (Error) in },
           onCompleted: {}) { }
            .disposed(by: disposeBag)

        viewModel.statisticsTrend.asObservable().subscribe(onNext: { newTrend in
            self.reloadStatisticsController(withNewTrend: newTrend)
        }, onError: { (Error) in },
           onCompleted: {}) { }
            .disposed(by: disposeBag)
    }

    private func reloadMapController() {
        DispatchQueue.main.async {
            let mapViewModel = self.viewModel.generateMapViewModel()
            self.mapViewController.viewModel = mapViewModel
            self.mapViewController.reloadMap()
        }
    }

    private func reloadStatisticsController(withNewTrend newTrend: GameStatisticsTrend) {
        DispatchQueue.main.async {
            let staticsViewModel = GameStatisticsViewModel(withTrend: newTrend)
            self.statisticsViewController.viewModel = staticsViewModel
            self.statisticsViewController.updateView()
        }
    }

}
