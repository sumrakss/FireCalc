//
//  PickerView.swift
//  FireCalculator
//
//  Created by Алексей on 21.05.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation
import UIKit

extension MainScreenViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	
	// Настройка внешнего вида pickerView
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
		//		var a = data.pickerComponents[row]
		//		let formatter = NumberFormatter()
		//		formatter.locale = Locale.current
		//		if let number = formatter.number(from: a) {
		//			a = String(number.doubleValue)
		//		}
		return data.pickerComponents[row]
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
