//
//  Formula.swift
//  FireCalculator
//
//  Created by Алексей on 15.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

class Formula { //:
    
    var formulaData = SettingsData()
    
      // MARK: - Функции расчетов параметров работы, если очаг найден.
        
    // 1) Расчет общего времени работы (Тобщ)
    func totalTimeCalculation(minPressure: [Double]) -> Double {

        let totalTime = (minPressure.min()! - SettingsData.reductionStability) * SettingsData.cylinderVolume / SettingsData.airFlow
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
            exitPressure = 2 * maxDrop.max()! + SettingsData.reductionStability
        } else {
            exitPressure = maxDrop.max()! + maxDrop.max()! / 2 + SettingsData.reductionStability
        }

        return exitPressure
    }

        
    // 4) Расчет времени работы у очага (Траб)
    func workTimeCalculation(minPressure: [Double], exitPressure: Double) -> Double {
        
        let workTime = (minPressure.min()! - exitPressure) * SettingsData.cylinderVolume / SettingsData.airFlow
            return workTime
        }
        

    
      // MARK: - Функции расчетов параметров работы, если очаг не найден.
    
    // 1) Расчет максимального расхода давления при поиске очага
    func maxDropCalculation(minPressure: [Double], hardChoice: Bool) -> Double {
        var hardValue = 2.5
        if hardChoice { hardValue = 3}
        let pressure = (minPressure.min()! - SettingsData.reductionStability) / hardValue
        return pressure
    }
       
       // 2) Расчет давления к выходу
    func exitPressureCalculation(minPressure: [Double], maxDrop: Double) -> Double {
       let pressure = (minPressure.min()! - maxDrop)
       return pressure
    }
       
    // 3) Расчет промежутка времени с вкл. до подачи команды дТ
    func deltaTimeCalculation(maxDrop: Double) -> Double {
        let pressure = (maxDrop * SettingsData.cylinderVolume) / SettingsData.airFlow
        return pressure
    }
}
