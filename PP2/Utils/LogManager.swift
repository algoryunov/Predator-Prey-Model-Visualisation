//
//  LogManager.swift
//  PP2
//
//  Created by Alexey Goryunov on 6/8/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

enum LogLevelType {
    case LogLevelTypeNone
    case LogLevelTypeAll
}

class LogManager: NSObject {

    static let shared = LogManager()

    var logLevel = LogLevelType.LogLevelTypeNone

    func log(_ message: String?) {
        if let logMessage = message {
            if logLevel == .LogLevelTypeAll {
                print(logMessage)
            }
        }
    }

    func error(_ message: String?) {
        if let logMessage = message {
            if logLevel != .LogLevelTypeNone {
                print(logMessage)
                assert(false);
            }
        }
    }

}
