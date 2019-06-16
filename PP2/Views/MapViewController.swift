//
//  MapViewController.swift
//  PP2
//
//  Created by Alexey Goryunov on 20/05/2019.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class MapViewController : UICollectionViewController {

    // MARK: Variables

    var viewModel = MapViewModel()
    
    // MARK: Initializers
    
    class func mapViewController(withViewModel viewModel: MapViewModel) -> MapViewController {
        let controller = MapViewController(nibName: "MapViewController", bundle: nil)
        controller.viewModel = viewModel
        return controller
    }

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MapCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "MapCollectionViewCell")
    }

    // MARK: CollectionView delegate/dataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let totalNumber = self.viewModel.totalCreaturesNumber()
        return totalNumber
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MapCollectionViewCell", for: indexPath) as! MapCollectionViewCell
        cell.mapCellViewModel = self.viewModel.cellViewModel(forIndexPath: indexPath)
        cell.updateView()
        return cell
    }
    
    // MARK: Public
    
    func reloadMap() {
        self.collectionView.reloadData()
    }

    
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 34.0, height: 34.0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
