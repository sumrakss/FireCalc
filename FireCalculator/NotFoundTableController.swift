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
    var startTime = Date()

    var hardChoice: Bool = false    // Сложные условия true/false
    // Падение давления в звене
    var maxDrop = [Double]()
    // Давление при включении
    var enterData = [Double]()
    // Вычисляемые значения
    var paramArray = [String]()
    
    let valuesArray = ["МПа",
                    "МПа",
                    "минут",
                    "время подачи команды на выход"]
    
    let parametersImage = ["1nf.png", "2nf.png", "3nf.png", "4nf.png"]

    override func viewDidLoad() {
        super.viewDidLoad()

        let comp = Formula()

        // 1) Расчет максимального возможного падения давления при поиске очага
        let maxDrop = comp.maxDropCalculation(minPressure: enterData, hardChoice: hardChoice)
        paramArray.append(String(Int(maxDrop)))

        // 2) Расчет давления к выходу
        let exitPressure = comp.exitPressureCalculation(minPressure: enterData, maxDrop: maxDrop)
        paramArray.append(String(ceil(exitPressure)))

        // 3) Расчет промежутка времени с вкл. до подачи команды дТ
        let timeDelta = comp.deltaTimeCalculation(maxDrop: maxDrop)
        paramArray.append(String(format:"%.1f", timeDelta)) 

        // 4) Расчет контрольного времени подачи команды постовым на возвращение звена  (Тк.вых)
        let exitTime = comp.expectedTimeCalculation(inputTime: startTime, totalTime: timeDelta)
        paramArray.append(exitTime)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return paramArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        struct staticVariable { static var tableIdentifier = "TableIdentifier2" }
        
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
