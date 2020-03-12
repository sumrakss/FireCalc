//
//  SettingsTableController.swift
//  FireCalculator
//
//  Created by Алексей on 20.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit


class SettingsTableController: UITableViewController {
         
    @IBOutlet weak var cylinderVolumeTextField: UITextField!
    @IBOutlet weak var airRateTextField: UITextField!
    @IBOutlet weak var airIndexTextField: UITextField!
    @IBOutlet weak var reductionStabilityTextField: UITextField!
    
    var settingsData = SettingsData()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Настройка объема баллона
    @IBAction func cylinderVolumeData(_ sender: Any) {
        SettingsData.cylinderVolume = Double(cylinderVolumeTextField.text!)!
    }
    
    // Настройка объема баллона
    @IBAction func airRateData(_ sender: Any) {
        SettingsData.airRate = Double(airRateTextField.text!)!
    }
    
    // Настройка объема баллона
    @IBAction func airIndexTextData(_ sender: Any) {
        SettingsData.airIndex = Double(airIndexTextField.text!)!
    }
    
    // Настройка объема баллона
    @IBAction func reductionStabilityData(_ sender: Any) {
        SettingsData.reductionStability = Double(reductionStabilityTextField.text!)!
    }
    
    
    // Скрываем клавиатуру при касании за ее пределами
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
	

}
