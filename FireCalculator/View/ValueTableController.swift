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
			if SettingsData.measureType == .mpa {
				SettingsData.reductionStability *= 10
				SettingsData.airRate *= 10
//				switch SettingsData.deviceType {
//					case .air:
//						SettingsData.reductionStability *= 10
//						SettingsData.airRate *= 10
////						SettingsData.airFlow = (SettingsData.airRate * SettingsData.airIndex)
//					case .oxigen:
//						SettingsData.reductionStability *= 10
//						SettingsData.airRate *= 10
////						SettingsData.airFlow = 2
//				}
				SettingsData.measureType = .kgc
				print("reductionStability \(SettingsData.reductionStability)")
				print("airRate \(SettingsData.airRate)")
				print("airFlow \(SettingsData.airFlow)")
			}
            checkmarkCell()
        }
		
        // МПа
        if indexPath.row == 1 {
			if SettingsData.measureType == .kgc {
				SettingsData.reductionStability /= 10
				SettingsData.airRate /= 10
//				switch SettingsData.deviceType {
//					case .air:
//						SettingsData.reductionStability /= 10
//						SettingsData.airRate /= 10
////						SettingsData.airFlow = (SettingsData.airRate * SettingsData.airIndex)
//					case .oxigen:
//						SettingsData.reductionStability /= 10
//						SettingsData.airRate /= 10
////						SettingsData.airFlow = 0.2
//				}
				SettingsData.measureType = .mpa
				print("reductionStability \(SettingsData.reductionStability)")
				print("airRate \(SettingsData.airRate)")
				print("airFlow \(SettingsData.airFlow)")
			}
            checkmarkCell()
        }
        tableView.reloadData()
    }
    
    
    func checkmarkCell() {
		switch SettingsData.measureType {
			case .kgc:
				cell1.accessoryType = .checkmark
				cell2.accessoryType = .none
			case .mpa:
				cell1.accessoryType = .none
				cell2.accessoryType = .checkmark
		}
    }
}
