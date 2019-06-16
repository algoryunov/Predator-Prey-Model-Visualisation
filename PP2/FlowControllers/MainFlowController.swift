//
//  MainFlowController.swift
//  PP2
//
//  Created by Alexey Goryunov on 20/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import Foundation

class MainFlowController : BaseFlowController, MainCoordinationDelegate {

    var mainViewController: MainViewController
    var detailsViewController: DetailsViewController?

    // MARK: Initializers

    init(withGameConfiguration gameConfiguration: GameConfiguration) {
        let mainControllerViewModel = MainControllerViewModel(withConfiguration: gameConfiguration, coordinationDelegate: nil)
        mainViewController = MainViewController(withViewModel: mainControllerViewModel)
        detailsViewController = nil
        super.init(nibName: nil, bundle: nil)

        mainControllerViewModel.coordinationDelegate = self // TODO: ???
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addChild(mainViewController)

        self.mainViewController.willMove(toParent: self)
        self.view.addSubview(self.mainViewController.view)
        self.mainViewController.didMove(toParent: self)

        let tutorialViewController = TutorialViewController()
        tutorialViewController.modalPresentationStyle = .overCurrentContext
        self.present(tutorialViewController, animated: false, completion: nil)
    }

    // MARK: MainCoordinationDelegate

    func didTapOnDetails(currentConfiguration configuration: GameConfiguration, actualTrend trend: GameStatisticsTrend) {
        let detailViewModel = DetailsViewModel(withConfiguration: configuration, actualTrend: trend, coordinationDelegate: self)
        detailsViewController = DetailsViewController(withViewModel: detailViewModel)
        self.addChild(detailsViewController!)
        self.transition(from: mainViewController, to: detailsViewController!, duration: 0.3, options: .init(), animations: nil, completion: nil)
    }

    func didTapOnSaveBack(withNewConfiguration configuration: GameConfiguration) {
        guard detailsViewController != nil else {
            return
        }

        mainViewController.viewModel.update(withNewConfiguration: configuration)

        self.transition(from: detailsViewController!, to: mainViewController, duration: 0.3, options: .init(), animations: nil, completion: nil)

        detailsViewController = nil
    }

}
