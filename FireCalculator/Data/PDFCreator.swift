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
    
	let value = SettingsData.measureType == .kgc ? "кгс/см\u{00B2}" : "МПа"
	let airPressSG = "сж"
	
	
	// PDF-страница с примечаниями
	func marksViewer() -> Data{
		// 1
		let pdfMetaData = [
		  kCGPDFContextCreator: "Flyer Builder",
		  kCGPDFContextAuthor: "raywenderlich.com"
		]
		let format = UIGraphicsPDFRendererFormat()
		format.documentInfo = pdfMetaData as [String: Any]

		let pageWidth = 595.2
		let pageHeight = 841.8
		let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

		let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
		let data = renderer.pdfData { (context) in
		  context.beginPage()
		let context = context.cgContext
			
		// Подставляем PDF шаблон с формулами
		let path = Bundle.main.path(forResource: "Marks", ofType: "pdf")!
		let url = URL(fileURLWithPath: path)
		let document = CGPDFDocument(url as CFURL)
		// Количество страниц
		let page = document?.page(at: 1)
		UIColor.white.set()
		context.translateBy(x: 0.0, y: pageRect.size.height)
		context.scaleBy(x: 1.0, y: -1.0)
		context.drawPDFPage(page!)
		}

		return data
	}
	
    // Метод генерирует лист А4 c расчетами если очаг пожара найден.
    func foundPDFCreator(appData: SettingsData) -> Data {
        // Вычисляемые значения
        let comp = Formula()
        // 1) Расчет общего времени работы (Тобщ)
        let totalTime = comp.totalTimeCalculation(minPressure: appData.enterData)
        // 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
        let expectedTime = comp.expectedTimeCalculation(inputTime: appData.enterTime, totalTime: totalTime)
        // 3) Расчет давления для выхода (Рк.вых)
        var exitPressure = comp.exitPressureCalculation(maxDrop: appData.fallPressure, hardChoice: appData.hardWork)
		// Pквых округлям при кгс и не меняем при МПа
		var exitPString = SettingsData.measureType == .kgc ? String(Int(exitPressure)) : String(format:"%.1f", floor(exitPressure * 10) / 10)
		
		if SettingsData.airSignalMode {
			if exitPressure < SettingsData.airSignal {
				exitPressure = SettingsData.airSignal
				SettingsData.airSignalFlag = true
			}
		}
	
        // 4) Расчет времени работы у очага (Траб)
        let workTime = comp.workTimeCalculation(minPressure: appData.hearthData, exitPressure: exitPressure)
        // 5) Время подачи команды постовым на выход звена
        let  exitTime = comp.expectedTimeCalculation(inputTime: appData.fireTime, totalTime: workTime)
		// Минимальное давление при включении
		let minPressure = SettingsData.measureType == .kgc ? String(Int(appData.enterData.min()!)) : String(appData.enterData.min()!)
		// Минимальне давление у очага
		let minFirePressure = SettingsData.measureType == .kgc ? String(Int(appData.hearthData.min()!)) : String(appData.hearthData.min()!)
		// Давление воздуха, необходимое для устойчивой работы редуктора
		let reductor = SettingsData.measureType == .kgc ? String(Int(SettingsData.reductionStability)) : String(SettingsData.reductionStability)
		// Объем баллона в литрах
        let capacity = String(SettingsData.cylinderVolume)
		
		let airRate = SettingsData.measureType == .kgc ? String(Int(SettingsData.airRate)) : String(SettingsData.airRate)
		
		let airIndex = String(SettingsData.airIndex)
		
		let maxFallPresure = SettingsData.measureType == .kgc ? String(Int(appData.fallPressure.max()!)) : String(format:"%.1f",appData.fallPressure.max()!)
		
		let airFlow = SettingsData.measureType == .kgc ? String(Int(SettingsData.airFlow)) : String(SettingsData.airFlow)
		
		// Номер газодымзащитника с наибольшим падением давления
		let index = appData.fallPressure.firstIndex(of: appData.fallPressure.max()!)!
		
		let startPressure = SettingsData.measureType == .kgc ? String(Int(appData.enterData[index])) : String(appData.enterData[index])
		
		let firePressure = SettingsData.measureType == .kgc ? String(Int(appData.hearthData[index])) : String(appData.hearthData[index])
		

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
			let bold = [NSAttributedString.Key.font: UIFont(name: "Charter-Bold", size: 16)!]
			let note = [NSAttributedString.Key.font: UIFont(name: "Charter", size: 12)!]

			//index
			String(index+1).draw(at: CGPoint(x: 510, y: 141), withAttributes: large)
			
			// 0
			
			var string = "= \(startPressure) - \(firePressure) = \(maxFallPresure) \(value)"
			string.draw(at: CGPoint(x: 310, y: 184), withAttributes: large)
			
			// 1
			switch SettingsData.deviceType {
				case .air:
					string = "\(airRate) * K"
					string.draw(at: CGPoint(x: 170, y: 289), withAttributes: large)
					airPressSG.draw(at: CGPoint(x: 220, y: 294), withAttributes: small)
					
					string = "\(airRate) * \(airIndex)"
					string.draw(at: CGPoint(x: 335, y: 289), withAttributes: large)
				
				case .oxigen:
					airFlow.draw(at: CGPoint(x: 205, y: 289), withAttributes: large)
					airFlow.draw(at: CGPoint(x: 365, y: 289), withAttributes: large)
			}
			string = "(\(minPressure) - \(reductor)) * \(capacity)"
			string.draw(at: CGPoint(x: 308, y: 267), withAttributes: large)
			
			string = "= \(String(format:"%.1f", totalTime)) ≈ \(Int(totalTime)) мин."
			string.draw(at: CGPoint(x: 428, y: 280), withAttributes: large)
			
			//2
			let time = DateFormatter()
            time.dateFormat = "HH"
			string = "\(time.string(from: appData.enterTime))    +    = \(expectedTime)"
			string.draw(at: CGPoint(x: 320, y: 371), withAttributes: large)
			
            time.dateFormat = "mm"
			string = "\(time.string(from: appData.enterTime))     \(Int(totalTime))"
			string.draw(at: CGPoint(x: 340, y: 368), withAttributes: small)
			
			
			// 3
			var formulaPat = ""	// шаблон
			if appData.hardWork {
				formulaPat = "P        = 2 * P            + P         "
				formulaPat.draw(at: CGPoint(x: 90, y: 478), withAttributes: bold)
				formulaPat = "к. вых                 макс. пад           уст. раб"
				formulaPat.draw(at: CGPoint(x: 98, y: 485), withAttributes: note)
				
				string = "= 2 * \(maxFallPresure) + \(reductor) = \(exitPString) \(value)"
				string.draw(at: CGPoint(x: 325, y: 478), withAttributes: large)
			} else {
				formulaPat = "P        = P            + P            /2 + P         "
				formulaPat.draw(at: CGPoint(x: 37, y: 478), withAttributes: bold)
				formulaPat = "к. вых         макс. пад         макс. пад                уст. раб"
				formulaPat.draw(at: CGPoint(x: 47, y: 485), withAttributes: note)
				
				string = "= \(maxFallPresure) + \(maxFallPresure)/2 + \(reductor) = \(exitPString) \(value)"
				string.draw(at: CGPoint(x: 344, y: 478), withAttributes: large)
			}
			
			if SettingsData.airSignalFlag {
				exitPString = SettingsData.measureType == .kgc ? String(Int(SettingsData.airSignal)) : String(format:"%.1f", floor(SettingsData.airSignal * 10) / 10)
				
				let signal = "\(exitPString) \(value)"
				signal.draw(at: CGPoint(x: 480, y: 514), withAttributes: large)
//				SettingsData.airSignalFlag = false
			}
						
			// 4
			let someValue = SettingsData.airSignalFlag ? 36 : 0
			
			switch SettingsData.deviceType {
				case .air:
					string = "\(airRate) * K"
					string.draw(at: CGPoint(x: 180, y: 582+someValue), withAttributes: large)
					airPressSG.draw(at: CGPoint(x: 228, y: 587+someValue), withAttributes: small)
					
					string = "\(airRate) * \(airIndex)"
					string.draw(at: CGPoint(x: 330, y: 582+someValue), withAttributes: large)
			
				case .oxigen:
					airFlow.draw(at: CGPoint(x: 190, y: 582+someValue), withAttributes: large)
					airFlow.draw(at: CGPoint(x: 350, y: 582+someValue), withAttributes: large)
			}
			string = "(\(minFirePressure) - \(exitPString)) * \(capacity)"
			string.draw(at: CGPoint(x: 304, y: 561+someValue), withAttributes: large)
			
			string = "= \(String(format:"%.1f", floor(workTime*10)/10)) ≈ \(Int(workTime)) мин."
			string.draw(at: CGPoint(x: 433, y: 571+someValue), withAttributes: large)
			
			// 5
			time.dateFormat = "HH"
			string = "\(time.string(from: appData.fireTime))    +    = \(exitTime)"
			string.draw(at: CGPoint(x: 310, y: 686+someValue), withAttributes: large)

			time.dateFormat = "mm"
			string = "\(time.string(from: appData.fireTime))     \(Int(workTime))"
			string.draw(at: CGPoint(x: 330, y: 681+someValue), withAttributes: small)
			
			// Имя файла PDF-шаблона
			let fileName = SettingsData.airSignalFlag ? "signal" : "airFoundNew"
			
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
    
    
    // Метод генерирует лист А4 c расчетами если очаг пожара не найден.
    func notFoundPDFCreator(appData: SettingsData) -> Data {
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
        let minPressure = SettingsData.measureType == .kgc ? String(Int(appData.enterData.min()!)) : String(appData.enterData.min()!)
		// Максимальное падение давления
		let maxDropString = SettingsData.measureType == .kgc ? (String(Int(maxDrop))) : (String(format:"%.1f", floor(maxDrop * 10) / 10))
		// Давление к выходу
		let exitPString = SettingsData.measureType == .kgc ? (String(Int(exitPressure))) : (String(format:"%.1f", exitPressure))
//		let exitPString = SettingsData.measureType == .kgc ? (String(Int(exitPressure))) : (String(format:"%.1f", floor(exitPressure * 10) / 10))
		
		
		// Давление воздуха, необходимое для устойчивой работы редуктора
        let reductor = SettingsData.measureType == .kgc ? String(Int(SettingsData.reductionStability)) : String(SettingsData.reductionStability)
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
        
		let airFlow = SettingsData.measureType == .kgc ? String(Int(SettingsData.airFlow)) : String(SettingsData.airFlow)
		
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
			var print: String
            // Координаты констант и вычисляемых значений на листе A4
            // 1
			print = "\(minPressure) - \(reductor)"
			print.draw(at: CGPoint(x: 357, y: 205), withAttributes: large)
			
            ratio.draw(at: CGPoint(x: 255, y: 225), withAttributes: large)
            ratio.draw(at: CGPoint(x: 385, y: 225), withAttributes: large)
			
			print = "= \(maxDropString) \(value)"
			print.draw(at: CGPoint(x: 435, y: 215), withAttributes: large)

            // 2
			print = "\(minPressure) - \(maxDropString) = \(exitPString) \(value)"
			print.draw(at: CGPoint(x: 350, y: 330), withAttributes: large)

            // 3
			switch SettingsData.deviceType {
				case .air:
					print = "\(airRate) * K                  \(airRate) * \(airIndex)"
					print.draw(at: CGPoint(x: 172, y: 485), withAttributes: large)
					airPressSG.draw(at: CGPoint(x: 216, y: 492), withAttributes: small)
					
				case .oxigen:
					airFlow.draw(at: CGPoint(x: 200, y: 485), withAttributes: large)
					airFlow.draw(at: CGPoint(x: 310, y: 485), withAttributes: large)
			
			}
			print = "\(maxDropString) * \(capacity)"
			print.draw(at: CGPoint(x: 283, y: 465), withAttributes: large)
			
			print = "= \(String(format:"%.1f", timeDelta)) ≈ \(Int(timeDelta)) мин."
			print.draw(at: CGPoint(x: 365, y: 475), withAttributes: large)
            
			//4
            let time = DateFormatter()
            time.dateFormat = "HH"
			print = "\(time.string(from: appData.enterTime))    +    = \(exitTime)"
			print.draw(at: CGPoint(x: 313, y: 590), withAttributes: large)
			
            time.dateFormat = "mm"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 333, y: 585), withAttributes: small)
            String(Int(timeDelta)).draw(at: CGPoint(x: 360, y: 585), withAttributes: small)

            // Подставляем PDF шаблон с формулами
			let path = Bundle.main.path(forResource: "airNotFoundNew", ofType: "pdf")!
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
