//
//  Calculate.swift
//  FireCalculator
//
//  Created by Алексей on 19.05.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

class Calculate {
	var appData: SettingsData!
	
	// MARK: - Очаг не найден
	
	let comp = Formula()
	// 1) Расчет максимального возможного падения давления при поиске очага
	let maxDrop = comp.maxDropCalculation(minPressure: appData.enterData, hardChoice: appData.hardWork)

	// 2) Расчет давления к выходу
	let exitPressure = comp.exitPressureCalculation(minPressure: appData.enterData, maxDrop: maxDrop)

	// 3) Расчет промежутка времени с вкл. до подачи команды
	let timeDelta = comp.deltaTimeCalculation(maxDrop: maxDrop)

	// 4) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
	let exitTime = comp.expectedTimeCalculation(inputTime: appData.enterTime, totalTime: timeDelta)
	
	
	// MARK: - Очаг найден
	
	// 1) Расчет общего времени работы (Тобщ)
	let totalTime = comp.totalTimeCalculation(minPressure: appData.enterData)

	// 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
	let expectedTime = comp.expectedTimeCalculation(inputTime: appData.enterTime, totalTime: totalTime)

	// 3) Расчет давления для выхода (Рк.вых)
	var exitPressure = comp.exitPressureCalculation(maxDrop: appData.fallPressure, hardChoice: appData.hardWork)
	
	// 4) Расчет времени работы у очага (Траб)
	let workTime = comp.workTimeCalculation(minPressure: appData.hearthData, exitPressure: exitPressure)
	
	// 5) Время подачи команды постовым на выход звена
	let  exitTime = comp.expectedTimeCalculation(inputTime: appData.fireTime, totalTime: workTime)
}
