//
//  MarksViewController.swift
//  FireCalculator
//
//  Created by Алексей on 30.04.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit
import PDFKit

class MarksViewController: UIViewController {

	@IBOutlet weak var pdfView: PDFView!
	public var documentData: Data?
	
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
		AppDelegate.AppUtility.lockOrientation(.all)
	}

	
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		// При переходе на другое view разрешаем только портретную ориентацию
		// и устанавливаем ее
		AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
	}
}
