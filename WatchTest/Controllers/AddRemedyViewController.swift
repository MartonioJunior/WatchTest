//
//  AddRemedyViewController.swift
//  WatchTest
//
//  Created by Ada 2018 on 26/09/2018.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit
import WatchConnectivity

class AddRemedyViewController: UIViewController  {

    @IBOutlet weak var remedyName: UITextField!
    
    @IBOutlet weak var startDate: UITextField!
    
    @IBOutlet weak var interval: UITextField!
    
    @IBOutlet weak var remedyDescription: UITextView!
    
    
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
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addNewRemedy(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let newDate = dateFormatter.date(from: startDate.text!)
        let cdRemedy = CoreDataManager.sharedManager.saveRemedy(name: remedyName.text!, remedyDescription: remedyDescription.text, startDate: newDate!, interval: Int64(interval.text!)!)
        if let remedy = cdRemedy?.asRemedy() {
            let msg = MessageWatch(eventType: Event.new, remedy : remedy)
            guard let data = try? JSONEncoder().encode(msg) else {return}
            WCSession.default.sendMessageData(data, replyHandler: nil, errorHandler: nil)
        }
        self.navigationController?.popViewController(animated: true)
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


