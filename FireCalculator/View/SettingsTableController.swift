//
//  SettingsTableController.swift
//  FireCalculator
//
//  Created by Алексей on 20.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit


class SettingsTableController: UITableViewController {
	
	let defaults = UserDefaults.standard
	
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
	@IBOutlet weak var airSignalLabel: UILabel!
	
	@IBOutlet weak var airSignalTextField: UITextField!
	// Точность
	@IBOutlet weak var handModeSwitch: UISwitch!{
		didSet {
			if SettingsData.handInputMode {
				handModeSwitch.isOn = true
			} else {
				handModeSwitch.isOn = false
			}
		}
	}
	// Звуковой сигнал
	@IBOutlet weak var airSignalSwitch: UISwitch!{
		didSet {
			if SettingsData.airSignalMode {
				airSignalSwitch.isOn = true
			} else {
				airSignalSwitch.isOn = false
			}
		}
	}
	
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		// Скрываем клавиатуру при прокрутке
        tableView.keyboardDismissMode = .onDrag
      
		
		reducLabel.text = "Давление редуктора (кгс/см\u{00B2})"
		
        switch SettingsData.deviceType {
			// Воздух
			case .air:
                typeDetailLabel.text = "ДАСВ"
				
			// Кислород
			case .oxigen:
                typeDetailLabel.text = "ДАСК"
        }
        
		switch SettingsData.measureType {
			case .kgc:
                valueDetailLabel.text = "кгс/см\u{00B2}"
				reducLabel.text = "Давление редуктора (кгс/см\u{00B2})"
				airSignalLabel.text = "Срабатывание сигнала (кгс/см\u{00B2})"
			case .mpa:
                valueDetailLabel.text = "МПа"
				reducLabel.text = "Давление редуктора (МПа)"
				airSignalLabel.text = "Срабатывание сигнала (МПа)"
        }
		defaultDataText()
//		tableView.reloadData()
		tableView.beginUpdates()
		tableView.endUpdates()
    }
    
	// Сохнаняем настройки при выходе
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		defaults.set(SettingsData.deviceType.rawValue, forKey: "deviceType")
		defaults.set(SettingsData.measureType.rawValue, forKey: "measureType")
		defaults.set(SettingsData.cylinderVolume, forKey: "cylinderVolume")
		defaults.set(SettingsData.airRate, forKey: "airRate")
		defaults.set(SettingsData.airIndex, forKey: "airIndex")
		defaults.set(SettingsData.reductionStability, forKey: "reductionStability")
		defaults.set(SettingsData.handInputMode, forKey: "handInputMode")
		defaults.set(SettingsData.airSignal, forKey: "airSignal")
		defaults.set(SettingsData.airSignalMode, forKey: "airSignalMode")
		defaults.synchronize()
		print("Settings save")
	}
	

	
	func defaultDataText() {
		cylinderVolumeTextField.text = String(SettingsData.cylinderVolume)
		airRateTextField.text = String(Int(SettingsData.airRate))
		airIndexTextField.text = String(SettingsData.airIndex)
		// Давление устойчивой работы редуктора
		reductionStabilityTextField.text = SettingsData.measureType == .kgc ? String(Int(SettingsData.reductionStability)) : String(SettingsData.reductionStability)
		airSignalTextField.text = SettingsData.measureType == .kgc ? String(Int(SettingsData.airSignal)) : String(SettingsData.airSignal)
	}
	
	
    // Настройка объема баллона
    @IBAction func cylinderVolumeData(_ sender: Any) {
        SettingsData.cylinderVolume = (cylinderVolumeTextField.text?.dotGuard())!
		atencionMessage(value: SettingsData.cylinderVolume)
    }
    
    // Настройка средний расход воздуха
    @IBAction func airRateData(_ sender: Any) {
        SettingsData.airRate = (airRateTextField.text?.dotGuard())!
		atencionMessage(value: SettingsData.airRate)
    }
    
    // Настройка коэффициента сжатия
    @IBAction func airIndexTextData(_ sender: Any) {
        SettingsData.airIndex = (airIndexTextField.text?.dotGuard())!
		atencionMessage(value: SettingsData.airIndex)
    }
    
    // Настройка давления устойчивой работы редуктора
    @IBAction func reductionStabilityData(_ sender: Any) {
        SettingsData.reductionStability = (reductionStabilityTextField.text?.dotGuard())!
		atencionMessage(value: SettingsData.reductionStability)
    }
	
	// Настройка давления срабатывания звукового сигнала
	@IBAction func airSignalData(_ sender: UITextField) {
		SettingsData.airSignal = (airSignalTextField.text?.dotGuard())!
		atencionMessage(value: SettingsData.airSignal)
	}
	
				
	
	@IBAction func resetUserSettings(_ sender: UIButton) {
		let dictionary = defaults.dictionaryRepresentation()
		
		dictionary.keys.forEach { key in
			defaults.removeObject(forKey: key)
		}
		
		defaults.synchronize()
		
		SettingsData.deviceType = DeviceType.air
		SettingsData.measureType = MeasureType.kgc
		SettingsData.cylinderVolume = 6.8
		SettingsData.airIndex = 1.1
		SettingsData.airRate = 40.0
		SettingsData.reductionStability = 10.0
		SettingsData.airSignal = 63
		SettingsData.handInputMode = false
		SettingsData.airSignalMode = true
		SettingsData.airSignal = 63
		typeDetailLabel.text = "ДАСВ"
		valueDetailLabel.text = "кгс/см\u{00B2}"
		handModeSwitch.isOn = false
		airSignalSwitch.isOn = false
		
		defaultDataText()
		tableView.reloadData()
//		tableView.beginUpdates()
//		tableView.endUpdates()

		saveUserSettingsMessage()
	}
	
	// Ручной режим ввода давления Точность
	@IBAction func handMode(_ sender: UISwitch) {
		SettingsData.handInputMode = !SettingsData.handInputMode
		print("Ручной режим \(SettingsData.handInputMode)")
	}
	
	
	@IBAction func airSignalMode(_ sender: UISwitch) {
		SettingsData.airSignalMode = !SettingsData.airSignalMode
		print("Учитывать сигнал \(SettingsData.airSignalMode)")
	}
	
	
	// Отобразить поля настроек только для ДАСВ
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 1, indexPath.row == 1 {
			return (SettingsData.deviceType == .air ? tableView.rowHeight : 0)
		}

		if indexPath.section == 1, indexPath.row == 2 {
				return (SettingsData.deviceType == .air ? tableView.rowHeight : 0)
		}
		   return tableView.rowHeight
	}
	
	
	func saveUserSettingsMessage() {
		let alert = UIAlertController(title: "Настройки по-умолчанию", message: "", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
		return
		
	}
	
	
	
	func atencionMessage(value: Double) {
		guard value != 0
		else {
			let alert = UIAlertController(title: "Пустое поле!", message: "Значение будет равно 0", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
			return
		}
	}
}

