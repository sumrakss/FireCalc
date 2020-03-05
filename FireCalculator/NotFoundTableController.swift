//
//  NotFoundTableController.swift
//  FireCalculator
//
//  Created by Алексей on 12.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class NotFoundTableController: UITableViewController {
    
    // Время велючения
    var enterTime = Date()
    // Сложные условия true/false
    var hardWork: Bool = false
    // Падение давления в звене
    var maxDrop = [Double]()
    // Давление при включении
    var enterData = [Double]()
    // Вычисляемые значения
    var paramArray = [String]()
    


    override func viewDidLoad() {
        super.viewDidLoad()

        let comp = Formula()

        // 1) Расчет максимального возможного падения давления при поиске очага
        let maxDrop = comp.maxDropCalculation(minPressure: enterData, hardChoice: hardWork)
        paramArray.append(String(Int(maxDrop)))

        // 2) Расчет давления к выходу
        let exitPressure = comp.exitPressureCalculation(minPressure: enterData, maxDrop: maxDrop)
        paramArray.append(String(ceil(exitPressure)))

        // 3) Расчет промежутка времени с вкл. до подачи команды дТ
        let timeDelta = comp.deltaTimeCalculation(maxDrop: maxDrop)
        paramArray.append(String(format:"%.1f", timeDelta)) 

        // 4) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
        let exitTime = comp.expectedTimeCalculation(inputTime: enterTime, totalTime: timeDelta)
        paramArray.append(exitTime)


    }

    // MARK: - Table view data source
}
