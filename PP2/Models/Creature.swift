//
//  Creature.swift
//  PP2
//
//  Created by Alexey Goryunov on 23/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import Foundation

enum CreatureType {
    case prey
    case predator
}

class Creature: NSObject {
    var id: Int = 0
    var hungerCoef : Double = 5.0
    var position   = Position()
    var type       : CreatureType = CreatureType.prey
    
    func duplicate() -> Creature {
        let creature = Creature()
        creature.id = self.id
        creature.hungerCoef = self.hungerCoef
        creature.position = self.position.duplicate()
        creature.type = self.type
        return creature
    }
}
