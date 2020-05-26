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

	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var pdfView: PDFView!
    public var documentData: Data?
    var appData: SettingsData?
    
    
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

	
	// Выход по звуковому сигналу
	func atencionMessage() {
		if SettingsData.airSignalMode {
			if SettingsData.airSignalFlag {
				SettingsData.airSignalFlag = false
			}
		}
	}
	
	
	@IBAction func shareAction(_ sender: UIBarButtonItem) {
        let pdfCreator = PDFCreator()
		var pdfData = Data()
		if  appData!.firePlace {
			pdfData = pdfCreator.foundPDFCreator(appData: appData!)
		} else {
			pdfData = pdfCreator.notFoundPDFCreator(appData: appData!)
		}
        let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
        present(vc, animated: true, completion: nil)
	}
}
