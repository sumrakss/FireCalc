//
//  ResponsibilityViewController.swift
//  FireCalculator
//
//  Created by Алексей on 22.05.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class ResponsibilityViewController: UIViewController {

	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var fontStepper: UIStepper! {
		didSet {
			fontStepper.value = Double(SettingsData.fontSize)
			fontStepper.minimumValue = 14
			fontStepper.maximumValue = 26
		}
	}
	var text = ""

//	@IBAction func fontSize(_ sender: UIPinchGestureRecognizer) {
//	}
	
	@IBAction func fontSize(_ sender: UIStepper) {
		let font = textView.font?.fontName
		let fontSize = CGFloat(sender.value)
		textView.font = UIFont(name: font!, size: fontSize)
		SettingsData.fontSize = Double(fontSize)
		
		SettingsData.settings.saveSettings()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let font = textView.font?.fontName
		let fontSize = CGFloat(SettingsData.fontSize)
		textView.font = UIFont(name: font!, size: fontSize)
		
//		textView.zoomScale = SettingsData.fontSize
		
//		textView.bouncesZoom = false
//		textView.minimumZoomScale = 0.7
//		textView.maximumZoomScale = 1.5
		
//		SettingsData.fontSize = fontSize
		
		textView.text? = text
    }

	
	override func viewWillDisappear(_ animated: Bool) {
//		super.viewWillAppear(animated)
	}
	
	
}
