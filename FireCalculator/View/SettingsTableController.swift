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
	@IBOutlet weak var airSignalLabel: UILabel!
	@IBOutlet weak var airSignalTextField: UITextField!
	// Точность
	@IBOutlet weak var handModeSwitch: UISwitch!
	// Звуковой сигнал
	@IBOutlet weak var airSignalSwitch: UISwitch!
	// Показать только ответы
	@IBOutlet weak var simpleSolutionSwitch: UISwitch!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Скрываем клавиатуру
		tableView.keyboardDismissMode =  .onDrag
		navigationItem.title = "Настройки"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(false)
      
		airSignalSwitch.isOn = SettingsData.airSignalMode ? true : false
		handModeSwitch.isOn = SettingsData.handInputMode ? true : false
		simpleSolutionSwitch.isOn = !SettingsData.simpleSolution ? true : false
		
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
		tableView.reloadData()
    }
    
	// Сохнаняем настройки при выходе
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		SettingsData.settings.saveSettings()
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
    @IBAction func cylinderVolumeData(_ sender: UITextField) {
		let field = sender
		print(field)
        SettingsData.cylinderVolume = (sender.text?.dotGuard())!
		atencionMessage(value: SettingsData.cylinderVolume)
    }
    
	
    // Настройка средний расход воздуха
    @IBAction func airRateData(_ sender: UITextField) {
        SettingsData.airRate = (sender.text?.dotGuard())!
		atencionMessage(value: SettingsData.airRate)
    }
    
	
    // Настройка коэффициента сжатия
    @IBAction func airIndexTextData(_ sender: UITextField) {
        SettingsData.airIndex = (sender.text?.dotGuard())!
		atencionMessage(value: SettingsData.airIndex)
    }
    
	
    // Настройка давления устойчивой работы редуктора
    @IBAction func reductionStabilityData(_ sender: UITextField) {
        SettingsData.reductionStability = (sender.text?.dotGuard())!
		atencionMessage(value: SettingsData.reductionStability)
    }
	
	
	// Настройка давления срабатывания звукового сигнала
	@IBAction func airSignalData(_ sender: UITextField) {
		SettingsData.airSignal = (sender.text?.dotGuard())!
		atencionMessage(value: SettingsData.airSignal)
	}
	
	
	@IBAction func resetUserSettings(_ sender: UIButton) {
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
	
	
	@IBAction func solutionSwitcher(_ sender: UISwitch) {
		SettingsData.simpleSolution = !SettingsData.simpleSolution
		print(SettingsData.simpleSolution)
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
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 0
		}
		return 40
	}
	
	
	func resetSettings() {
		SettingsData.settings.resetUserSettings()
		typeDetailLabel.text = "ДАСВ"
		valueDetailLabel.text = "кгс/см\u{00B2}"
		handModeSwitch.isOn = false
		airSignalSwitch.isOn = false
		simpleSolutionSwitch.isOn = true
		reducLabel.text = "Давление редуктора кгс/см\u{00B2}"
		airSignalLabel.text = "Срабатывание сигнала кгс/см\u{00B2}"
		defaultDataText()
		tableView.reloadData()
	}
	
	
	func saveUserSettingsMessage() {
		let alert = UIAlertController(title: "Сбросить настройки?", message: "", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action
			in self.resetSettings()
		}))
		alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
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

