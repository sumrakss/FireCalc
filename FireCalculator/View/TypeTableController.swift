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
    
	
	// Сохнаняем настройки при выходе
    override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		let defaults = UserDefaults.standard
		defaults.set(SettingsData.deviceType.rawValue, forKey: "deviceType")
		
	}
	
	
    // Выбираем тип аппарата
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ДАСВ
        if indexPath.row == 0 {
			if SettingsData.deviceType == .oxigen{
				SettingsData.deviceType = .air
				SettingsData.cylinderVolume = 6.8
				cell1.accessoryType = .checkmark
				cell2.accessoryType = .none
				print("reductionStability \(SettingsData.reductionStability)")
			}
            checkmarkCell()
        }
        
        // ДАСК
        if indexPath.row == 1  {
			if SettingsData.deviceType == .air {
				SettingsData.deviceType = .oxigen
				SettingsData.cylinderVolume = 1.0
				cell1.accessoryType = .none
				cell2.accessoryType = .checkmark
				print("reductionStability \(SettingsData.reductionStability)")
			}
            checkmarkCell()
        }
        tableView.reloadData()
    }
    
    func checkmarkCell() {
		switch SettingsData.deviceType {
			case .air:
				cell1.accessoryType = .checkmark
				cell2.accessoryType = .none
			case .oxigen:
				cell1.accessoryType = .none
				cell2.accessoryType = .checkmark
		}
    }
}
