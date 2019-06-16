//
//  DataStorageManager.swift
//  PP2
//
//  Created by Alexey Goryunov on 5/29/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit
import RealmSwift

class DataStorageManager: NSObject, DataStorageManagerProtocol {

    // TODO: use single Realm connection?

    func resetData() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

    func storeGameStatistics(_ statistics: GameStatistics) {
        do {
            let realm = try! Realm()
            try realm.write {
                let dsStatistics = DSGameStatistics.create(fromStatistics: statistics)
                realm.add(dsStatistics)
            }
        }
        catch {
            LogManager.shared.error("oops")
        }
    }

    func getLastTwoSteps() -> [GameStatistics] {
        let realm = try! Realm()
        let requestedSteps = realm.objects(DSGameStatistics.self).sorted(byKeyPath: "turnNumber", ascending: true)
        var array = [GameStatistics]()
        if (requestedSteps.count > 1) {
            let prevDsStat = requestedSteps[requestedSteps.count-2]
            let lastDsStat = requestedSteps.last!
            array.append(prevDsStat.convertToStatistics())
            array.append(lastDsStat.convertToStatistics())
        }
        return array
    }

}
