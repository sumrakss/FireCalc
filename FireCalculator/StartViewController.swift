//
//  StartViewController.swift
//  FireCalculator
//
//  Created by Алексей on 03.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    var hearthPlace: Bool = true      // Очаг найден true/false
    var hardChoice: Bool = false    // Сложные условия true/false


    @IBOutlet weak var hardSwitch: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var hearthTimeLabel: UILabel!
    @IBOutlet weak var hearthTimePicker: UIDatePicker!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var hearthPLabel: UILabel!
    @IBOutlet var teamCountStack: [UIStackView]!
    @IBOutlet var startValueFields: [UITextField]!
    @IBOutlet var hearthValueFields: [UITextField]!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var vSlider: UISlider! {
        didSet {
            vSlider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            vSlider.minimumValue = 2
            vSlider.maximumValue = 5
            vSlider.value = 3
        }
    }
    
    // Время включения
    var startTime = Date()
    // Время у очага
    var hearthTime = Date()
    // Давление при включении
    var enterData = [Double]()
    // Давление у очага
    var hearthData = [Double]()
    // Падение давления в звене
    var maxDrop = [Double]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Переносим поля ввода над клавиатурой
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       


        hardSwitch.isOn = false

        let count = Int(vSlider.value)
        inputFieldsView(fieldCount: count)
    }
    
    
    func inputFieldsView(fieldCount: Int) {
        enterData.removeAll()
        hearthData.removeAll()
        maxDrop.removeAll()
        
        for item in teamCountStack {
            item.isHidden = true
        }
        
        for i in 0..<fieldCount {
            if let enterValue = Double(startValueFields[i].text!) {
                enterData.append(enterValue)
            }
            
            if let hearthValue = Double(hearthValueFields[i].text!) {
                hearthData.append(hearthValue)
            }
        
            maxDrop.append(enterData[i] - hearthData[i])
            
            teamCountStack[i].isHidden = false
        }
        
//        print(enterData)
//        print(hearthData)
//        print(maxDrop)
//        print(maxDrop.max()!)
    }
    

    // Скрывает поля "У ОЧАГА" если farePlace = false
    @IBAction func hearthNotFound(_ sender: Any) {

        switch segmentControl.selectedSegmentIndex {
            case 0:
                hearthPlace = true
                hearthPLabel.isHidden = !hearthPLabel.isHidden
                hearthTimeLabel.isEnabled = !hearthTimeLabel.isEnabled
                hearthTimePicker.isEnabled = !hearthTimePicker.isEnabled
                
                for item in hearthValueFields {
                    item.isHidden = false
                }

            case 1:
                hearthPlace = false
                hearthPLabel.isHidden = !hearthPLabel.isHidden
                hearthTimeLabel.isEnabled = !hearthTimeLabel.isEnabled
                hearthTimePicker.isEnabled = !hearthTimePicker.isEnabled
                
                for item in hearthValueFields {
                    item.isHidden = true
                }

            default:
                return
        }
    }
    
    // Меняем значение hardChoice при использовании hardSwitch
    @IBAction func hardChoiceChange(_ sender: Any) {
        hardChoice = !hardChoice
    }


    // Время включения получаем с datePicker
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        startTime = timePicker!.date
    }
    
    
    // Время включения получаем с hearthTimePicker
    @IBAction func hearthTimeChanged(_ sender: UIDatePicker) {
        hearthTime = hearthTimePicker!.date
    }
    
    
    // Изменяет состав звена слайдером
    @IBAction func changeTeam(_ sender: UISlider) {
        let teamCount = Int(vSlider.value)
        inputFieldsView(fieldCount: teamCount)
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        let teamCount = Int(vSlider.value)
        inputFieldsView(fieldCount: teamCount)
        
        if hearthPlace {
            performSegue(withIdentifier: "toFound", sender: self)
        } else {
            performSegue(withIdentifier: "toNotFound", sender: self)
        }
        
    }
    
    
    // Передача данных по segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Передаем данные по segue по индентификатору
        if segue.identifier == "toNotFound" {
            guard let dvc = segue.destination as? NotFoundTableController else { return }
            dvc.maxDrop = maxDrop
            dvc.enterData = enterData
            dvc.startTime = startTime
            dvc.hardChoice = hardChoice
        }
        
        if segue.identifier == "toFound" {
            guard let dvc = segue.destination as? FoundTableViewController else { return }
            dvc.maxDrop = maxDrop
            dvc.enterData = enterData
            dvc.hearthData = hearthData
            dvc.startTime = startTime
            dvc.hardChoice = hardChoice
            dvc.hearthTime = hearthTime
        }
    }

    
    // Скрываем клавиатуру при касании за ее пределами
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Скроллим содержимое страницы при появлении клавиатуры
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

