//
//  SettingsViewModel.swift
//  PP2
//
//  Created by Alexey Goryunov on 6/1/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class SettingsViewModel: NSObject {

    var configuration: GameConfiguration

    init(withConfiguration config: GameConfiguration) {
        self.configuration = config
    }

}
