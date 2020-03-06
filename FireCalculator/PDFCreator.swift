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
    
    // Время велючения
    var enterTime = Date()
    // Давление при включении
    var enterData = [Double]()
    // Сложные условия true/false
    var hardWork: Bool = false
    
    // Очаг найден true/false
    var firePlace: Bool = true
    // Падение давления в звене
    var maxDrop = [Double]()
    
    
    // Метод генерирует лист А4 c расчетами если очаг пожара не найден.
    func notFoundPDFCreator() -> Data {
        
        // Вычисляемые значения
        let comp = Formula()
        // 1) Расчет максимального возможного падения давления при поиске очага
        let maxDrop = comp.maxDropCalculation(minPressure: enterData, hardChoice: hardWork)
        
        // 2) Расчет давления к выходу
        let exitPressure = comp.exitPressureCalculation(minPressure: enterData, maxDrop: maxDrop)
        
        // 3) Расчет промежутка времени с вкл. до подачи команды дТ
        let timeDelta = comp.deltaTimeCalculation(maxDrop: maxDrop)
        
        // 4) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
        let exitTime = comp.expectedTimeCalculation(inputTime: enterTime, totalTime: timeDelta)
        
        // Константы из формул
        let minPressure = String(Int(enterData.min()!))        // Минимальное давление при включении
        let reductor = String(Int(comp.reductionStability))    // Давление воздуха, необходимое для устойчивой работы редуктора
        let capacity = String(comp.tankVolume)                 // Объем баллона в литрах
        var ratio: String                                      // Коэффициент, учитывающий необходимый запас воздуха
        hardWork ? (ratio = "3") : (ratio = "2.5")             // при сложных условиях = 3, при простых = 2.5
        
        // PDF
        let pdfMetaData = [
          kCGPDFContextCreator: "Formula",
          kCGPDFContextAuthor: "Bolas"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        
        // A4 size
        let pageWidth = 595.2
        let pageHeight = 841.8
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let context = context.cgContext
            
            
            // Щрифты для констант и вычисляемых значений
            let large = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 20)!]
//            let small = [NSAttributedString.Key.font: UIFont(name: "Times", size: 13)!]

            // Координаты констант и вычисляемых значений на листе A4
            // 1
            minPressure.draw(at: CGPoint(x: 335, y: 120), withAttributes: large)
            reductor.draw(at: CGPoint(x: 393, y: 120), withAttributes: large)
            ratio.draw(at: CGPoint(x: 220, y: 148), withAttributes: large)
            ratio.draw(at: CGPoint(x: 372, y: 148), withAttributes: large)
            String(Int(maxDrop)).draw(at: CGPoint(x: 444, y: 135), withAttributes: large)

            // 2
            minPressure.draw(at: CGPoint(x: 327, y: 218), withAttributes: large)
            String(Int(maxDrop)).draw(at: CGPoint(x: 390, y: 218), withAttributes: large)
            String(Int(ceil(exitPressure))).draw(at: CGPoint(x: 445, y: 218), withAttributes: large)

            // 3
            String(Int(maxDrop)).draw(at: CGPoint(x: 245, y: 295), withAttributes: large)
            capacity.draw(at: CGPoint(x: 295, y: 295), withAttributes: large)
            String(format:"%.1f", timeDelta).draw(at: CGPoint(x: 350, y: 310), withAttributes: large)
            
            // 4
            exitTime.draw(at: CGPoint(x: 325, y: 397), withAttributes: large)
            
            
            // Подставляем PDF шаблон с формулами
            let path = Bundle.main.path(forResource: "test3", ofType: "pdf")!
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
