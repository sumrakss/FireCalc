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
    
    @IBOutlet weak var vSlider: UISlider! {
        didSet {
            vSlider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            vSlider.minimumValue = 2
            vSlider.maximumValue = 5
            vSlider.value = 3
        }
    }
    
    private var pickerComponent = [String]()    // Содержимое pickerview
	
    let time = DateFormatter()
    var tappedCell1: Bool = false
    var tappedCell2: Bool = false
    var data = AppData()
    
    var counter = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generatePickerData()    // Генерируем список компонентов pickerView
        
        let pickerView = UIPickerView()
		pickerView.delegate = self
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Скрыть", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        
        print(SettingsData.airFlow)
        tableView.keyboardDismissMode = .onDrag // Скрываем клавиатуру при прокрутке
        fireStackLabel.isHidden = true
        fireTimeCell.selectionStyle = .none
        fireTimeLabel.isEnabled = false
        fireTimeDetail.isEnabled = false
        
        time.dateFormat = "HH:mm"
        enterTimeDetail.text = time.string(from: data.enterTime)
        fireTimeDetail.text = time.string(from: data.fireTime)
        
        for item in firePlaceFields {
            item.isHidden = true
//            item.borderStyle = .line
        }
        
        // В текстовых полях выводим pickerView вместо клавиатуры
        for textField in textFieldForInput {
            textField.inputView = pickerView
            textField.inputAccessoryView = toolBar
        }
        
        let count = Int(vSlider.value)
        inputFieldsView(fieldCount: count)
    }
    

    
    
    // Генерируем список компонентов pickerView
    func generatePickerData() {
        var value = 300
        while value >= 100 {
            pickerComponent.append(String(value))
            value -= 5
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
    
    
    // Очаг
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
    
    
    // Сложные условия
    @IBAction func hardWorkChange(_ sender: UISwitch) {
        data.hardWork = !data.hardWork
    }
    
    
    // Устанавливаем время включения
    @IBAction func enterTimeChange(_ sender: UIDatePicker) {
        data.enterTime = enterTimePicker!.date
        time.dateFormat = "HH:mm"
        enterTimeDetail.text = time.string(from: data.enterTime)
    }
    
	
    // Устанавливаем время у очага
    @IBAction func fireTimeChange(_ sender: UIDatePicker) {
        data.fireTime = fireTimePicker!.date
        time.dateFormat = "HH:mm"
        fireTimeDetail.text = time.string(from: data.fireTime)
    }
    

    // Меняем численность состава звена ГДЗС
    @IBAction func teamChange(_ sender: UISlider) {
        let teamCount = Int(vSlider.value)
        inputFieldsView(fieldCount: teamCount)
        
    }
    
    
    @IBAction func etst(_ sender: UIBarButtonItem) {
        let teamCount = Int(vSlider.value)
        inputFieldsView(fieldCount: teamCount)
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
        
        // Высота ячейки с полями ввода
        if indexPath == [1, 0] {
            return 256
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
            
            if data.firePlace { // Если очаг найден
//                pdfCreator.appData = data
//                vc.documentData = pdfCreator.foundPDFCreator()
            } else {
                vc.appData = data
                vc.documentData = pdfCreator.notFoundPDFCreator(appData: data)
            }
        }
    }
}


//  расширение для автоматичесткой перевода строки запятой в точку
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
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerComponent.count
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        for textField in textFieldForInput {
            if textField.isEditing {
                textField.text = pickerComponent[row]
            }
        }
        let teamCount = Int(vSlider.value)
        inputFieldsView(fieldCount: teamCount)
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickerComponent[row]
	}
}


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
