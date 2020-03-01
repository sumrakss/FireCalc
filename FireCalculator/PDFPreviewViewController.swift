

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
  @IBOutlet weak var pdfView: PDFView!
    
  public var documentData: Data?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let data = documentData {
      pdfView.document = PDFDocument(data: data)
      pdfView.autoScales = true
    }
  }
  

  
  
  
}

