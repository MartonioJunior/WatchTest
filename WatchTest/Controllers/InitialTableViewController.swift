//
//  InitialTableViewController.swift
//  WatchTest
//
//  Created by Ada 2018 on 26/09/2018.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit
import WatchConnectivity

class InitialTableViewController: UITableViewController {

//    var remedies = [[Remedy](),[Remedy]()]
    var remedies = [
        [
            Remedy.init(name: "remedio1", interval: 8, description: "teste1 remedio1", startDate: Date.init(timeIntervalSinceNow: 0), taken: false),
            Remedy.init(name: "remedio2", interval: 4, description: "teste2 remedio2", startDate: Date.init(timeIntervalSinceNow: 0), taken: false),
            Remedy.init(name: "remedio3", interval: 12, description: "teste3 remedio3", startDate: Date.init(timeIntervalSinceNow: 0), taken: false),
            Remedy.init(name: "remedio0", interval: 360, description: "teste0 remedio0", startDate: Date.init(timeIntervalSinceNow: 0), taken: false)
        ],[
            Remedy.init(name: "remedio5", interval: 12, description: "teste5 remedio5", startDate: Date.init(timeIntervalSinceNow: 0), taken: true),
            Remedy.init(name: "remedio6", interval: 8, description: "teste1 remedio1", startDate: Date.init(timeIntervalSinceNow: 0), taken: true),
            Remedy.init(name: "remedio4", interval: 6, description: "teste4 remedio4", startDate: Date.init(timeIntervalSinceNow: 0), taken: true)
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let nibRemedyCell = UINib(nibName: "RemedyTableViewCell", bundle: nil)
        tableView.register(nibRemedyCell, forCellReuseIdentifier: "RemedyCell")
        let nibReusable = UINib(nibName: "ReusableView", bundle: nil)
        tableView.register(nibReusable, forHeaderFooterViewReuseIdentifier: "ReusableView")
        
        let remedies = CoreDataManager.sharedManager.fetchRemedies()
    }

    @IBAction func addRemedyButtomPressed(_ sender: Any) {
        performSegue(withIdentifier: "New", sender: nil)
    }
    
    // MARK: - Table view data source

    //
    override func numberOfSections(in tableView: UITableView) -> Int {
        return remedies.count
    }
    
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return remedies[0].count
        } else if section == 1 {
            return remedies[1].count
        }
        return 0
    }
    
    //
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReusableView") as! ReusableView
        if section == 0 {
            header.viewTitle.text = "Agendados"
        } else if section == 1 {
            header.viewTitle.text = "Tomados"
        }
        
        return header
    }
    
    //
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ReusableView") as! ReusableView
        if section == 0 {
            footer.viewTitle.text = "Tome seu remédio em dia, isso ajuda na recuperação"
        } else {
            footer.viewTitle.text = ""
        }
        
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 80
        } else {
            return 0
        }
    }
    
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Info", sender: remedies[indexPath.section][indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemedyCell", for: indexPath) as! RemedyTableViewCell
        let remedy = remedies[indexPath.section][indexPath.row]
        cell.remedyName.text = remedy.name
        cell.accessoryType = remedy.taken ? .checkmark : .none
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            self.remedies[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let take = UITableViewRowAction(style: .default, title: "take") { action, indexPath in
//            let session = WCSessio
        }
        return indexPath.section == 0 ? [delete, take] : []
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Info" {
            let viewController = segue.destination as! RemedyInfoViewController
            let selectedRemedy = sender as! Remedy
            if selectedRemedy != nil {
                viewController.selectedRemedy = selectedRemedy
            }
        }
    }

}
