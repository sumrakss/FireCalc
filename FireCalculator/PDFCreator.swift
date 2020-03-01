/// Copyright (c) 2020 Razeware LLC
///


import UIKit
import PDFKit

class PDFCreator: NSObject {
  
  func createFlyer() -> Data {
    let pdfMetaData = [
      kCGPDFContextCreator: "Formula",
      kCGPDFContextAuthor: "Bolas"
    ]
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]
    
    let pageWidth = 8.5 * 72.0
    let pageHeight = 11 * 72.0
    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
    
    let data = renderer.pdfData { (context) in
        // 5
        context.beginPage()
        // 6
        let large = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)] //boldSystemFont(ofSize: 72)
        let small = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
//        let attributes3 = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 8)]
//        let text = "I'm a PDF!"
//        text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        let x = 10
        let y = 20
        let solussion = "РЕШЕНИЕ:"
        let pressure = "P"
        let maxpadP = "max пад"
        let mininpP = "min вкл"
        let ustrabP = "уст. раб"
        let exitP = "к. вых"
        let kgcm = "кг/см"
      
//        let equally = "="
      
        solussion.draw(at: CGPoint(x: 230+x, y: 35+y), withAttributes: large)
      
        pressure.draw(at: CGPoint(x: 15+x, y: 105+y), withAttributes: large)
        maxpadP.draw(at: CGPoint(x: 25+x, y: 125+y), withAttributes: small)
        "=".draw(at: CGPoint(x: 90+x, y: 105+y), withAttributes: large)
      
        pressure.draw(at: CGPoint(x: 110+x, y: 80+y), withAttributes: large)
        mininpP.draw(at: CGPoint(x: 120+x, y: 100+y), withAttributes: small)
        "-".draw(at: CGPoint(x: 180+x, y: 80+y), withAttributes: large)
        pressure.draw(at: CGPoint(x: 200+x, y: 80+y), withAttributes: large)
        ustrabP.draw(at: CGPoint(x: 210+x, y: 100+y), withAttributes: small)
        "3".draw(at: CGPoint(x: 180+x, y: 130+y), withAttributes: large)
        "=".draw(at: CGPoint(x: 260+x, y: 105+y), withAttributes: large)
      
        
      }

      return data
    
  }
  
  /*
  func addBodyText(pageRect: CGRect, textTop: CGFloat) {
    let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    // 1
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .natural
    paragraphStyle.lineBreakMode = .byWordWrapping
    // 2
    let textAttributes = [
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
      NSAttributedString.Key.font: textFont
    ]
    let attributedText = NSAttributedString(
      string: body, attributes: textAttributes
    )
    // 3
    let textRect = CGRect(
      x: 10,
      y: textTop,
      width: pageRect.width - 20,
      height: pageRect.height - textTop - pageRect.height / 5.0
    )
    attributedText.draw(in: textRect)
  }

  
  // 1
  func drawTearOffs(_ drawContext: CGContext, pageRect: CGRect,
                    tearOffY: CGFloat, numberTabs: Int) {
    // 2
    drawContext.saveGState()
    // 3
    drawContext.setLineWidth(2.0)

    // 4
    drawContext.move(to: CGPoint(x: 0, y: tearOffY))
    drawContext.addLine(to: CGPoint(x: pageRect.width, y: tearOffY))
    drawContext.strokePath()
    drawContext.restoreGState()

    // 5
    drawContext.saveGState()
    let dashLength = CGFloat(72.0 * 0.2)
    drawContext.setLineDash(phase: 0, lengths: [dashLength, dashLength])
    // 6
    let tabWidth = pageRect.width / CGFloat(numberTabs)
    for tearOffIndex in 1..<numberTabs {
      // 7
      let tabX = CGFloat(tearOffIndex) * tabWidth
      drawContext.move(to: CGPoint(x: tabX, y: tearOffY))
      drawContext.addLine(to: CGPoint(x: tabX, y: pageRect.height))
      drawContext.strokePath()
    }
    // 7
    drawContext.restoreGState()
  }
  */
  

  
  
}
