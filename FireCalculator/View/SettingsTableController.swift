//
//  SettingsTableController.swift
//  FireCalculator
//
//  Created by Алексей on 20.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit


class SettingsTableController: UITableViewController {
         
    @IBOutlet weak var typeDetailLabel: UILabel!
    @IBOutlet weak var valueDetailLabel: UILabel!
    @IBOutlet weak var cylinderVolumeTextField: UITextField!
    @IBOutlet weak var airRateTextField: UITextField!
    @IBOutlet weak var airIndexTextField: UITextField!
    @IBOutlet weak var airIndexCell: UITableViewCell!
    @IBOutlet weak var reductionStabilityTextField: UITextField!
    @IBOutlet weak var vCylinderLabel: UILabel!
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.keyboardDismissMode = .onDrag // Скрываем клавиатуру при прокрутке
        
        vCylinderLabel.text = "V\u{0431}"
        
        switch SettingsData.air {
            case true:
                typeDetailLabel.text = "ДАСВ"
            default:
                typeDetailLabel.text = "ДАСК"
        }
        
        switch SettingsData.valueUnit {
            case true:
                valueDetailLabel.text = "кгс/см\u{00B2}"
//                reductionStabilityTextField.text = String(SettingsData.reductionStability)
//				airRateTextField.text = String(Int(SettingsData.airRate))
            default:
                valueDetailLabel.text = "МПа"
        }
		reductionStabilityTextField.text = String(Int(SettingsData.reductionStability))
		airRateTextField.text = String(Int(SettingsData.airRate))
		tableView.reloadData()
    }
    
    // Настройка объема баллона
    @IBAction func cylinderVolumeData(_ sender: Any) {
        SettingsData.cylinderVolume = (cylinderVolumeTextField.text?.dotGuard())!
		print(SettingsData.cylinderVolume)
    }
    
    // Настройка объема баллона
    @IBAction func airRateData(_ sender: Any) {
        SettingsData.airRate = (airRateTextField.text?.dotGuard())!
		print(SettingsData.airRate)
    }
    
    // Настройка объема баллона
    @IBAction func airIndexTextData(_ sender: Any) {
        SettingsData.airIndex = (airIndexTextField.text?.dotGuard())!
		print(SettingsData.airIndex)
    }
    
    // Настройка объема баллона
    @IBAction func reductionStabilityData(_ sender: Any) {
        SettingsData.reductionStability = (reductionStabilityTextField.text?.dotGuard())!
		print(SettingsData.reductionStability)
    }
}

