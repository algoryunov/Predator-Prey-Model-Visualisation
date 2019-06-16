//
//  Position.swift
//  PP2
//
//  Created by Alexey Goryunov on 23/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class Position: NSObject {
    var x : Int = 0
    var y : Int = 0

    func isEqualToPosition(_ position: Position) -> Bool {
        if (x != position.x ||
            y != position.y) {
            return false
        }
        return true
    }

    public static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func directionTo(_ position: Position) -> Direction? {
        if (abs(self.x - position.x) > 1 ||
            abs(self.y - position.y) > 1) {
            // nil if not on border with orig position
            return nil
        }

        if self.x == position.x + 1 {
            if self.y == position.y + 1 {
                return .upLeft
            }
            else if self.y == position.y {
                return .left
            }
            else if self.y == position.y - 1 {
                return .downLeft
            }
        }
        else if self.x == position.x {
            if self.y == position.y + 1 {
                return .up
            }
            else if self.y == position.y {
                return .center
            }
            else if self.y == position.y - 1 {
                return .down
            }
        }
        else if self.x == position.x - 1 {
            if self.y == position.y + 1 {
                return .upRight
            }
            else if self.y == position.y {
                return .right
            }
            else if self.y == position.y - 1 {
                return .downRight
            }
        }

        return nil
    }
    
    func duplicate() -> Position {
        let position = Position()
        position.x = self.x
        position.y = self.y
        return position
    }

}
