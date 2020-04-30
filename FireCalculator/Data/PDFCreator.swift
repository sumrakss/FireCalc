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
	let value = SettingsData.measureType == .kgc ? "кгс/см\u{00B2}" : "МПа"
	let airPressK = "* К"
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
        let exitPressure = comp.exitPressureCalculation(maxDrop: appData.fallPressure, hardChoice: appData.hardWork)

        // 4) Расчет времени работы у очага (Траб)
        let workTime = comp.workTimeCalculation(minPressure: appData.hearthData, exitPressure: exitPressure)

        // 5) Время подачи команды постовым на выход звена
        let  exitTime = comp.expectedTimeCalculation(inputTime: appData.fireTime, totalTime: workTime)

        // Константы из формул
//		let value = SettingsData.valueUnit ? "кгс/см\u{00B2}" : "МПа"
		// Минимальное давление при включении
		let minPressure = SettingsData.measureType == .kgc ? String(Int(appData.enterData.min()!)) : String(appData.enterData.min()!)
		// Минимальне давление у очага
		let minFirePressure = SettingsData.measureType == .kgc ? String(Int(appData.hearthData.min()!)) : String(appData.hearthData.min()!)
		// Давление воздуха, необходимое для устойчивой работы редуктора
		let reductor = SettingsData.measureType == .kgc ? String(Int(SettingsData.reductionStability)) : String(SettingsData.reductionStability)
		// Объем баллона в литрах
        let capacity = String(SettingsData.cylinderVolume)
		
		let airRate = SettingsData.measureType == .kgc ? String(Int(SettingsData.airRate)) : String(SettingsData.airRate)
		// Pквых округлям при кгс и не меняем при МПа
		let exitPString = SettingsData.measureType == .kgc ? String(Int(exitPressure)) : String(format:"%.1f", floor(exitPressure * 10) / 10)
		
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

			//index
			String(index+1).draw(at: CGPoint(x: 510, y: 141), withAttributes: large)
			
			// 0
			startPressure.draw(at: CGPoint(x: 313, y: 184), withAttributes: large)
			firePressure.draw(at: CGPoint(x: 360, y: 184), withAttributes: large)
			maxFallPresure.draw(at: CGPoint(x: 408, y: 184), withAttributes: large) //123
			value.draw(at: CGPoint(x: 442, y: 184), withAttributes: large)
			
			// 1
			switch SettingsData.deviceType {
				case .air:
					airRate.draw(at: CGPoint(x: 158, y: 289), withAttributes: large)
					airPressK.draw(at: CGPoint(x: 180, y: 289), withAttributes: large)
					airPressSG.draw(at: CGPoint(x: 207, y: 294), withAttributes: small)
					airRate.draw(at: CGPoint(x: 317, y: 289), withAttributes: large)
					"*".draw(at: CGPoint(x: 340, y: 289), withAttributes: large)
					airIndex.draw(at: CGPoint(x: 350, y: 289), withAttributes: large)
				
				case .oxigen:
					airFlow.draw(at: CGPoint(x: 175, y: 289), withAttributes: large)
					airFlow.draw(at: CGPoint(x: 335, y: 289), withAttributes: large)
			}
			
            minPressure.draw(at: CGPoint(x: 311, y: 267), withAttributes: large)
            reductor.draw(at: CGPoint(x: 353, y: 267), withAttributes: large)
			capacity.draw(at: CGPoint(x: 393, y: 267), withAttributes: large)
			String(format:"%.1f", totalTime).draw(at: CGPoint(x: 445, y: 280), withAttributes: large)
			String(Int(totalTime)).draw(at: CGPoint(x: 502, y: 280), withAttributes: large)
			
			//2
			let time = DateFormatter()
            time.dateFormat = "HH"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 320, y: 371), withAttributes: large)
            time.dateFormat = "mm"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 340, y: 368), withAttributes: small)
			String(Int(totalTime)).draw(at: CGPoint(x: 369, y: 368), withAttributes: small)
			expectedTime.draw(at: CGPoint(x: 402, y: 371), withAttributes: large)
			
			// 3
			if appData.hardWork {
				maxFallPresure.draw(at: CGPoint(x: 345, y: 478), withAttributes: large)
				maxFallPresure.draw(at: CGPoint(x: 391, y: 478), withAttributes: large)
				reductor.draw(at: CGPoint(x: 440, y: 478), withAttributes: large)
				exitPString.draw(at: CGPoint(x: 490, y: 478), withAttributes: large)
				value.draw(at: CGPoint(x: 530, y: 478), withAttributes: large)
			} else {
				maxFallPresure.draw(at: CGPoint(x: 330, y: 486), withAttributes: large)
				maxFallPresure.draw(at: CGPoint(x: 391, y: 486), withAttributes: large)
				reductor.draw(at: CGPoint(x: 432, y: 486), withAttributes: large)
				exitPString.draw(at: CGPoint(x: 468, y: 486), withAttributes: large)
				value.draw(at: CGPoint(x: 502, y: 486), withAttributes: large)
			}
			
			
			// 4
			if appData.hardWork {
				switch SettingsData.deviceType {
					case .air:
						airRate.draw(at: CGPoint(x: 148, y: 583), withAttributes: large)
						airRate.draw(at: CGPoint(x: 313, y: 583), withAttributes: large)
						airPressK.draw(at: CGPoint(x: 170, y: 583), withAttributes: large)
						airPressSG.draw(at: CGPoint(x: 195, y: 591), withAttributes: small)
						"*".draw(at: CGPoint(x: 335, y: 583), withAttributes: large)
						airIndex.draw(at: CGPoint(x: 345, y: 583), withAttributes: large)
					
					case .oxigen:
						airFlow.draw(at: CGPoint(x: 170, y: 583), withAttributes: large)
						airFlow.draw(at: CGPoint(x: 335, y: 583), withAttributes: large)
				}
				
				minFirePressure.draw(at: CGPoint(x: 276, y: 562), withAttributes: large)
				exitPString.draw(at: CGPoint(x: 318, y: 562), withAttributes: large)
				capacity.draw(at: CGPoint(x: 373, y: 562), withAttributes: large)
				String(format:"%.1f", workTime).draw(at: CGPoint(x: 423, y: 575), withAttributes: large)
				String(Int(workTime)).draw(at: CGPoint(x: 481, y: 575), withAttributes: large)
			} else {
				switch SettingsData.deviceType {
					case .air:
						airRate.draw(at: CGPoint(x: 138, y: 597), withAttributes: large)
						airRate.draw(at: CGPoint(x: 296, y: 597), withAttributes: large)
						airPressK.draw(at: CGPoint(x: 160, y: 597), withAttributes: large)
						airPressSG.draw(at: CGPoint(x: 185, y: 602), withAttributes: small)
						"*".draw(at: CGPoint(x: 318, y: 597), withAttributes: large)
						airIndex.draw(at: CGPoint(x: 328, y: 597), withAttributes: large)
				
					case .oxigen:
						airFlow.draw(at: CGPoint(x: 160, y: 595), withAttributes: large)
						airFlow.draw(at: CGPoint(x: 318, y: 595), withAttributes: large)
				}
				minFirePressure.draw(at: CGPoint(x: 268, y: 576), withAttributes: large)
				exitPString.draw(at: CGPoint(x: 312, y: 576), withAttributes: large)
				capacity.draw(at: CGPoint(x: 360, y: 576), withAttributes: large)
				String(format:"%.1f", workTime).draw(at: CGPoint(x: 410, y: 588), withAttributes: large)
				String(Int(workTime)).draw(at: CGPoint(x: 470, y: 588), withAttributes: large)
			}
			
			// 5
			if appData.hardWork {
				time.dateFormat = "HH"
				time.string(from: appData.fireTime).draw(at: CGPoint(x: 310, y: 690), withAttributes: large)
				time.dateFormat = "mm"
				time.string(from: appData.fireTime).draw(at: CGPoint(x: 330, y: 685), withAttributes: small)
				String(Int(workTime)).draw(at: CGPoint(x: 358, y: 685), withAttributes: small)
				exitTime.draw(at: CGPoint(x: 403, y: 690), withAttributes: large)
			} else {
				time.dateFormat = "HH"
				time.string(from: appData.fireTime).draw(at: CGPoint(x: 314, y: 702), withAttributes: large)
				time.dateFormat = "mm"
				time.string(from: appData.fireTime).draw(at: CGPoint(x: 335, y: 699), withAttributes: small)
				String(Int(workTime)).draw(at: CGPoint(x: 362, y: 699), withAttributes: small)
				exitTime.draw(at: CGPoint(x: 392, y: 702), withAttributes: large)
			}
			
			// Подставляем PDF шаблон с формулами
			let path = appData.hardWork ? Bundle.main.path(forResource: "hardAirFoundNew", ofType: "pdf")! : Bundle.main.path(forResource: "airFoundNew", ofType: "pdf")!
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
		let exitPString = SettingsData.measureType == .kgc ? (String(Int(exitPressure))) : (String(format:"%.1f", floor(exitPressure * 10) / 10))
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

            // Координаты констант и вычисляемых значений на листе A4
            // 1
            minPressure.draw(at: CGPoint(x: 355, y: 205), withAttributes: large)
            reductor.draw(at: CGPoint(x: 405, y: 205), withAttributes: large)
            ratio.draw(at: CGPoint(x: 255, y: 225), withAttributes: large)
            ratio.draw(at: CGPoint(x: 385, y: 225), withAttributes: large)
            maxDropString.draw(at: CGPoint(x: 445, y: 215), withAttributes: large)
			value.draw(at: CGPoint(x: 488, y: 215), withAttributes: large)

            // 2
            minPressure.draw(at: CGPoint(x: 348, y: 330), withAttributes: large)
            maxDropString.draw(at: CGPoint(x: 395, y: 330), withAttributes: large)
            exitPString.draw(at: CGPoint(x: 443, y: 330), withAttributes: large)
			value.draw(at: CGPoint(x: 488, y: 330), withAttributes: large)

            // 3
			switch SettingsData.deviceType {
				case .air:
					airRate.draw(at: CGPoint(x: 172, y: 485), withAttributes: large)
					airPressK.draw(at: CGPoint(x: 190, y: 485), withAttributes: large)
					airPressSG.draw(at: CGPoint(x: 216, y: 492), withAttributes: small)
					airRate.draw(at: CGPoint(x: 292, y: 485), withAttributes: large)
					"*".draw(at: CGPoint(x: 312, y: 485), withAttributes: large)
					airIndex.draw(at: CGPoint(x: 323, y: 485), withAttributes: large)
				case .oxigen:
					airFlow.draw(at: CGPoint(x: 200, y: 485), withAttributes: large)
					airFlow.draw(at: CGPoint(x: 310, y: 485), withAttributes: large)
			
			}
            maxDropString.draw(at: CGPoint(x: 283, y: 465), withAttributes: large)
            capacity.draw(at: CGPoint(x: 325, y: 465), withAttributes: large)
            String(format:"%.1f", timeDelta).draw(at: CGPoint(x: 370, y: 475), withAttributes: large)
			String(Int(timeDelta)).draw(at: CGPoint(x: 426, y: 475), withAttributes: large)
            
//             4
            let time = DateFormatter()
            time.dateFormat = "HH"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 313, y: 590), withAttributes: large)
            time.dateFormat = "mm"
            time.string(from: appData.enterTime).draw(at: CGPoint(x: 333, y: 585), withAttributes: small)
            String(Int(timeDelta)).draw(at: CGPoint(x: 360, y: 585), withAttributes: small)
            exitTime.draw(at: CGPoint(x: 400, y: 590), withAttributes: large)

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
