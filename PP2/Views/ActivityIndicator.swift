//
//  ActivityIndicator.swift
//  PP2
//
//  Created by Alexey Goryunov on 5/29/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class ActivityIndicator: NSObject {

    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()

    var message = String()

    class func show(onView view: UIView, withMessage message: String) {
        let activityIndicator = ActivityIndicator(withMessage: message)
        activityIndicator.show(onView: view)
    }

    init(withMessage messageText: String) {
        message = messageText
    }

    func show(onView view: UIView) {
        strLabel = UILabel(frame: CGRect(x: 35, y: 0, width: 450, height: 96))
        strLabel.text = message
        strLabel.font = UIFont(name: "Munro", size: 17.0)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.9)
        strLabel.numberOfLines = 2
        strLabel.textAlignment = NSTextAlignment.center

        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 450, height: 96)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true

        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 10, y: 0, width: 35, height: 96)
        activityIndicator.startAnimating()

        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }

    func updateText(_ newText: String) {
        strLabel.text = newText
    }

    func hide() {
        activityIndicator.stopAnimating()
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
    }

}
