//
//  ResponsibilityTableViewController.swift
//  FireCalculator
//
//  Created by Алексей on 22.05.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class GSTableViewController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "toResb", sender: self)
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toResb" {
			let text = TextForView()
			guard let vc = segue.destination as? ResponsibilityViewController else { return }
			let row = tableView.indexPathForSelectedRow!.row
			let section = tableView.indexPathForSelectedRow!.section
			
			switch section {
				case 0:
					vc.text = text.gsList[row]
				case 1:
					break
				default:
					break
			}
		}
	}
}
