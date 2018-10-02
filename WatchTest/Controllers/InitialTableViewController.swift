//
//  InitialTableViewController.swift
//  WatchTest
//
//  Created by Ada 2018 on 26/09/2018.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit
import WatchConnectivity
import UserNotifications

class InitialTableViewController: UITableViewController {

    let localNotificationCenter = UNUserNotificationCenter.current()

    var remedies:[CDRemedy]?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        localNotificationCenter.delegate = self
        
        let nibRemedyCell = UINib(nibName: "RemedyTableViewCell", bundle: nil)
        
        tableView.register(nibRemedyCell, forCellReuseIdentifier: "RemedyCell")
        
        let nibReusable = UINib(nibName: "ReusableView", bundle: nil)
        
        tableView.register(nibReusable, forHeaderFooterViewReuseIdentifier: "ReusableView")

        remedies = CoreDataManager.sharedManager.fetchRemedies()

        for remedy in remedies! {

            print(remedy.name)

        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        remedies = CoreDataManager.sharedManager.fetchRemedies()
        localNotificationCenter.getPendingNotificationRequests(completionHandler: { (requests) in
            for request in requests {
                print(request)
            }
        })
        self.tableView.reloadData()
    }

    @IBAction func addRemedyButtomPressed(_ sender: Any) {
        performSegue(withIdentifier: "New", sender: nil)
    }
    
    // MARK: - Table view data source

    //
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return remedies!.count
        } else if section == 1 {
            return remedies!.filter({
                $0.taken
            }).count
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
        if indexPath.section == 0 {
            performSegue(withIdentifier: "Info", sender: remedies![indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RemedyCell", for: indexPath) as! RemedyTableViewCell
        let remedy = remedies![indexPath.row]
        cell.remedyName.text = remedy.name
        cell.accessoryType = remedy.taken ? .checkmark : .none
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 0 {
            return true
        } else {
            return false
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Deletar") { (action, indexPath) in
//            tableView.deleteRows(at: [indexPath], with: .fade)
            CoreDataManager.sharedManager.deleteRemedy(remedy: self.remedies![indexPath.row])
            self.remedies!.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        let delay = UITableViewRowAction(style: .default, title: "Adiar") { action, indexPath in
            //let session = WCSession
        }

        let take = UITableViewRowAction(style: .default, title: "take") { action, indexPath in
            let remedy = self.remedies![indexPath.row]
            let encoder = JSONEncoder()
            let msg = MessageWatch(eventType: .taken, remedy: remedy)
            guard let data = try? encoder.encode(msg) else {return}
            let session = WCSession.default
            if session.isReachable {
                session.sendMessageData(data, replyHandler: nil, errorHandler: nil)
            }else{
                let ok  = UIAlertAction(title: "ok", style: .default, handler: nil)
                let controller = UIAlertController(title: "alert", message: "nao mandou a mensage", preferredStyle: .alert)
                controller.addAction(ok)
                self.present(controller, animated: true, completion: nil)
            }
          }
            
        delay.backgroundColor = UIColor(red: 95/255, green: 214/255, blue: 85/255, alpha: 1)
        take.backgroundColor = UIColor(red: 253/255, green: 164/255, blue: 97/255, alpha: 1)
        
        return indexPath.section == 0 ? [delete, delay, take] : []
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
        if segue.identifier == "New" {
            let viewController = segue.destination as! AddRemedyViewController
            viewController.localNotificationCenter = self.localNotificationCenter
        }
        if segue.identifier == "Info" {
            let viewController = segue.destination as! RemedyInfoViewController
            let selectedRemedy = sender as! CDRemedy
            viewController.selectedRemedy = selectedRemedy
        }
    }

}


extension InitialTableViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print ("Tapped in notification")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print ("Notification being triggered")
        completionHandler([.alert,.sound,.badge])
    }
}

extension InitialTableViewController : WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("foi ativado")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("se tornou inativo")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("vai desativar")
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        DispatchQueue.main.async {
            guard let msg = try? JSONDecoder().decode(MessageWatch.self, from: messageData) else{return}
            switch msg.eventType {
            case .new :
                self.newRemedy(msg: msg, replyHandler: replyHandler)
            case .delay:
                self.delay(msg: msg, replyHandler: replyHandler)
            case .getAll:
                self.getAll(msg: msg, replyHandler: replyHandler)
            case .taken:
                self.didTaken(msg: msg, replyHandler: replyHandler)
            }
        }
    }
    
    
    func newRemedy(msg : MessageWatch , replyHandler : @escaping (Data) -> Void){
        
    }
    
    func delay(msg : MessageWatch , replyHandler : @escaping (Data) -> Void){
    }
    
    func getAll(msg : MessageWatch , replyHandler : @escaping (Data) -> Void){
    }
    
    func didTaken(msg : MessageWatch , replyHandler : @escaping (Data) -> Void)  {
    }
}

