//
//  SettingsTableController.swift
//  FireCalculator
//
//  Created by Алексей on 20.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

protocol DataDelegate {
    func transferData(data: Double)
}

class SettingsTableController: UITableViewController {
         
    @IBOutlet weak var tankVolumeTextField: UITextField!
    @IBOutlet weak var reductionStabilityTExtField: UITextField!

    var delegate: DataDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func changeData(_ sender: Any) {
        let data = Double(tankVolumeTextField.text!)!
        delegate?.transferData(data: data)
    }
    
    // Скрываем клавиатуру при касании за ее пределами
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
	

}
