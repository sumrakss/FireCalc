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
	@IBOutlet weak var airRateLabel: UILabel!
	@IBOutlet weak var airIndexLabel: UILabel!
	@IBOutlet weak var reducLabel: UILabel!
	
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.keyboardDismissMode = .onDrag // Скрываем клавиатуру при прокрутке
        
		reducLabel.text = "Давление редуктора (кгс/см\u{00B2})"
		
        switch SettingsData.air {
			// Воздух
            case true:
                typeDetailLabel.text = "ДАСВ"
				airRateTextField.isEnabled = true
				airIndexTextField.isEnabled = true
				airRateLabel.isEnabled = true
				airIndexLabel.isEnabled = true
				airRateTextField.textColor = .black
				airIndexTextField.textColor = .black
			// Кислород
            default:
                typeDetailLabel.text = "ДАСК"
				airRateTextField.isEnabled = false
				airIndexTextField.isEnabled = false
				airRateLabel.isEnabled = false
				airIndexLabel.isEnabled = false
				airRateTextField.textColor = .gray
				airIndexTextField.textColor = .gray
				
        }
        
        switch SettingsData.valueUnit {
            case true:
                valueDetailLabel.text = "кгс/см\u{00B2}"
				reducLabel.text = "Давление редуктора (кгс/см\u{00B2})"
            default:
                valueDetailLabel.text = "МПа"
				reducLabel.text = "Давление редуктора (МПа)"
        }
		
		// Объем баллона
		cylinderVolumeTextField.text = String(SettingsData.cylinderVolume)
		airRateTextField.text = String(Int(SettingsData.airRate))
		airIndexTextField.text = String(SettingsData.airIndex)
		// Давление устойчивой работы редуктора
		reductionStabilityTextField.text = SettingsData.valueUnit ? String(Int(SettingsData.reductionStability)) : String(SettingsData.reductionStability)
		
		
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

