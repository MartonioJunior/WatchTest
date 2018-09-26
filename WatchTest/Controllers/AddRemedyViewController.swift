//
//  AddRemedyViewController.swift
//  WatchTest
//
//  Created by Ada 2018 on 26/09/2018.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit

class AddRemedyViewController: UIViewController {

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
//        Resin
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide (notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
}


