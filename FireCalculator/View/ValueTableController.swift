//
//  ValueTableController.swift
//  FireCalculator
//
//  Created by Алексей on 13.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class ValueTableController: UITableViewController {

    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cellLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        cellLabel.text = "кгс/см\u{00B2}"
        checkmarkCell()
        
    }

    
    // Выбираем единицы измерения
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // кгс/см2
        if indexPath.row == 0 {
			if !SettingsData.valueUnit {
				if SettingsData.air {
					SettingsData.reductionStability *= 10
					SettingsData.airRate *= 10
					SettingsData.airFlow = (SettingsData.airRate * SettingsData.airIndex)
				} else {
					SettingsData.reductionStability *= 10
					SettingsData.airRate *= 10
					SettingsData.airFlow = 2
				}
				SettingsData.valueUnit = true
			}
            checkmarkCell()
        }
        // МПа
        if indexPath.row == 1 {
			if SettingsData.valueUnit {
				if SettingsData.air {
					SettingsData.reductionStability /= 10
					SettingsData.airRate /= 10
					SettingsData.airFlow = (SettingsData.airRate * SettingsData.airIndex)
				} else {
					SettingsData.reductionStability /= 10
					SettingsData.airRate /= 10
					SettingsData.airFlow = 0.2
				}
				SettingsData.valueUnit = false
			}
            checkmarkCell()
        }
        tableView.reloadData()
    }
    
    
    func checkmarkCell() {
        if SettingsData.valueUnit {
            cell1.accessoryType = .checkmark
            cell2.accessoryType = .none
        } else {
            cell1.accessoryType = .none
            cell2.accessoryType = .checkmark
        }
    }
}
