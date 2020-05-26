//
//  ResponsibilityTableViewController.swift
//  FireCalculator
//
//  Created by Алексей on 22.05.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class ResponsibilityTableViewController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toRespView", sender: self)
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toRespView" {
			let text = TextForView()
			guard let vc = segue.destination as? ResponsibilityViewController else { return }
			let row = tableView.indexPathForSelectedRow!.row
			let section = tableView.indexPathForSelectedRow!.section
			
			switch section {
				case 0:
					vc.text = text.serviceList[row]
				case 1:
					vc.text = text.functionList[row]
				default:
					break
			}
		}
	}
}
