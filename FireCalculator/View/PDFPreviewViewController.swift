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
		AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
	}

	
	override func viewWillDisappear(_ animated: Bool) {
		// При переходе на другое view разрешаем только портретную ориентацию
		// и устанавливаем ее
		AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
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
