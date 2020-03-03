//
//  PDFCreator.swift
//  FireCalculator
//
//  Created by Алексей on 01.03.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit
import PDFKit

class PDFCreator: NSObject {
    
    let minPressure = 280   // Минимальное давление при включении
    let reductionStability = 10
    let maxDrop = 90    // Максимальное падение давления при поиске
    let ratio = 3   //  Коэффициент сложности
    
    enum value: String {
        case kg = "кг/см"
        case mp = "МПа"
    }
    
    

    
    
    // Метод генерирует лист формата А4 если очаг пожара не найден
    func fireNotFound() -> Data {
//        let pdfMetaData = [
//          kCGPDFContextCreator: "Formula",
//          kCGPDFContextAuthor: "Bolas"
//        ]
        let format = UIGraphicsPDFRendererFormat()
//        format.documentInfo = pdfMetaData as [String: Any]
        
        
        // A4 size
        let pageWidth = 595.2
        let pageHeight = 841.8
        
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { (context) in
               
            context.beginPage()
            let context = context.cgContext
            
            // Щрифты
            let large = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 20)!]
//            let small = [NSAttributedString.Key.font: UIFont(name: "Times", size: 13)!]

            // 1
            String(minPressure).draw(at: CGPoint(x: 335, y: 120), withAttributes: large)
            String(reductionStability).draw(at: CGPoint(x: 393, y: 120), withAttributes: large)
            String(ratio).draw(at: CGPoint(x: 220, y: 148), withAttributes: large)
            String(ratio).draw(at: CGPoint(x: 372, y: 148), withAttributes: large)
            String(maxDrop).draw(at: CGPoint(x: 444, y: 135), withAttributes: large)
          
//            drawLine(context, length: 110, pointX: 95+cgHorizontal, pointY: 98+cgVertical)
            


            
            
             // Добавление PDF шаблона с формулами
            let path = Bundle.main.path(forResource: "test2", ofType: "pdf")!
            let url = URL(fileURLWithPath: path)
            let document = CGPDFDocument(url as CFURL)
            let page = document?.page(at: 1)
            UIColor.white.set()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.drawPDFPage(page!)
            
          }

        
          return data
        
        
    }
    

    
    
    /*
     length - длина линии
     pointX - начальная координата линии по оси Х
     pointY - положение линии заданной длины по осиY
     */
    func drawLine(_ drawContext: CGContext, length: CGFloat, pointX: CGFloat, pointY: CGFloat) {

        drawContext.saveGState()
        // Толщина линии
        drawContext.setLineWidth(1.0)
        drawContext.move(to: CGPoint(x: pointX, y: pointY))
        let endPointX = pointX + length

        drawContext.addLine(to: CGPoint(x: endPointX, y: pointY))
        drawContext.strokePath()
        drawContext.restoreGState()
    }
    
    // Метод рисует линии в формулах
    /*
     startLineX - координата начала линии по оси X
     startLineY - координата конца линии по оси Х
     heightLineY - положение линии по оси Y
     
     Чтобы нарисовать диагональную линию, heightLineY в методах move и addLine
     должны иметь разное значение.
     */
    func drawTearOffs(_ drawContext: CGContext, startLineX: CGFloat, endLineX: CGFloat,
                      heightLineY: CGFloat) {

      drawContext.saveGState()
      // Толщина линии
      drawContext.setLineWidth(1.0)
      // Начало линии
      drawContext.move(to: CGPoint(x: startLineX, y: heightLineY))
      // Конец линии
      drawContext.addLine(to: CGPoint(x: endLineX, y: heightLineY))
      drawContext.strokePath()
      drawContext.restoreGState()
    }
}
