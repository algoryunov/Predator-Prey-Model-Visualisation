//
//  CoordinationProtocols.swift
//  PP2
//
//  Created by Alexey Goryunov on 6/3/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

protocol MainCoordinationDelegate {
    func didTapOnDetails(currentConfiguration configuration: GameConfiguration, actualTrend trend: GameStatisticsTrend)
    func didTapOnSaveBack(withNewConfiguration configuration: GameConfiguration)
}
