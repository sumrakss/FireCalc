//
//  NewStartViewController.swift
//  FireCalculator
//
//  Created by Алексей on 18.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class NewStartViewController: UITableViewController {

//    var tappedIndexPath: IndexPath?
    var tappedCell1: Bool = false
    var tappedCell2: Bool = false
    // Очаг найден true/false
    var firePlace: Bool = true
    // Сложные условия true/false
    var hardWork: Bool = false
    // Время включения
    var enterTime = Date()
    // Время у очага
    var fireTime = Date()
    
    // Давление при включении
    var enterData = [Double]()
    // Давление у очага
    var hearthData = [Double]()
    // Падение давления в звене
    var maxDrop = [Double]()
    

    
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
    
    
    @IBOutlet var teamCountStack: [UIStackView]!
    @IBOutlet var enterValueFields: [UITextField]!
    @IBOutlet var firePlaceFields: [UITextField]!
    @IBOutlet weak var vSlider: UISlider! {
        didSet {
            vSlider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            vSlider.minimumValue = 2
            vSlider.maximumValue = 5
            vSlider.value = 3
        }
    }
    
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let time = DateFormatter()
        time.dateFormat = "HH:mm"
        enterTimeDetail.text = time.string(from: enterTime)
        fireTimeDetail.text = time.string(from: fireTime)
        
        let count = Int(vSlider.value)
        inputFieldsView(fieldCount: count)
    }
    
  
    
    // Отрисовываем поля ввода в зависимости от состава звена
    func inputFieldsView(fieldCount: Int) {
            enterData.removeAll()
            hearthData.removeAll()
            maxDrop.removeAll()
            
            for item in teamCountStack {
                item.isHidden = true
            }
            
            for i in 0..<fieldCount {
                if let enterValue = Double(enterValueFields[i].text!) {
                    enterData.append(enterValue)
                }
                
                if let hearthValue = Double(firePlaceFields[i].text!) {
                    hearthData.append(hearthValue)
                }
            
                maxDrop.append(enterData[i] - hearthData[i])
                
                teamCountStack[i].isHidden = false
            }
        }
    
    
    
    // Очаг
    @IBAction func firePlaceChange(_ sender: Any) {
        firePlace = !firePlace
        fireStackLabel.isHidden = !fireStackLabel.isHidden
        fireTimeLabel.isEnabled = !fireTimeLabel.isEnabled
        // Делаем ячейку неактивной в случае если очаг не найден
        fireTimeDetail.isEnabled = !fireTimeDetail.isEnabled
        firePlace ? (fireTimeCell.selectionStyle = .default) : (fireTimeCell.selectionStyle = .none)
        // Скрываем TimePicker если очаг не найден
        if tappedCell2 {  tappedCell2 = false }
        
        tableView.reloadData()
        
        for item in firePlaceFields {
            item.isHidden = !item.isHidden
        }
    }
    
    
    // Сложные условия
    @IBAction func hardWorkChange(_ sender: UISwitch) {
        hardWork = !hardWork
        
        
        
    }
    
    
    
    // Устанавливаем время включения
    @IBAction func enterTimeChange(_ sender: UIDatePicker) {
        enterTime = enterTimePicker!.date
        let time = DateFormatter()
        time.dateFormat = "HH:mm"
        enterTimeDetail.text = time.string(from: enterTime)
        
    }
    
    // Устанавливаем время у очага
    @IBAction func fireTimeChange(_ sender: UIDatePicker) {
        fireTime = fireTimePicker!.date
        let time = DateFormatter()
        time.dateFormat = "HH:mm"
        fireTimeDetail.text = time.string(from: fireTime)
    }
    
    
    
    

    // Меняем численность состава звена ГДЗС
    @IBAction func teamChange(_ sender: UISlider) {
        let teamCount = Int(vSlider.value)
        inputFieldsView(fieldCount: teamCount)
    }
    
    
    
    
    // Скрываем клавиатуру при касании за ее пределами
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: Скрываем и отображам DatePicker по тапу на ячейке
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 2 {
            tappedCell1 = !tappedCell1
        }

        if indexPath.row == 4 && firePlace {
             tappedCell2 = !tappedCell2
        }

        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }

//
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {


        if indexPath.row == 3 {
            if tappedCell1 {
                return tableView.rowHeight
            } else {
               
                return 0
            }
        }

        if indexPath.row == 5 {
            if tappedCell2  && firePlace {
                return tableView.rowHeight
            } else {
                
                return 0
            }
        }
        
        // Высота ячейки с полями ввода
        if indexPath == [1, 0] {
            return 256
        }


        return tableView.rowHeight
    }
        

    
    
    // Передача данных по segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "previewSegue" {
        guard let vc = segue.destination as? PDFPreviewViewController else { return }
        let pdfCreator = PDFCreator()
        vc.documentData = pdfCreator.fireNotFound()
      }
    }

}
