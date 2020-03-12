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
    
    /*
    // Метод генерирует лист А4 c расчетами если очаг пожара найден.
    func foundPDFCreator() -> Data {
        // Вычисляемые значения
        let comp = Formula()
        // 1) Расчет общего времени работы (Тобщ)
        let totalTime = comp.totalTimeCalculation(minPressure: enterData)

        // 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
        let expectedTime = comp.expectedTimeCalculation(inputTime: enterTime, totalTime: totalTime)

        // 3) Расчет давления для выхода (Рк.вых)
        let exitPressure = comp.exitPressureCalculation(maxDrop: fallPressure, hardChoice: hardWork)
        
        // 4) Расчет времени работы у очага (Траб)
        let workTime = comp.workTimeCalculation(minPressure: hearthData, exitPressure: exitPressure)
        
        // 5) Время подачи команды постовым на выход звена
        let  exitTime = comp.expectedTimeCalculation(inputTime: fireTime, totalTime: workTime)
        
        // Константы из формул
               let minPressure = String(Int(enterData.min()!))        // Минимальное давление при включении
               let reductor = String(Int(comp.reductionStability))    // Давление воздуха, необходимое для устойчивой работы редуктора
               let capacity = String(comp.tankVolume)                 // Объем баллона в литрах
               var ratio: String                                      // Коэффициент, учитывающий необходимый запас воздуха
               hardWork ? (ratio = "3") : (ratio = "2.5")             // при сложных условиях = 3, при простых = 2.5
               
               // PDF
               let format = UIGraphicsPDFRendererFormat()
               
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
                   let small = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 15)!]
                
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
    
    */
	
    // Метод генерирует лист А4 c расчетами если очаг пожара не найден.
    func notFoundPDFCreator(appData: AppData) -> Data {
        // Вычисляемые значения
        let comp = Formula()
//        comp.settingsData = settingsData
        // 1) Расчет максимального возможного падения давления при поиске очага
        let maxDrop = comp.maxDropCalculation(minPressure: appData.enterData, hardChoice: appData.hardWork)
        
        // 2) Расчет давления к выходу
        let exitPressure = comp.exitPressureCalculation(minPressure: appData.enterData, maxDrop: maxDrop)
        
        // 3) Расчет промежутка времени с вкл. до подачи команды дТ
        let timeDelta = comp.deltaTimeCalculation(maxDrop: maxDrop)
        
        // 4) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
        let exitTime = comp.expectedTimeCalculation(inputTime: appData.enterTime, totalTime: timeDelta)
        
        // Константы из формул
        let minPressure = String(Int(appData.enterData.min()!))        // Минимальное давление при включении
        let reductor = String(Int(SettingsData.reductionStability))    // Давление воздуха, необходимое для устойчивой работы редуктора
        let capacity = String(SettingsData.cylinderVolume)                 // Объем баллона в литрах
        var ratio: String                                      // Коэффициент, учитывающий необходимый запас воздуха
        appData.hardWork ? (ratio = "3") : (ratio = "2.5")             // при сложных условиях = 3, при простых = 2.5
        
        // PDF
        let format = UIGraphicsPDFRendererFormat()
        
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
            let small = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 15)!]

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
            let time = DateFormatter()
            time.dateFormat = "HH"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 220, y: 397), withAttributes: large)
            time.dateFormat = "mm"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 244, y: 395), withAttributes: small)
            String(Int(timeDelta)).draw(at: CGPoint(x: 275, y: 395), withAttributes: small)
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
    

//    func foundPDFCreator() -> Data {
//
//        return data
//    }
    
    
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
