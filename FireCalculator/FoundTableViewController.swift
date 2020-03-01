//
//  FoundTableViewController.swift
//  FireCalculator
//
//  Created by Алексей on 10.02.2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import UIKit

class FoundTableViewController: UITableViewController {
    
    // Время велючения
    var startTime = Date()
    // Время у очага
    var hearthTime = Date()
    // Сложные условия true/false
    var hardChoice: Bool = false
    // Падение давления в звене
    var maxDrop = [Double]()
    // Давление при включении
    var enterData = [Double]()
    // Давление у очага
    var hearthData = [Double]()
    // Вычисляемые значения
    var paramArray = [String]()
    
    let valuesArray = ["минут",
                    "ожидаемое время возвращения",
                    "МПа",
                    "минут",
                    "время подачи команды постовым"]
    
    // Изображения
    let parametersImage = ["1.png", "2.png", "3.png", "4.png", "5.png"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let comp = Formula()

        // 1) Расчет общего времени работы (Тобщ)
        let totalTime = comp.totalTimeCalculation(minPressure: enterData)
        paramArray.append(String(Int(totalTime)))

        // 2) Расчет ожидаемого времени возвращения звена из НДС (Твозв)
        let expectedTime = comp.expectedTimeCalculation(inputTime: startTime, totalTime: totalTime)
        paramArray.append(expectedTime)

        // 3) Расчет давления для выхода (Рк.вых)
        let exitPressure = comp.exitPressureCalculation(maxDrop: maxDrop, hardChoice: hardChoice)
        paramArray.append(String(ceil(exitPressure)))
        
        // 4) Расчет времени работы у очага (Траб)
        let workTime = comp.workTimeCalculation(minPressure: hearthData, exitPressure: exitPressure)
        paramArray.append(String(format:"%.1f", workTime))
        
        // 5) Время подачи команды постовым на выход звена
        let  exitTime = comp.expectedTimeCalculation(inputTime: hearthTime, totalTime: workTime)
        paramArray.append(exitTime)

                
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

    }
    
     // 5) Расчет контрольного времени подачи команды постовым на возвращение звена из НДС (Тк.вых)
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // количество повторений списка
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // количество строк равно количеству элементов массива
        return paramArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Title", for: indexPath)
        
        struct staticVariable { static var tableIdentifier = "TableIdentifier" }
        
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: staticVariable.tableIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: staticVariable.tableIdentifier)
        }
        
        cell?.imageView?.image = UIImage(named: parametersImage[indexPath.row])
        cell?.textLabel?.text = paramArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell?.detailTextLabel?.text = valuesArray[indexPath.row]

        return cell
    }

    override func tableView(_ tebleView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return 60
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
