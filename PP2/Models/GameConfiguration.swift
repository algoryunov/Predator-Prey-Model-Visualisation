//
//  GameConfiguration.swift
//  PP2
//
//  Created by Alexey Goryunov on 20/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import Foundation

class MapSize: NSObject {
    var width  : Int = 28
    var height : Int = 20
    
    class func parseFromDict(_ dict: Dictionary<String, Any>) -> MapSize {
        let mapSize = MapSize()
        mapSize.width = dict["Width"] as! Int
        mapSize.height = dict["Height"] as! Int
        return mapSize
    }
}

class BornConfiguration: NSObject {
    var preyCoef:     Double = 0.5
    var predatorCoef: Double = 0.1
    var creaturesOnPositionThreshold: Int = 3
    
    class func parseFromDict(_ dict: Dictionary<String, Any>) -> BornConfiguration {
        let config = BornConfiguration()
        config.predatorCoef = dict["PreyCoef"] as! Double
        config.preyCoef = dict["PredatorCoef"] as! Double
        config.creaturesOnPositionThreshold = Int(dict["PositionThreshold"] as! Double)
        return config
    }
}

class CreaturesLifecycleConfiguration: NSObject {
    var initialHungerCoef: Double = 5.0
    var stepHungerConsumption: Double = 0.5
    var eatenPreyValue: Double = 1.0

    class func parseFromDict(_ dict: Dictionary<String, Any>) -> CreaturesLifecycleConfiguration {
        let config = CreaturesLifecycleConfiguration()
        config.initialHungerCoef = dict["InitialCoef"] as! Double
        config.stepHungerConsumption = dict["StepConsumption"] as! Double
        config.eatenPreyValue = dict["EatenPreyValue"] as! Double
        return config
    }
}

class CreaturesFillConfiguration: NSObject {
    var fillCoef: Double = 0.4
    var preyCoef: Double = 0.7

    func predatorCoef() -> Double {
        return 1 - preyCoef
    }
    
    class func parseFromDict(_ dict: Dictionary<String, Any>) -> CreaturesFillConfiguration {
        let config = CreaturesFillConfiguration()
        config.fillCoef = dict["FillCoef"] as! Double
        config.preyCoef = dict["PreyCoef"] as! Double
        return config
    }
}

class GameConfiguration: NSObject {
    var mapSize = MapSize()
    var creaturesFillConfig = CreaturesFillConfiguration()
    var bornConfig = BornConfiguration()
    var lifecycleConfig = CreaturesLifecycleConfiguration()
    
    class func parseFromDict(_ dict: Dictionary<String, Any>) -> GameConfiguration {
        let gameConfiguration = GameConfiguration()
        
        if let mapSizeDictObj = dict["MapSize"] {
            let mapSizeDict = mapSizeDictObj as! Dictionary<String, Int>
            gameConfiguration.mapSize = MapSize.parseFromDict(mapSizeDict)
        }
        else {
            gameConfiguration.mapSize = MapSize()
        }

        if let creaturesFillConfigDictObj = dict["CreaturesFillConfig"] {
            let creaturesFillConfigDict = creaturesFillConfigDictObj as! Dictionary<String, Any>
            gameConfiguration.creaturesFillConfig = CreaturesFillConfiguration.parseFromDict(creaturesFillConfigDict)
        }
        else {
            gameConfiguration.creaturesFillConfig = CreaturesFillConfiguration()
        }
        
        if let creaturesBornConfigDictObj = dict["BornConfig"] {
            let creaturesBornConfigDict = creaturesBornConfigDictObj as! Dictionary<String, Double>
            gameConfiguration.bornConfig = BornConfiguration.parseFromDict(creaturesBornConfigDict)
        }
        else {
            gameConfiguration.bornConfig = BornConfiguration()
        }

        if let lifecycleConfigDictObj = dict["LifecycleConfig"] {
            let lifecycleConfigDict = lifecycleConfigDictObj as! Dictionary<String, Double>
            gameConfiguration.lifecycleConfig = CreaturesLifecycleConfiguration.parseFromDict(lifecycleConfigDict)
        }
        else {
            gameConfiguration.lifecycleConfig = CreaturesLifecycleConfiguration()
        }

        return gameConfiguration
    }

    class func readInitialGameConfiguration() -> GameConfiguration {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        var plistData: [String: AnyObject] = [:]
        let plistPath: String? = Bundle.main.path(forResource: "InitialGameConfiguration", ofType: "plist")!
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        var gameConfiguration = GameConfiguration()
        do {
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]
            gameConfiguration = GameConfiguration.parseFromDict(plistData)
        } catch {
            LogManager.shared.error("Error reading plist: \(error), format: \(propertyListFormat)")
        }

        return gameConfiguration
    }

}
