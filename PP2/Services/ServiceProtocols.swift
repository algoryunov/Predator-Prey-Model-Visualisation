//
//  ServiceProtocols.swift
//  PP2
//
//  Created by Alexey Goryunov on 6/3/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

protocol DataStorageManagerProtocol {
    func resetData()
    func storeGameStatistics(_ statistics: GameStatistics)
    func getLastTwoSteps() -> [GameStatistics]
}
