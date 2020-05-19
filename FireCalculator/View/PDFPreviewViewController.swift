//
//  PDFPreviewViewController.swift
//  FireCalculator
//
//  Created by Алексей on 01.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
    public var documentData: Data?
    var appData: SettingsData?
	let value = SettingsData.measureType == .kgc ? "кгс/см\u{00B2}" : "МПа"
    
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }
    }
    
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// Разрешаем любую ориентацию для отображения PDF-файла с решением
		atencionMessage()
		AppDelegate.AppUtility.lockOrientation(.all)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
	}
	
	
//	override func viewWillDisappear(_ animated: Bool) {
//		super.viewWillDisappear(animated)
//
//		// При переходе на другое view разрешаем только портретную ориентацию
//		// и устанавливаем ее
//		AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
//	}
	
	
	// Выход по звуковому сигналу
	func atencionMessage() {
		let signal = SettingsData.measureType == .kgc ? (String(Int(SettingsData.airSignal))) : (String(format:"%.1f", SettingsData.airSignal))
		if SettingsData.airSignalMode {
			if SettingsData.airSignalFlag {
				let alert = UIAlertController(title: "Внимание!", message: "Выход по звуковому сигналу\n\(signal) \(value)", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				present(alert, animated: true, completion: nil)
				SettingsData.airSignalFlag = false
				return
			}
		}
	}
	
	
	
	@IBAction func shareAction(_ sender: UIBarButtonItem) {
        let pdfCreator = PDFCreator()
		var pdfData = Data()
		if appData!.firePlace {
			pdfData = pdfCreator.foundPDFCreator(appData: appData!)
		} else {
			pdfData = pdfCreator.notFoundPDFCreator(appData: appData!)
		}
        let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
        present(vc, animated: true, completion: nil)
	}
}
