//
//  NewStartViewController.swift
//  FireCalculator
//
//  Created by Алексей on 18.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit
import Foundation

class MainScreenViewController: UITableViewController {

    @IBOutlet weak var firePlaceLabel: UILabel!
    @IBOutlet weak var hardWorkLabel: UILabel!
    @IBOutlet weak var enterTimePicker: UIDatePicker!
    @IBOutlet weak var fireTimePicker: UIDatePicker!
	@IBOutlet weak var fireTimeDetail: UILabel!
    @IBOutlet weak var enterTimeDetail: UILabel!
    @IBOutlet weak var fireTimeCell: UITableViewCell!
    @IBOutlet weak var firePlaceSwitch: UISwitch!
    @IBOutlet weak var hardWorkSwitch: UISwitch!
    @IBOutlet weak var fireStackLabel: UILabel!
    @IBOutlet var teamCountStack: [UIStackView]!    // Все текстовые поля построчно
    @IBOutlet var enterValueFields: [UITextField]!  // Текстовые поля "При включении"
    @IBOutlet var firePlaceFields: [UITextField]!   // Текстовые поля "У очага"
    @IBOutlet var textFieldForInput: [UITextField]! // Текстовые поля для ввода
	@IBOutlet weak var teamStepper: UIStepper!{
		didSet {
			teamStepper.value = 3
			teamStepper.minimumValue = 2
			teamStepper.maximumValue = 5
		}
	}
	
	
    let time = DateFormatter()
	var tapList = Set<IndexPath?>()
	var tappedIndexPath: IndexPath?
	var data = SettingsData()
	let defaults = UserDefaults.standard
	
    var counter = 0
	var flag = true
	// Численность звена
	var teamCounter = 3
	

	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		stockValues()
		pickerViewSettings()
        tableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "Условия работы"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		loadUserSettings()
		// Скрываем клавиатуру
		tableView.keyboardDismissMode = .onDrag
		
		firePlaceLabel.text = "Очаг - поиск"
		hardWorkLabel.text = "Условия - нормальные"
		// Скрываем клавиатуру при прокрутке
        fireStackLabel.isHidden = true
        fireTimeCell.selectionStyle = .none
        
        time.dateFormat = "HH:mm"
        enterTimeDetail.text = time.string(from: data.enterTime)
        fireTimeDetail.text = time.string(from: data.fireTime)
        
		// Скрываем поля ввода "У очага" при первом запуске
        for item in firePlaceFields {
            item.isHidden = true
//            item.borderStyle = .line
        }
        
