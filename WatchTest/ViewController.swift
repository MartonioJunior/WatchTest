//
//  ViewController.swift
//  WatchTest
//
//  Created by ifce on 25/09/18.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var remedies = [Remedy]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Agendados"
        } else if section == 1 {
            return "Tomados"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Tome seu remédio em dia, isso ajuda na recuperação"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return remedies.count
        } else if section == 1 {
            return remedies.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "New", sender: remedies[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Remedy", for: indexPath) as! UITableViewCell
        let remedy = remedies[indexPath.row]
        cell.textLabel?.text = remedy.name
        cell.accessoryType = remedy.taken ? .checkmark : .none
        return cell
    }
}
