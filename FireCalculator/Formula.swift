//
//  Formula.swift
//  FireCalculator
//
//  Created by Алексей on 15.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

class Formula: DataDelegate {
//	let vc = SettingsTableController()
    // Объем баллона
	var tankVolume = 7.0
    // Коэффициент расхода воздуха
    var airFlow = 44.0
    // давление воздуха, необходимое для устойчивой работы редуктора
    let reductionStability = 10.0
    
    func transferData(data: Double) {
        tankVolume = data
    }

    
    init() {
        let vc = SettingsTableController()
        vc.delegate = self
	}
    
      // MARK: - Функции расчетов параметров работы, если очаг найден.
        
    // 1) Расчет общего времени работы (Тобщ)
    func totalTimeCalculation(minPressure: [Double]) -> Double {

		let totalTime = (minPressure.min()! - reductionStability) * tankVolume / airFlow
        return totalTime
    }
        
        
    // 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
    func expectedTimeCalculation(inputTime: Date, totalTime: Double) -> String {

        let time = DateFormatter()
        time.dateFormat = "HH:mm"

        let strDate = time.string(from: (inputTime + totalTime * 60))
        return strDate
    }
        
        
    // 3) Расчет давления для выхода (Рк.вых)
    func exitPressureCalculation(maxDrop: [Double], hardChoice: Bool) -> Double {

        let exitPressure: Double

        if hardChoice {
            exitPressure = 2 * maxDrop.max()! + reductionStability
        } else {
            exitPressure = maxDrop.max()! + maxDrop.max()! / 2 + reductionStability
        }

        return exitPressure
    }

        
    // 4) Расчет времени работы у очага (Траб)
    func workTimeCalculation(minPressure: [Double], exitPressure: Double) -> Double {

		let workTime = (minPressure.min()! - exitPressure) * tankVolume / airFlow
            return workTime
        }
        

    
      // MARK: - Функции расчетов параметров работы, если очаг не найден.
    
    // 1) Расчет максимального расхода давления при поиске очага
    func maxDropCalculation(minPressure: [Double], hardChoice: Bool) -> Double {
            
           var hardValue = 2.5
           if hardChoice { hardValue = 3}
		   let pressure = (minPressure.min()! - reductionStability) / hardValue
           return pressure
       }
       
       // 2) Расчет давления к выходу
    func exitPressureCalculation(minPressure: [Double], maxDrop: Double) -> Double {
           let pressure = (minPressure.min()! - maxDrop)
           return pressure
       }
       
    // 3) Расчет промежутка времени с вкл. до подачи команды дТ
    func deltaTimeCalculation(maxDrop: Double) -> Double {
        let vc = SettingsTableController()
        vc.delegate = self
        print("deltaTimeCalculation")
		let pressure = (maxDrop * tankVolume) / airFlow
        return pressure
    }
}