        inputFieldsView(fieldCount: teamCounter)
    }

	
	// Загрузка сохраненных настроек пользователя
	func loadUserSettings() {
	
		if let deviceType = DeviceType(rawValue: defaults.string(forKey: "deviceType") ?? "") {
			SettingsData.deviceType = deviceType
		}
		if let measureType = MeasureType(rawValue: defaults.string(forKey: "measureType") ?? "") {
			SettingsData.measureType = measureType
		}

		if UserDefaults.standard.object(forKey: "cylinderVolume") != nil {
			SettingsData.cylinderVolume = defaults.double(forKey: "cylinderVolume")
		}

		if UserDefaults.standard.object(forKey: "airRate") != nil {
			SettingsData.airRate = defaults.double(forKey: "airRate")
		}

		if UserDefaults.standard.object(forKey: "airIndex") != nil {
			SettingsData.airIndex = defaults.double(forKey: "airIndex")
		}
	
		if UserDefaults.standard.object(forKey: "reductionStability") != nil {
			SettingsData.reductionStability = defaults.double(forKey: "reductionStability")
		}
		
		if UserDefaults.standard.object(forKey: "handInputMode") != nil {
			SettingsData.handInputMode = defaults.bool(forKey: "handInputMode")
		}

		if UserDefaults.standard.object(forKey: "airSignal") != nil {
			SettingsData.airSignal = defaults.double(forKey: "airSignal")
		}

		if UserDefaults.standard.object(forKey: "airSignalMode") != nil {
			SettingsData.airSignalMode = defaults.bool(forKey: "airSignalMode")
		}
		
		if UserDefaults.standard.object(forKey: "simpleSolution") != nil {
			SettingsData.simpleSolution = defaults.bool(forKey: "simpleSolution")
		}
		defaults.synchronize()
	}
	
	
	// Метод изменяет значения в полях ввода при изменении единиц измерения
	func stockValues() {
		if SettingsData.measureType == .mpa && flag {
			// Изменить значения видимых полей ввода
			for i in 0 ..< data.enterData.count {
				data.enterData[i] /= 10.0
				data.hearthData[i] /= 10.0
				data.fallPressure[i] /= 10.0
				firePlaceFields[i].text = String(data.hearthData[i])
				enterValueFields[i].text = String(data.enterData[i])
			}
			// Изменить значения скрытых полей ввода
			for i in data.enterData.count ..< enterValueFields.count {
				enterValueFields[i].text = String((enterValueFields[i].text?.dotGuard())! / 10.0)
				firePlaceFields[i].text = String((firePlaceFields[i].text?.dotGuard())! / 10.0)
			}
			
			flag = false
		}
		
		if SettingsData.measureType == .kgc && !flag {
			for i in 0 ..< data.enterData.count {
				data.enterData[i] *= 10.0
				data.hearthData[i] *= 10.0
				data.fallPressure[i] *= 10.0
				enterValueFields[i].text = String(Int(data.enterData[i]))
				firePlaceFields[i].text = String(Int(data.hearthData[i]))
			}
			
			for i in data.enterData.count ..< enterValueFields.count {
				enterValueFields[i].text = String(Int((enterValueFields[i].text?.dotGuard())! * 10.0))
				firePlaceFields[i].text = String(Int((firePlaceFields[i].text?.dotGuard())! * 10.0))
			}
			
			flag = true
		}
	}
    
    
    // Отрисовываем поля ввода в зависимости от численности звена
    func inputFieldsView(fieldCount: Int) {
            data.enterData.removeAll()
            data.hearthData.removeAll()
            data.fallPressure.removeAll()
            
            for item in teamCountStack {
                item.isHidden  = true
            }
            
            for i in 0..<fieldCount {
                if let enterValue = enterValueFields[i].text?.dotGuard() {
					data.enterData.append(enterValue)
                }
                
                if let hearthValue = firePlaceFields[i].text?.dotGuard() {
					data.hearthData.append(hearthValue)
                }
            
                data.fallPressure.append(data.enterData[i] - data.hearthData[i])
                teamCountStack[i].isHidden = false
                enterValueFields[i].isHidden = false
//                enterValueFields[i].borderStyle = .line
            }
        counter += 1
	}
    
	
	 // Настройка pickerView
	func pickerViewSettings() {
		// Очищаем содержимое  PickerView
		data.pickerComponents.removeAll()
		// Генерируем содержимое для PickerView
		data.generatePickerData()
		
		let pickerView = UIPickerView()
//		pickerView.backgroundColor = .white
		pickerView.delegate = self
		pickerView.dataSource = self

		let toolBar = UIToolbar()
		toolBar.barStyle = UIBarStyle.default
		toolBar.isTranslucent = true
//		toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
		toolBar.sizeToFit()

		let doneButton = UIBarButtonItem(title: "Готово",
										 style: UIBarButtonItem.Style.plain,
										 target: self,
										 action: #selector(dismissKeyboard))
		
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: nil)

		toolBar.setItems([spaceButton, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		
		if !SettingsData.handInputMode {
			// В текстовых полях выводим pickerView вместо клавиатуры
			for textField in textFieldForInput {
				textField.inputView = pickerView
				textField.inputAccessoryView = toolBar
			}
		} else {
			
			for textField in textFieldForInput {
				textField.inputView = nil
				textField.reloadInputViews()
				textField.inputAccessoryView = toolBar
			}
		}
	}
	
	
	@objc func dismissKeyboard () {
		view.endEditing(true)
	}
	
	
	
	
	
	// Swicher Очаг
    @IBAction func firePlaceChange(_ sender: Any) {
        data.firePlace = !data.firePlace
        fireStackLabel.isHidden = !fireStackLabel.isHidden
        
        for item in firePlaceFields {
            item.isHidden = !item.isHidden
        }
		
		firePlaceLabel.text = data.firePlace ? "Очаг - обнаружен" : "Очаг - поиск"
		
		// Скрываем DatePicker "У очага" если firePlaceSwitch переключался
		tapList.remove([0, 4])
		
		tableView.beginUpdates()
		tableView.endUpdates()
    }
    
    
    // Swicher Сложные условия
    @IBAction func hardWorkChange(_ sender: UISwitch) {
		hardWorkLabel.text = data.hardWork ? "Условия - нормальные" : "Условия - сложные"
        data.hardWork = !data.hardWork
    }
    
    
    // DatePicker Устанавливаем время включения
    @IBAction func enterTimeChange(_ sender: UIDatePicker) {
        data.enterTime = enterTimePicker!.date
        time.dateFormat = "HH:mm"
        enterTimeDetail.text = time.string(from: data.enterTime)
    }
    
	
    // DatePicker Устанавливаем время у очага
    @IBAction func fireTimeChange(_ sender: UIDatePicker) {
        data.fireTime = fireTimePicker!.date
        time.dateFormat = "HH:mm"
        fireTimeDetail.text = time.string(from: data.fireTime)
    }
    

    // Меняем численность состава звена ГДЗС
	@IBAction func teamChanger(_ sender: UIStepper) {
		teamCounter = Int(sender.value)
		inputFieldsView(fieldCount: teamCounter)
		tableView.reloadData()
	}

	
	
// MARK: fesf
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//		cell.backgroundColor = UIColor(white: 8, alpha: 0.5)
	}
    
	
    // MARK: Скрываем и отображам DatePicker по тапу на ячейке
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tappedIndexPath = indexPath
		if tapList.contains(tappedIndexPath) {
			tapList.remove(tappedIndexPath)
		} else {
			tapList.insert(tappedIndexPath)
		}
//		tapList.contains(tappedIndexPath) ? tapList.remove(tappedIndexPath) : tapList.insert(tappedIndexPath)
		tableView.reloadRows(at: [indexPath], with: .none)
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 3 {
			return tapList.contains([0, 2]) ? tableView.rowHeight : 0
        }
		
		// Отображаем поле "Время у очага" только при необходимости
		if indexPath.row == 4 {
			return (data.firePlace ? tableView.rowHeight : 0)
        }
		
        if indexPath.row == 5 {
			return tapList.contains([0, 4]) && data.firePlace ? tableView.rowHeight : 0
        }
		
        return tableView.rowHeight
    }
    
    
