//
//  CalendarViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/31/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit

class CalendarViewController: UITableViewController {
    
//    var onSave: ((_ date:String)-> Void)?
    
    var onSave: ((_ id: Date) -> Void)?

    
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var fromField: UITextField!
    
    @IBOutlet weak var toField: UITextField!
    
    let datePicer = UIDatePicker()
    let datePicer2 = UIDatePicker()
    let datePicer3 = UIDatePicker()
    
    var date = Date()
        
   
    
    
    var selectedDateType : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateField.layer.cornerRadius = 5
        fromField.layer.cornerRadius = 5
        toField.layer.cornerRadius = 5
        
        let dateForatter = DateFormatter()
        dateForatter.dateStyle = .medium
        dateForatter.timeStyle = .none
        
        dateField.placeholder = dateForatter.string(from: Date())
        fromField.placeholder = dateForatter.string(from: Date())
        toField.placeholder = dateForatter.string(from: Date())
        
        createDatePicker()
    }
    
    func createToolbar(type: String) -> UIToolbar {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        self.selectedDateType = type
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePress))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
        
    }
    func createToolbar2(type: String) -> UIToolbar {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        self.selectedDateType = type
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePress2))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
        
    }
    func createToolbar3(type: String) -> UIToolbar {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        self.selectedDateType = type
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePress3))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
        
    }
    
    func createDatePicker(){
        
        datePicer.preferredDatePickerStyle = .wheels
        datePicer.datePickerMode = .date
        
        datePicer2.preferredDatePickerStyle = .wheels
        datePicer2.datePickerMode = .date
        
        datePicer3.preferredDatePickerStyle = .wheels
        datePicer3.datePickerMode = .date
        
        dateField.textAlignment = .center
        dateField.inputView = datePicer
        dateField.inputAccessoryView = createToolbar(type:"Date")
        
        fromField.textAlignment = .center
        fromField.inputView = datePicer2
        fromField.inputAccessoryView =  createToolbar2(type:"From")
        
        toField.textAlignment = .center
        toField.inputView = datePicer3
        toField.inputAccessoryView = createToolbar3(type:"to")
        
        
        
    }
    
    @objc func donePress(){
        let dateForatter = DateFormatter()
        dateForatter.dateStyle = .medium
        dateForatter.timeStyle = .none
        self.date = datePicer.date
        self.dateField.text = dateForatter.string(from: datePicer.date)
        self.view.endEditing(true)
        
        
    }
    
    @objc func donePress2(){
        let dateForatter = DateFormatter()
        dateForatter.dateStyle = .medium
        dateForatter.timeStyle = .none
        
        self.fromField.text = dateForatter.string(from: datePicer2.date)
        self.view.endEditing(true)
        
        
        
    }
    
    @objc func donePress3(){
        let dateForatter = DateFormatter()
        dateForatter.dateStyle = .medium
        dateForatter.timeStyle = .none
        
        self.toField.text = dateForatter.string(from: datePicer3.date)
        self.view.endEditing(true)
        
        
        
    }
    
    
    @IBAction func onDonePress(_ sender: Any) {
        
//        if dateField.text as AnyObject? !== "" as AnyObject {
//            print("empty date")
//        }
        
        print("dateField\(dateField.text)")
        self.onSave!(self.date)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onBackPress(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)
    }
}

