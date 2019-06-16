//
//  CoefTextField.swift
//  PP2
//
//  Created by Alexey Goryunov on 6/16/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class CoefTextField: UITextField {

    override func draw(_ rect: CGRect) {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }

}
