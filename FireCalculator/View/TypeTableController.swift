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
			if !SettingsData.air {
				SettingsData.airFlow = SettingsData.airIndex * SettingsData.airRate
				SettingsData.air = true
				SettingsData.cylinderVolume = 6.8
				SettingsData.reductionStability = SettingsData.valueUnit ? 10 : 1.0
				cell1.accessoryType = .checkmark
				cell2.accessoryType = .none
			}
            checkmarkCell()
        }
        
        // ДАСК
        if indexPath.row == 1  {
			if SettingsData.air {
				SettingsData.airFlow = SettingsData.valueUnit ? 2.0 : 0.2
				SettingsData.air = false
				SettingsData.cylinderVolume = 1.0
				cell1.accessoryType = .none
				cell2.accessoryType = .checkmark
			}
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
