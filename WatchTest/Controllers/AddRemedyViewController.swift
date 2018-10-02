//
//  AddRemedyViewController.swift
//  WatchTest
//
//  Created by Ada 2018 on 26/09/2018.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit
import UserNotifications

class AddRemedyViewController: UIViewController {

    @IBOutlet weak var remedyName: UITextField!
    
    @IBOutlet weak var startDate: UITextField!
    
    @IBOutlet weak var interval: UITextField!
    
    @IBOutlet weak var remedyDescription: UITextView!
    
    var localNotificationCenter: UNUserNotificationCenter?
    
    var accessoryToolbar: UIToolbar {
        
        get {
            let toolbarFrame = CGRect(x: 0, y: 0,
                                      width: view.frame.width, height: 44)
            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonTapped(sender:)))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            accessoryToolbar.items = [flexibleSpace, doneButton]
            accessoryToolbar.barTintColor = UIColor.white
            return accessoryToolbar
        }
        
    }
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .white
        startDate.inputView = datePicker
        startDate.inputAccessoryView = accessoryToolbar
        
//        Border in TextView
        remedyDescription.layer.borderColor = UIColor.lightGray.cgColor
        remedyDescription.layer.borderWidth = 0.5
        remedyDescription.layer.cornerRadius = 15
        
//        Resizing View.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        //            Ver todas as notificações.
        
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func createNewNotification(initialDate: Date, remedyFrequency: Double, remedyName: String, remedyDescription: String) {
        
        for times in 0...(Int(remedyFrequency) - 1) {
            let frequencyInterval = ((86400/remedyFrequency)*Double(times))
            let date = Date.init(timeInterval: frequencyInterval, since: initialDate)
            //        Conteudo da notificação.
            let content = UNMutableNotificationContent()
            content.title = remedyName
            content.body = remedyDescription
            content.sound = UNNotificationSound.default()
            
            //        Trigger para a notificação, baseado na data.
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            
            let identifier = "\(remedyName) - \(times) - \(Date.init(timeIntervalSinceNow: 0))"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            localNotificationCenter?.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print (error)
                }
            })

        }

    }
    
    func requestNotificationAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        localNotificationCenter?.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            } else {
                self.localNotificationCenter?.getNotificationSettings {
                    (settings) in
                    if settings.authorizationStatus != .authorized {
                        print("teste")
                    } else {
                        DispatchQueue.main.async {
                            self.saveRemedyToDB()
                        }
                    }
                }
            }
        }
    }
    
    func saveRemedyToDB() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let newDate = dateFormatter.date(from: startDate.text!)
        CoreDataManager.sharedManager.saveRemedy(name: remedyName.text!, remedyDescription: remedyDescription.text, startDate: newDate!, interval: Int64(interval.text!)!)
        
        let frequency = 24/(Int64(interval.text!)!)
        print(frequency)
        
        createNewNotification(initialDate: newDate!, remedyFrequency: Double(frequency), remedyName: remedyName.text!, remedyDescription: remedyDescription.text)
        
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewRemedy(_ sender: Any) {
        requestNotificationAuthorization()
    }
    
    @objc func onDoneButtonTapped(sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let formatedDate = dateFormatter.string(from: datePicker.date)
        startDate.text = formatedDate
        startDate.resignFirstResponder()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow (notification: NSNotification) {
        print(remedyDescription.isFirstResponder)
        if remedyDescription.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide (notification: NSNotification) {
        if remedyDescription.isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    print(keyboardSize)
                    self.view.frame.origin.y = 0
                }
            }
        }
    }
}


