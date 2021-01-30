//
//  CounterSettingsViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/30/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit

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
    
//    var name: Counter
    var name : String = ""
    //    let color : UIColor
    //    let today_count : Int
    //    let weekly_count : Int
    //    let monthly_count : Int
    
    
  

    
    override func viewDidLoad() {
          super.viewDidLoad()
          counterNameField.text = name
//        print(name.counterName)
      }
    
    @IBAction func onBackPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    
}
