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
	
	// view
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
	@IBOutlet weak var teamStepper: UIStepper! {
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
		
		SettingsData.settings.loadSettings()
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
		}
		
		inputFieldsView(fieldCount: teamCounter)
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
		}
		counter += 1
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
	
	
	@IBAction func solutionButton(_ sender: UIBarButtonItem) {
		if SettingsData.simpleSolution {
			performSegue(withIdentifier: "toSimple", sender: self)
		} else {
			performSegue(withIdentifier: "previewSegue", sender: self)
		}
	}
	
	
	// MARK: Скрываем и отображам DatePicker по тапу на ячейке
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tappedIndexPath = indexPath
		if tapList.contains(tappedIndexPath) {
			tapList.remove(tappedIndexPath)
		} else {
			tapList.insert(tappedIndexPath)
		}
		
		tableView.reloadRows(at: [indexPath], with: .none)
		// ячейка "время у очага" не кликается без этого кода
		let select = tableView.cellForRow(at: indexPath)
		select?.selectionStyle = .gray
	}
	
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 3 {
			return tapList.contains([0, 2]) ? tableView.rowHeight : 0
		}
		
		// Отображаем поле "Время у очага" только при необходимости
		if indexPath.row == 4 {
			
			let select = tableView.cellForRow(at: indexPath)
			select?.selectionStyle = .gray
			return (data.firePlace ? tableView.rowHeight : 0)
		}
		
		if indexPath.row == 5 {
			return tapList.contains([0, 4]) && data.firePlace ? tableView.rowHeight : 0
		}
		
		return tableView.rowHeight
	}
	
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var headerText = ""
		
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





