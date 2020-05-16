//
//  SimpleTableViewController.swift
//  FireCalculator
//
//  Created by Алексей on 16.05.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class SimpleTableViewController: UITableViewController {
	
	var appData: SettingsData!
	var listNotFound = [String]()
	var listFound = [String]()
	let detailNotFound = ["Максимально допустимое падение давления в звене, Pмакс.пад.",
						  "Давление при котором звену необходимо начать выход из НДС, Рк.вых.",
						  "Промежуток времени с момента включения до подачи постовым команды на выход, \u{0394}T.",
						  "Время подачи постовым команды на выход, Tвых."]
	
	let detailFound = ["Общее время работы звена, Тобщ.",
					   "Ожидаемое время возвращения звена из НДС, Твозвр.",
					   "Давление при котором звену необходимо выходить из НДС, Рк.вых.",
					   "Время работы звена у очага, Траб.",
					   "Время подачи команды постовым на выход звена из НДС, Тк.вых."]
	
	let value = SettingsData.measureType == .kgc ? "кгс/см\u{00B2}" : "МПа"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		appData.firePlace ? fireFound() : fireNotFound()
    }

	func fireNotFound() {
		let comp = Formula()
		// 1) Расчет максимального возможного падения давления при поиске очага
		let maxDrop = comp.maxDropCalculation(minPressure: appData.enterData, hardChoice: appData.hardWork)

		// 2) Расчет давления к выходу
		let exitPressure = comp.exitPressureCalculation(minPressure: appData.enterData, maxDrop: maxDrop)

		// 3) Расчет промежутка времени с вкл. до подачи команды дТ
		let timeDelta = comp.deltaTimeCalculation(maxDrop: maxDrop)

		// 4) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
		let exitTime = comp.expectedTimeCalculation(inputTime: appData.enterTime, totalTime: timeDelta)


		// Максимальное падение давления
		let maxDropString = SettingsData.measureType == .kgc ? (String(Int(maxDrop))) : (String(format:"%.1f", floor(maxDrop * 10) / 10))

		// Давление к выходу
		let exitPString = SettingsData.measureType == .kgc ? (String(Int(exitPressure))) : (String(format:"%.1f", exitPressure))

		listNotFound.append("\(maxDropString) \(value)")
		listNotFound.append("\(exitPString) \(value)")
		listNotFound.append("\(Int(timeDelta)) мин.")
		listNotFound.append(exitTime)
	}
	
	func fireFound() {
		let comp = Formula()
	
		// 1) Расчет общего времени работы (Тобщ)
		let totalTime = comp.totalTimeCalculation(minPressure: appData.enterData)
	
		// 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
		let expectedTime = comp.expectedTimeCalculation(inputTime: appData.enterTime, totalTime: totalTime)
	
		// 3) Расчет давления для выхода (Рк.вых)
		let exitPressure = comp.exitPressureCalculation(maxDrop: appData.fallPressure, hardChoice: appData.hardWork)
	
		// Pквых округлям при кгс и не меняем при МПа
		let exitPString = SettingsData.measureType == .kgc ? String(Int(exitPressure)) : String(format:"%.1f", floor(exitPressure * 10) / 10)
	
		// 4) Расчет времени работы у очага (Траб)
		let workTime = comp.workTimeCalculation(minPressure: appData.hearthData, exitPressure: exitPressure)
	
		// 5) Время подачи команды постовым на выход звена
		let  exitTime = comp.expectedTimeCalculation(inputTime: appData.fireTime, totalTime: workTime)
	
		listFound.append("\(Int(totalTime)) мин.")
		listFound.append("\(expectedTime)")
		listFound.append("\(exitPString) \(value)")
		listFound.append("\(Int(workTime)) мин.")
		listFound.append("\(exitTime)")
	}
	
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return appData.firePlace ? listFound.count : listNotFound.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		if appData.firePlace {
			cell.textLabel?.text = self.listFound[indexPath.row]
			cell.detailTextLabel?.text = self.detailFound[indexPath.row]
		} else {
			cell.textLabel?.text = self.listNotFound[indexPath.row]
			cell.detailTextLabel?.text = self.detailNotFound[indexPath.row]
		}
		
		cell.detailTextLabel?.numberOfLines = 0
		cell.detailTextLabel?.textColor = .darkGray
//		cell.backgroundColor = .systemGray6
		
        return cell
    }
    

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		var headerText = ""
		if section == 0 {
			headerText = "Решение"
		}
		return headerText
	}

}