//	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//		if section == 0 {
//			return 40
//		}
//		return 40
//	}
	
	
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerText = ""
//        if section == 0 {
//            headerText = "Условия работы"
//        }
        
        if section == 1 {
			switch SettingsData.measureType {
				case .kgc:
					headerText = "ДАВЛЕНИЕ В ЗВЕНЕ (кгс/см\u{00B2})"
				case .mpa:
					headerText = "ДАВЛЕНИЕ В ЗВЕНЕ (МПа)"
			}
        }
        return headerText
    }
    
	
	@IBAction func solutionButton(_ sender: UIBarButtonItem) {
		if SettingsData.simpleSolution {
			performSegue(withIdentifier: "toSimple", sender: self)
		} else {
			performSegue(withIdentifier: "previewSegue", sender: self)
		}
	}
	
	
    // Передача данных по segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewSegue" {
            guard let vc = segue.destination as? PDFPreviewViewController else { return }
            let pdfCreator = PDFCreator()
			vc.appData = data
			// Проверяем содержимое на корретность ввода
			// для этого обновляем массивы значений
			inputFieldsView(fieldCount: teamCounter)
			atencionMessage()
			
			if data.firePlace { // Если очаг найден
				vc.documentData = pdfCreator.foundPDFCreator(appData: data)
			} else {
				vc.documentData = pdfCreator.notFoundPDFCreator(appData: data)
			}
        }
		
		if segue.identifier == "toSimple" {
			guard let vc = segue.destination as? SimpleTableViewController else { return }
			vc.appData = data
			
		}
    }
	
	
	
	// Проверка корректности ввода
	func atencionMessage() {
		var firewall: Double
		firewall = SettingsData.measureType == .kgc ? 350 : 35
		
		if (data.enterData.min()! < 1 || data.enterData.max()! > firewall) ||
			(data.hearthData.min()! < 1 || data.hearthData.max()! > firewall) {
			let alert = UIAlertController(title: "Некорректное значение", message: "Введите значение в пределах \n1 - \(firewall)", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
			return
		}
	}
}


//  расширение для автоматического перевода запятой в точку
extension String {
    static let numberFormatter = NumberFormatter()
    func dotGuard() -> Double {
        var doubleValue: Double {
            String.numberFormatter.decimalSeparator = "."
            if let result =  String.numberFormatter.number(from: self) {
                return result.doubleValue
            } else {
                String.numberFormatter.decimalSeparator = ","
                if let result = String.numberFormatter.number(from: self) {
                    return result.doubleValue
                }
            }
            return 0
        }
        return doubleValue
    }
}


extension MainScreenViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // Количество колонок в PickerView
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	
	// Количество строк в PickerView
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.data.pickerComponents.count
	}
	
	
	// Логика для выбранного элемента
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
        for textField in textFieldForInput {
			if textField.isEditing {
				textField.text = self.data.pickerComponents[row]
            }
        }
        inputFieldsView(fieldCount: teamCounter)
	}
	
	// Отображаем в picker значения из списка
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		return self.data.pickerComponents[row]
	}
}

