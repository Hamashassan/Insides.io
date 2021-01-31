//
//  CounterSettingsViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/30/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CounterSettingsViewController: UITableViewController {
    
    
    @IBOutlet weak var counterNameField: UITextField!
    
    @IBOutlet weak var colorCell: UITableViewCell!
    
    @IBOutlet weak var undoCell: UITableViewCell!
    
    @IBOutlet weak var resetCell: UITableViewCell!
    
    @IBOutlet weak var exportCell: UITableViewCell!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var last7DaysLabel: UILabel!
    
    @IBOutlet weak var last30DaysLabel: UILabel!
    
    @IBOutlet weak var counterHistoryCell: UITableViewCell!
    
    var ref: DatabaseReference!
    
    
    //    var name: Counter
    var name : String = ""
    var id : String = ""
    //    let color : UIColor
    //    let today_count : Int
    //    let weekly_count : Int
    //    let monthly_count : Int
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
        counterNameField.text = name
        //        print(name.counterName)
        
        
    }
    
    @IBAction func onBackPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSavePress(_ sender: Any) {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let counterName = counterNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let userInfoDictionary = ["identifier":self.id,"counte_name" : counterName,
                                  "counter_color" : "UIColor.red"] as [String : Any]
        
        self.ref.child("users").child(userID).child("counters").child(self.id).updateChildValues(userInfoDictionary)
        
        dismiss(animated: true, completion: nil)
    }
    
}
