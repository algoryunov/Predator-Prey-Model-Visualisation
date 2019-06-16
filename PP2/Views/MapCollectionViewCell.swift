//
//  MapCollectionViewCell.swift
//  PP2
//
//  Created by Alexey Goryunov on 23/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var debugLabel: UILabel!
    
    @IBOutlet weak var numberOfCreatures: UILabel!

    var mapCellViewModel = MapCellViewModel(withCreature: nil)

    func updateView() {
        self.imageView.image = mapCellViewModel.cellImage()
        let stringToShow = mapCellViewModel.numberOfCreatures > 1 ? "\(mapCellViewModel.numberOfCreatures)" : ""
        self.numberOfCreatures.text = stringToShow
        self.debugLabel.text = ""
    }
}
