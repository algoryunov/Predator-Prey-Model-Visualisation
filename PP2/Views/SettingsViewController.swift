//
//  SettingsViewController.swift
//  PP2
//
//  Created by Alexey Goryunov on 6/1/19.
//  Copyright © 2019 Alexey Goryunov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    var viewModel = SettingsViewModel(withConfiguration: GameConfiguration())

    @IBOutlet weak var mapSizeWidthTextField: UITextField!
    @IBOutlet weak var mapSizeHeightTextField: UITextField!
    @IBOutlet weak var fillConfigCreaturesCoefTextField: UITextField!
    @IBOutlet weak var fillConfigPreysCoefTextField: UITextField!
    @IBOutlet weak var fillConfigPredatorsCoefTextField: UITextField!
    @IBOutlet weak var bornConfigPreyCoefTextField: UITextField!
    @IBOutlet weak var bornConfigPredatorCoefTextField: UITextField!
    @IBOutlet weak var bornConfigMaxCreaturesAtPos: CoefTextField!
    @IBOutlet weak var lifecycleInitialHungerCoefTextField: UITextField!
    @IBOutlet weak var lifecycleHungerStepConsTextField: UITextField!
    @IBOutlet weak var lifecycleEatenPreyValueTextField: UITextField!

    class func settingsViewController(withViewModel viewModel: SettingsViewModel) -> SettingsViewController {
        let controller = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        controller.viewModel = viewModel
        return controller
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateValues()
    }

    // MARK: Public

    func updateValues() {
        let configuration = self.viewModel.configuration
        mapSizeWidthTextField.text = "\(configuration.mapSize.width)"
        mapSizeHeightTextField.text = "\(configuration.mapSize.height)"

        fillConfigCreaturesCoefTextField.text = "\(configuration.creaturesFillConfig.fillCoef)"
        fillConfigPreysCoefTextField.text = "\(configuration.creaturesFillConfig.preyCoef)"
        fillConfigPredatorsCoefTextField.text = "\(configuration.creaturesFillConfig.predatorCoef())"

        bornConfigPreyCoefTextField.text = "\(configuration.bornConfig.preyCoef)"
        bornConfigPredatorCoefTextField.text = "\(configuration.bornConfig.predatorCoef)"
        bornConfigMaxCreaturesAtPos.text = "\(configuration.bornConfig.creaturesOnPositionThreshold)"

        lifecycleInitialHungerCoefTextField.text = "\(configuration.lifecycleConfig.initialHungerCoef)"
        lifecycleHungerStepConsTextField.text = "\(configuration.lifecycleConfig.stepHungerConsumption)"
        lifecycleEatenPreyValueTextField.text = "\(configuration.lifecycleConfig.eatenPreyValue)"
    }

    func captureConfiguration() -> GameConfiguration {
        let config = GameConfiguration()
        let mapSize = MapSize()
        mapSize.width = Int(mapSizeWidthTextField.text!) ?? 0
        mapSize.height = Int(mapSizeHeightTextField.text!) ?? 0
        config.mapSize = mapSize

        let fillConfig = CreaturesFillConfiguration()
        fillConfig.fillCoef = Double(fillConfigCreaturesCoefTextField.text!) ?? 0.0
        fillConfig.preyCoef = Double(fillConfigPreysCoefTextField.text!) ?? 0.0
        config.creaturesFillConfig = fillConfig

        let bornConfig = BornConfiguration()
        bornConfig.preyCoef = Double(bornConfigPreyCoefTextField.text!) ?? 0.0
        bornConfig.predatorCoef = Double(bornConfigPredatorCoefTextField.text!) ?? 0.0
        bornConfig.creaturesOnPositionThreshold = Int(bornConfigMaxCreaturesAtPos.text!) ?? 0
        config.bornConfig = bornConfig

        let lifecycleConfig = CreaturesLifecycleConfiguration()
        lifecycleConfig.initialHungerCoef = Double(lifecycleInitialHungerCoefTextField.text!) ?? 0.0
        lifecycleConfig.stepHungerConsumption = Double(lifecycleHungerStepConsTextField.text!) ?? 0.0
        lifecycleConfig.eatenPreyValue = Double(lifecycleEatenPreyValueTextField.text!) ?? 0.0
        config.lifecycleConfig = lifecycleConfig

        return config
    }

    // MARK: UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fillConfigPreysCoefTextField {
            if let text = textField.text,
                let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,
                                                           with: string)
                let newValue = Double(updatedText) ?? 0.0
                fillConfigPredatorsCoefTextField.text! = "\(1.0 - newValue)"

            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == fillConfigPreysCoefTextField {
        }
    }

}
