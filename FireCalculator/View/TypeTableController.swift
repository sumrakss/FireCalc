//
//  TypeTableController.swift
//  FireCalculator
//
//  Created by Алексей on 20.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class TypeTableController: UITableViewController {

    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkmarkCell()
    }
    
    
    // Выбираем тип аппарата
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ДАСВ
        if indexPath.row == 0 {
            SettingsData.air = true
            if SettingsData.valueUnit {
                SettingsData.airFlow = SettingsData.airIndex * SettingsData.airRate
            } else {
                SettingsData.airFlow = (SettingsData.airRate * SettingsData.airIndex) / 10
            }
            print(SettingsData.airFlow)
            checkmarkCell()
        }
        
        // ДАСК
        if indexPath.row == 1  {
            SettingsData.air = false
            SettingsData.valueUnit ? (SettingsData.airFlow = 2.0) : (SettingsData.airFlow = 0.2)
            print(SettingsData.airFlow)
            checkmarkCell()
        }
        tableView.reloadData()
    }
    
    func checkmarkCell() {
        if SettingsData.air {
            cell1.accessoryType = .checkmark
            cell2.accessoryType = .none
        } else {
            cell1.accessoryType = .none
            cell2.accessoryType = .checkmark
        }
    }
    
}
