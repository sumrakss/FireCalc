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
    
	var flag = true
	
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
			}
			
            print("airFlow \(SettingsData.airFlow)")
			print("airRate \(SettingsData.airRate)")
			print("reductionStability \(SettingsData.reductionStability)")
			print()
            checkmarkCell()
        }
        
        // ДАСК
        if indexPath.row == 1  {
			if SettingsData.air {
				SettingsData.airFlow = SettingsData.valueUnit ? 2.0 : 0.2
				SettingsData.air = false
			}
			
            print("airFlow \(SettingsData.airFlow)")
			print("airRate \(SettingsData.airRate)")
			print("reductionStability \(SettingsData.reductionStability)")
			print()
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
