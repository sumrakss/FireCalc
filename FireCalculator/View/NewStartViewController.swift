//
//  NewStartViewController.swift
//  FireCalculator
//
//  Created by Алексей on 18.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class NewStartViewController: UITableViewController {

    @IBOutlet weak var firePlaceLabel: UILabel!
    @IBOutlet weak var hardWorkLabel: UILabel!
    @IBOutlet weak var enterTimePicker: UIDatePicker!
    @IBOutlet weak var fireTimePicker: UIDatePicker!
    @IBOutlet weak var fireTimeLabel: UILabel!
    @IBOutlet weak var enterTimeDetail: UILabel!
    @IBOutlet weak var fireTimeDetail: UILabel!
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
    var tappedCell1: Bool = false
    var tappedCell2: Bool = false
    var data = AppData()
    var counter = 0
	//
	var flag = true
	var teamCounter = 3
	

	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		stockValues()
		pickerViewSettings()
        tableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
		// Скрываем клавиатуру при прокрутке
        tableView.keyboardDismissMode = .onDrag
        fireStackLabel.isHidden = true
        fireTimeCell.selectionStyle = .none
        fireTimeLabel.isEnabled = false
        fireTimeDetail.isEnabled = false
        
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
    

	// Метод изменяет значения в полях ввода при изменении единиц измерения
	func stockValues() {
		if !SettingsData.valueUnit && flag {
			for i in 0 ..< data.enterData.count {
				data.enterData[i] /= 10.0
				data.hearthData[i] /= 10.0
				data.fallPressure[i] /= 10.0
				enterValueFields[i].text = String(data.enterData[i])
				firePlaceFields[i].text = String(data.hearthData[i])
			}
			flag = false
		}
		if SettingsData.valueUnit && !flag {
			for i in 0 ..< data.enterData.count {
				data.enterData[i] *= 10.0
				data.hearthData[i] *= 10.0
				data.fallPressure[i] *= 10.0
				enterValueFields[i].text = String(Int(data.enterData[i]))
				firePlaceFields[i].text = String(Int(data.hearthData[i]))
			}
			flag = true
		}
	}
    
    
    // Отрисовываем поля ввода в зависимости от состава звена
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
					print(enterValue)
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
        print(counter)
        }
    
	
	 // Настройка pickerView
	func pickerViewSettings() {
		// Очищаем содержимое для PickerView
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
		
		// В текстовых полях выводим pickerView вместо клавиатуры
		for textField in textFieldForInput {
			textField.inputView = pickerView
			textField.inputAccessoryView = toolBar
		}
	}
	
	@objc func dismissKeyboard () {
		view.endEditing(true)
	}
	
	
    // Swicher Очаг
    @IBAction func firePlaceChange(_ sender: Any) {
		
        data.firePlace = !data.firePlace
        fireStackLabel.isHidden = !fireStackLabel.isHidden
        fireTimeLabel.isEnabled = !fireTimeLabel.isEnabled
        // Делаем ячейку неактивной в случае если очаг не найден
        fireTimeDetail.isEnabled = !fireTimeDetail.isEnabled
        data.firePlace ? (fireTimeCell.selectionStyle = .default) : (fireTimeCell.selectionStyle = .none)
        // Скрываем TimePicker если очаг не найден
        if tappedCell2 {  tappedCell2 = false }
        
        for item in firePlaceFields {
            item.isHidden = !item.isHidden
        }
        tableView.reloadData()
    }
    
    
    // Swicher Сложные условия
    @IBAction func hardWorkChange(_ sender: UISwitch) {
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
	
	
	// BarButton Рассчитать
    @IBAction func etst(_ sender: UIBarButtonItem) {
        inputFieldsView(fieldCount: teamCounter)
    }

	
    
    
    
    // MARK: Скрываем и отображам DatePicker по тапу на ячейке
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            tappedCell1 = !tappedCell1
            tableView.reloadRows(at: [indexPath], with: .none)
//            tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
        }
        
        
        if indexPath.row == 4 && data.firePlace {
			tappedCell2 = !tappedCell2
            tableView.reloadRows(at: [indexPath], with: .none)
        }
//        tableView.beginUpdates()
//        tableView.endUpdates()
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return (tappedCell1 ? tableView.rowHeight : 0)
        }

        if indexPath.row == 5 {
            return (tappedCell2  && data.firePlace ? tableView.rowHeight : 0)
        }
       
        return tableView.rowHeight
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerText = ""
        if section == 0 {
            headerText = "Условия работы"
        }
        
        if section == 1 {
            
            headerText = SettingsData.valueUnit ? "ДАВЛЕНИЕ В ЗВЕНЕ (кгс/см\u{00B2})" : "ДАВЛЕНИЕ В ЗВЕНЕ (МПа)"
        }
        
        return headerText
    }
    
    // Передача данных по segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewSegue" {
            guard let vc = segue.destination as? PDFPreviewViewController else { return }
            let pdfCreator = PDFCreator()
			vc.appData = data
			
            if data.firePlace { // Если очаг найден
                vc.documentData = pdfCreator.foundPDFCreator(appData: data)
			} else {
                vc.documentData = pdfCreator.notFoundPDFCreator(appData: data)
            }
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



extension NewStartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // Количество колонок в PickerView
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
//		if data.firePlace { return 2 }
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


/*
extension NewStartViewController: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
		self.textView.text = self.data.pickerComponents[row]
        self.textField.resignFirstResponder()
    }

    func didTapCancel() {
        self.textField.text = nil
        self.textField.resignFirstResponder()
    }
}
*/


/*
extension String {
    static let numberFormatter = NumberFormatter()
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
}
*/
