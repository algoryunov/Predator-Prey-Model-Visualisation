//
//  MapCellViewModel.swift
//  PP2
//
//  Created by Alexey Goryunov on 23/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class MapCellViewModel: NSObject {
    
    private var hasCreature : Bool = false
    private var isPrey: Bool = false
    var numberOfCreatures = 0
    var position = Position()

    init(withCreature creature: Creature?, numberOfCreaturesAtPosition number: Int = 0) {
        if let uCreature = creature {
            self.isPrey = uCreature.type == CreatureType.prey
            self.position = uCreature.position
            self.hasCreature = true
            self.numberOfCreatures = number
        }
        else {
            self.hasCreature = false
        }
    }

    func cellBackgroundColor() -> UIColor {
        if self.hasCreature {
            if self.isPrey {
                return UIColor(red: 101/255, green: 172/255, blue: 239/255, alpha: 1)
            }
            else {
                return UIColor(red: 254/255, green: 66/255, blue: 53/255, alpha: 1)
            }
        }
        return UIColor(red: 111/255, green: 185/255, blue: 112/255, alpha: 1)
    }

    func cellImage() -> UIImage? {
        var imageName = "Grass"
        if self.hasCreature {
            if isPrey {
                imageName = [ "Prey", "Prey2"].randomElement()!
            }
            else {
                imageName = "Predator"
            }
        }
        return UIImage(named: imageName)
    }

}
