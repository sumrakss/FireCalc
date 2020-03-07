//
//  SettingsTableController.swift
//  FireCalculator
//
//  Created by Алексей on 20.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class SettingsTableController: UITableViewController {
    @IBOutlet weak var tankVolumeTextField: UITextField!
    @IBOutlet weak var reductionStabilityTExtField: UITextField!
    
	var test: Formula!
	
  
    override func viewDidLoad() {
        super.viewDidLoad()
//		print(type(of: test.tankVolume!))
		

    }
    
	@IBAction func volumeChange(_ sender: UITextField) {
		test.tankVolume = Double(tankVolumeTextField.text!)!
		
	}
	
    // Скрываем клавиатуру при касании за ее пределами
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
	

}
