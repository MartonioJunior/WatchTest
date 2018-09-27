//
//  RemedyInfoViewController.swift
//  WatchTest
//
//  Created by Ada 2018 on 27/09/2018.
//  Copyright © 2018 ifce. All rights reserved.
//

import UIKit

class RemedyInfoViewController: UIViewController {

    var selectedRemedy: Remedy?
    
    @IBOutlet weak var remedyNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var remedyDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let remedy = selectedRemedy {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM -> HH:mm"
            remedyNameLabel.text = remedy.name
            startDateLabel.text = dateFormatter.string(from: remedy.startDate)
            intervalLabel.text = "\(remedy.interval)h"
            remedyDescriptionTextView.text = remedy.remedyDescription
        } else {
            remedyNameLabel.text = "---"
            startDateLabel.text = "---"
            intervalLabel.text = "---"
            remedyDescriptionTextView.text = ""
        }
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Actions
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takeRemedyButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func delayRemedyButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
