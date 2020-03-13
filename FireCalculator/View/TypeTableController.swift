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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            SettingsData.air = true
            SettingsData.airFlow = SettingsData.airIndex * SettingsData.airRate
            checkmarkCell()
        }
        
        
        if indexPath.row == 1  {
            SettingsData.air = false
            SettingsData.airFlow = 2.0
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
