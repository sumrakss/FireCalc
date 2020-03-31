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
    var appData: AppData?
    
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
            
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
