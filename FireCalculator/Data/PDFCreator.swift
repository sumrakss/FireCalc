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
    
//	private var value = "кгс/см\u{00B2}"
	let value = SettingsData.valueUnit ? "кгс/см\u{00B2}" : "МПа"
	let airPressK = "* К"
	let airPressSG = "сж"
	
    // Метод генерирует лист А4 c расчетами если очаг пожара найден.
    func foundPDFCreator(appData: AppData) -> Data {
        // Вычисляемые значения
        let comp = Formula()
        // 1) Расчет общего времени работы (Тобщ)
        let totalTime = comp.totalTimeCalculation(minPressure: appData.enterData)

        // 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
        let expectedTime = comp.expectedTimeCalculation(inputTime: appData.enterTime, totalTime: totalTime)

        // 3) Расчет давления для выхода (Рк.вых)
        let exitPressure = comp.exitPressureCalculation(maxDrop: appData.fallPressure, hardChoice: appData.hardWork)

        // 4) Расчет времени работы у очага (Траб)
        let workTime = comp.workTimeCalculation(minPressure: appData.hearthData, exitPressure: exitPressure)

        // 5) Время подачи команды постовым на выход звена
        let  exitTime = comp.expectedTimeCalculation(inputTime: appData.fireTime, totalTime: workTime)

        // Константы из формул
//		let value = SettingsData.valueUnit ? "кгс/см\u{00B2}" : "МПа"
		// Минимальное давление при включении
		let minPressure = SettingsData.valueUnit ? String(Int(appData.enterData.min()!)) : String(appData.enterData.min()!)
		// Минимальне давление у очага
		let minFirePressure = SettingsData.valueUnit ? String(Int(appData.hearthData.min()!)) : String(appData.hearthData.min()!)
		// Давление воздуха, необходимое для устойчивой работы редуктора
		let reductor = String(Int(SettingsData.reductionStability))
		// Объем баллона в литрах
        let capacity = String(SettingsData.cylinderVolume)
		
		let airRate = SettingsData.valueUnit ? String(Int(SettingsData.airRate)) : String(Int(SettingsData.airRate / 10))
		// Pквых округлям при кгс и не меняем при МПа
		let exitPString = SettingsData.valueUnit ? String(Int(exitPressure)) : String(format:"%.1f", exitPressure)
		
		let airIndex = String(SettingsData.airIndex)
		
		let maxFallPresure = SettingsData.valueUnit ? String(Int(appData.fallPressure.max()!)) : String(appData.fallPressure.max()!)
		
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
			let large = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 16)!]
			let small = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 12)!]

			
			// 0
			maxFallPresure.draw(at: CGPoint(x: 120, y: 123), withAttributes: large)
			value.draw(at: CGPoint(x: 145, y: 123), withAttributes: large)
			
			// 1
			// 40
			airRate.draw(at: CGPoint(x: 150, y: 206), withAttributes: large)
			// 1.1
			airIndex.draw(at: CGPoint(x: 350, y: 206), withAttributes: large)
			
            minPressure.draw(at: CGPoint(x: 286, y: 182), withAttributes: large)
			// 10
            reductor.draw(at: CGPoint(x: 333, y: 182), withAttributes: large)
			// 6.8
			capacity.draw(at: CGPoint(x: 370, y: 182), withAttributes: large)
			// 40
            airRate.draw(at: CGPoint(x: 310, y: 206), withAttributes: large)
			// T
			String(format:"%.1f", totalTime).draw(at: CGPoint(x: 422, y: 194), withAttributes: large)
			String(Int(totalTime)).draw(at: CGPoint(x: 480, y: 194), withAttributes: large)
			
			//2
			let time = DateFormatter()
            time.dateFormat = "HH"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 200, y: 268), withAttributes: large)
            time.dateFormat = "mm"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 220, y: 266), withAttributes: small)
			String(Int(totalTime)).draw(at: CGPoint(x: 251, y: 266), withAttributes: small)
			expectedTime.draw(at: CGPoint(x: 285, y: 268), withAttributes: large)
			
			// 3
			if appData.hardWork {
				maxFallPresure.draw(at: CGPoint(x: 340, y: 333), withAttributes: large)
				maxFallPresure.draw(at: CGPoint(x: 382, y: 333), withAttributes: large)
				reductor.draw(at: CGPoint(x: 428, y: 333), withAttributes: large)
				
				exitPString.draw(at: CGPoint(x: 480, y: 333), withAttributes: large)
				value.draw(at: CGPoint(x: 508, y: 333), withAttributes: large)
			} else {
				maxFallPresure.draw(at: CGPoint(x: 318, y: 342), withAttributes: large)
				maxFallPresure.draw(at: CGPoint(x: 373, y: 342), withAttributes: large)
				reductor.draw(at: CGPoint(x: 415, y: 342), withAttributes: large)
//				String(format:"%.1f", exitPressure).draw(at: CGPoint(x: 442, y: 342), withAttributes: large)
				exitPString.draw(at: CGPoint(x: 455, y: 342), withAttributes: large)
				value.draw(at: CGPoint(x: 490, y: 342), withAttributes: large)
			}
			
			
			// 4
			if appData.hardWork {
				// 40
				airRate.draw(at: CGPoint(x: 138, y: 422), withAttributes: large)
				minFirePressure.draw(at: CGPoint(x: 268, y: 395), withAttributes: large)
				// 10
				exitPString.draw(at: CGPoint(x: 313, y: 395), withAttributes: large)
				// 6.8
				capacity.draw(at: CGPoint(x: 367, y: 395), withAttributes: large)
				// 40
				airRate.draw(at: CGPoint(x: 305, y: 420), withAttributes: large)
				// 1.1
				airIndex.draw(at: CGPoint(x: 335, y: 420), withAttributes: large)
				// T
				String(format:"%.1f", workTime).draw(at: CGPoint(x: 420, y: 410), withAttributes: large)
				String(Int(workTime)).draw(at: CGPoint(x: 478, y: 410), withAttributes: large)
			} else {
				// 40
				airRate.draw(at: CGPoint(x: 140, y: 435), withAttributes: large)
				minFirePressure.draw(at: CGPoint(x: 268, y: 410), withAttributes: large)
				// 10
				exitPString.draw(at: CGPoint(x: 316, y: 410), withAttributes: large)
				// 6.8
				capacity.draw(at: CGPoint(x: 355, y: 410), withAttributes: large)
				// 40
				airRate.draw(at: CGPoint(x: 295, y: 435), withAttributes: large)
				// 1.1
				airIndex.draw(at: CGPoint(x: 328, y: 435), withAttributes: large)
				// T
				String(format:"%.1f", workTime).draw(at: CGPoint(x: 410, y: 423), withAttributes: large)
				String(Int(workTime)).draw(at: CGPoint(x: 470, y: 423), withAttributes: large)
			}
			
			// 5
			if appData.hardWork {
				time.dateFormat = "HH"
				time.string(from: appData.fireTime).draw(at: CGPoint(x: 190, y: 483), withAttributes: large)
				time.dateFormat = "mm"
				time.string(from: appData.fireTime).draw(at: CGPoint(x: 210, y: 481), withAttributes: small)
				String(Int(workTime)).draw(at: CGPoint(x: 238, y: 481), withAttributes: small)
				exitTime.draw(at: CGPoint(x: 275, y: 483), withAttributes: large)
			} else {
				time.dateFormat = "HH"
				time.string(from: appData.fireTime).draw(at: CGPoint(x: 190, y: 496), withAttributes: large)
				time.dateFormat = "mm"
				time.string(from: appData.fireTime).draw(at: CGPoint(x: 210, y: 494), withAttributes: small)
				String(Int(workTime)).draw(at: CGPoint(x: 238, y: 494), withAttributes: small)
				exitTime.draw(at: CGPoint(x: 275, y: 496), withAttributes: large)
			}
			
			// Подставляем PDF шаблон с формулами
			let path = appData.hardWork ? Bundle.main.path(forResource: "hardAirFound", ofType: "pdf")! : Bundle.main.path(forResource: "airFound", ofType: "pdf")!
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
    
    
	
    // Метод генерирует лист А4 c расчетами если очаг пожара не найден.
    func notFoundPDFCreator(appData: AppData) -> Data {
        // Вычисляемые значения
        let comp = Formula()
        // 1) Расчет максимального возможного падения давления при поиске очага
        let maxDrop = comp.maxDropCalculation(minPressure: appData.enterData, hardChoice: appData.hardWork)
        
        // 2) Расчет давления к выходу
        let exitPressure = comp.exitPressureCalculation(minPressure: appData.enterData, maxDrop: maxDrop)
        
        // 3) Расчет промежутка времени с вкл. до подачи команды дТ
        let timeDelta = comp.deltaTimeCalculation(maxDrop: maxDrop)
        
        // 4) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
        let exitTime = comp.expectedTimeCalculation(inputTime: appData.enterTime, totalTime: timeDelta)
        
        // Константы из формул
		// Минимальное давление при включении
        let minPressure = SettingsData.valueUnit ? String(Int(appData.enterData.min()!)) : String(appData.enterData.min()!)
		// Максимальное падение давления
		let maxDropString = SettingsData.valueUnit ? (String(Int(maxDrop))) : (String(format:"%.1f", maxDrop))
		// Давление к выходу
		let exitPString = SettingsData.valueUnit ? (String(Int(exitPressure))) : (String(format:"%.1f", exitPressure))
		// Давление воздуха, необходимое для устойчивой работы редуктора
        let reductor = String(Int(SettingsData.reductionStability))
		// Объем баллона в литрах
        let capacity = String(SettingsData.cylinderVolume)
		// Коэффициент, учитывающий необходимый запас воздуха
        var ratio: String
		// при сложных условиях = 3, при простых = 2.5
        appData.hardWork ? (ratio = "3") : (ratio = "2.5")
		// Коэффициент сжатия воздуха
        let airIndex = String(SettingsData.airIndex)
		// 40 средний расход воздуха
		let airRate =  String(Int(SettingsData.airRate)) 
        
		let airFlow = SettingsData.valueUnit ? String(Int(SettingsData.airFlow)) : String(SettingsData.airFlow)
		
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
            minPressure.draw(at: CGPoint(x: 338, y: 120), withAttributes: large)
            reductor.draw(at: CGPoint(x: 398, y: 120), withAttributes: large)
            ratio.draw(at: CGPoint(x: 220, y: 148), withAttributes: large)
            ratio.draw(at: CGPoint(x: 372, y: 148), withAttributes: large)
            maxDropString.draw(at: CGPoint(x: 445, y: 135), withAttributes: large)
			value.draw(at: CGPoint(x: 488, y: 135), withAttributes: large)

            // 2
            minPressure.draw(at: CGPoint(x: 327, y: 218), withAttributes: large)
            maxDropString.draw(at: CGPoint(x: 385, y: 218), withAttributes: large)
            exitPString.draw(at: CGPoint(x: 443, y: 218), withAttributes: large)
			value.draw(at: CGPoint(x: 488, y: 218), withAttributes: large)

            // 3
			if SettingsData.air {
				airRate.draw(at: CGPoint(x: 112, y: 324), withAttributes: large)
				airPressK.draw(at: CGPoint(x: 140, y: 324), withAttributes: large)
				airPressSG.draw(at: CGPoint(x: 170, y: 333), withAttributes: small)
				
				airRate.draw(at: CGPoint(x: 255, y: 324), withAttributes: large)
				"*".draw(at: CGPoint(x: 282, y: 325), withAttributes: large)
				airIndex.draw(at: CGPoint(x: 295, y: 324), withAttributes: large)
			} else {
				airFlow.draw(at: CGPoint(x: 140, y: 324), withAttributes: large)
				airFlow.draw(at: CGPoint(x: 290, y: 324), withAttributes: large)
			}
			
            maxDropString.draw(at: CGPoint(x: 248, y: 295), withAttributes: large)
            capacity.draw(at: CGPoint(x: 308, y: 295), withAttributes: large)
			
			
            String(format:"%.1f", timeDelta).draw(at: CGPoint(x: 360, y: 310), withAttributes: large)
			String(Int(timeDelta)).draw(at: CGPoint(x: 423, y: 310), withAttributes: large)
            
//             4
            let time = DateFormatter()
            time.dateFormat = "HH"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 220, y: 397), withAttributes: large)
            time.dateFormat = "mm"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 244, y: 395), withAttributes: small)
            String(Int(timeDelta)).draw(at: CGPoint(x: 282, y: 395), withAttributes: small)
            exitTime.draw(at: CGPoint(x: 325, y: 397), withAttributes: large)

            // Подставляем PDF шаблон с формулами
			let path = Bundle.main.path(forResource: "airNotFound", ofType: "pdf")!
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
	func patternPDF(fileName: String) -> Data {
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
			let large = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 16)!]
			let small = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 15)!]

			// Подставляем PDF шаблон с формулами
			let path = Bundle.main.path(forResource: fileName, ofType: "pdf")!
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
