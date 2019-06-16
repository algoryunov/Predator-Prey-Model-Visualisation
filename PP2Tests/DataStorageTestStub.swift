//
//  DataStorageTestStub.swift
//  PP2Tests
//
//  Created by Alexey Goryunov on 6/16/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class DataStorageTestStub: NSObject, DataStorageManagerProtocol {

    private var data = [GameStatistics]()

    func resetData() {
        data = []
    }

    func storeGameStatistics(_ statistics: GameStatistics) {
        data.append(statistics)
    }

    func getLastTwoSteps() -> [GameStatistics] {
        var retval = [GameStatistics]()
        if data.count == 0 {
            return retval
        }

        if data.count == 1 {
            retval.append(data.last!)
            return retval
        }

        data.sort { (o1, o2) -> Bool in
            return o1.turnNumber < o2.turnNumber
        }

        retval.append(data[data.count - 2])
        retval.append(data.last!)
        return retval
    }

}
