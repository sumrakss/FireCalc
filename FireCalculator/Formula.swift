//
//  Formula.swift
//  FireCalculator
//
//  Created by Алексей on 15.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

class Formula {
    
    // Объем баллона
    let tankVolume = 8.0
    // Коэффициент расхода воздуха
    let airFlow = 44.0
    // давление воздуха (кислорода), необходимое для устойчивой работы редуктора
    let reductionStability = 10.0
    
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
        
        
    // 5) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
//    func exitTimeCalculation(inputTime: Date, workTime: Double) -> String {
//
//            let time = DateFormatter()
//            time.dateFormat = "HH:mm"
//
//            let exitTime = time.string(from: (inputTime + workTime))
//            return exitTime
//        }
    
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
        let pressure = (maxDrop * tankVolume) / airFlow
        return pressure
    }
}
