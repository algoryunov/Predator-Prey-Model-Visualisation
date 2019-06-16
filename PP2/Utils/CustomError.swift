//
//  CustomError.swift
//  PP2
//
//  Created by Alexey Goryunov on 27/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import Foundation

enum TurnManagerError: Error {
    case wrongSetup(description: String)
}

enum GameStatisticsManagerError: Error {
    case wrongSetup(description: String)
}

extension TurnManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongSetup(description: let description):
            return "wrong setup: '\(description)'"
        }
    }
}

extension GameStatisticsManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongSetup(description: let description):
            return "wrong setup: '\(description)'"
        }
    }
}
