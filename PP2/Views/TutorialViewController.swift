//
//  TutorialViewController.swift
//  PP2
//
//  Created by Alexey Goryunov on 6/16/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.startButton.layer.borderColor = UIColor.white.cgColor
        self.startButton.layer.borderWidth = 1.0
        self.startButton.layer.cornerRadius = 10.0
        self.startButton.layer.masksToBounds = true

    }

    @IBAction func linkTapped(_ sender: Any) {
        let baseUrl = "https://en.wikipedia.org/wiki/Lotka–Volterra_equations"
        let encodedUrl = baseUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: encodedUrl!) else { return }
        UIApplication.shared.open(url)
    }


    @IBAction func startTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
