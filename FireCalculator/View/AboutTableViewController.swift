//
//  AboutTableViewController.swift
//  FireCalculator
//
//  Created by Алексей on 27.04.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit
import MessageUI

class AboutTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

	
    override func viewDidLoad() {
        super.viewDidLoad()

        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	

	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
		if section == 0 {
	//		let logo = UIImage(named: "logo.png")
			let header = UILabel()
			let version = UILabel()
			let copyright = UILabel()
	//		let imageView = UIImageView(image: logo)
			
			header.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width-0, height: headerView.frame.height-10)
			version.frame = CGRect.init(x: 0, y: 25, width: headerView.frame.width-0, height: headerView.frame.height-10)
			copyright.frame = CGRect.init(x: 0, y: 46, width: headerView.frame.width-0, height: headerView.frame.height-10)
	//		imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
			
			header.text = "БрандМастер - ГДЗС"
			version.text = "Версия 0.8.8"
			copyright.text = "\u{00A9} Aleksey Orekhov"
			header.textAlignment = .center
			version.textAlignment = .center
			copyright.textAlignment = .center
			header.font = UIFont.boldSystemFont(ofSize: 18.0)
	//		header.font = UIFont(name:"", size: 20.0)
			version.font = UIFont.systemFont(ofSize: 14.0)
			copyright.font = UIFont.systemFont(ofSize: 14.0)
			version.textColor = .systemGray
			copyright.textColor = .systemGray
			
	//		headerView.addSubview(imageView)
			headerView.addSubview(header)
			headerView.addSubview(version)
			headerView.addSubview(copyright)
		}
		return headerView
	}
	
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return 83
		}
		return 0
	}
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.section == 1, indexPath.row == 0 {
			if let url = URL(string: "https://vk.com/brmeister") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		
		if indexPath.section == 1, indexPath.row == 1 {
			let email = "bmasterfire@gmail.com"
			if let url = URL(string: "mailto:\(email)") {
			  if #available(iOS 10.0, *) {
				UIApplication.shared.open(url)
			  } else {
				UIApplication.shared.openURL(url)
			  }
			}
		}
		
		if indexPath.section == 1, indexPath.row == 2 {
			if let url = URL(string: "https://alekseyorehov.github.io/BrandMaster/") {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
		tableView.reloadRows(at: [indexPath], with: .none)
	}

	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		   if segue.identifier == "toMarks" {
			   guard let vc = segue.destination as? MarksViewController else { return }
			   let pdfCreator = PDFCreator()
	
			   vc.documentData = pdfCreator.marksViewer()
			   
				
		   }
	   }
	
	
	
	
	
}
