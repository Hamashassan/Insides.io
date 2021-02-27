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
    
    let userID = Auth.auth().currentUser?.uid
    
    var ref: DatabaseReference!
    
    
    //    var name: Counter
    var name : String = ""
    var id : String = ""
    var count: Int  = 0
    //    let color : UIColor
    //        let today_count : Int
    //    let weekly_count : Int
    var monthly_count : Int = 0
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
        counterNameField.text = name
        //        print(name.counterName)
        
        ref.child("users").child(userID!).child("counters").child(self.id).child("countersData").observe(.value, with: { (snapshot) in
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                
                
                let today = Date()
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "dd-MM-yyyy"
                let todayDate = formatter1.string(from: today)
                //                2021-02-21
                let todayCount = snapshot.childSnapshot(forPath: todayDate).childrenCount
                self.todayLabel.text = String(todayCount)
                print("Seting shot",todayCount)
                var newlist = [String]()
                for snap in snapShot {
                    
                    if let mainObj = snap.value as? [String: AnyObject]{
                        print("mainObj \(mainObj)")
                        print("inside \(snap.value)")
                        
                        
                        
                        
                        
                        for m in mainObj {
                            print("mf\(m.value)")
                            
                            newlist.append(m.key)
                        }
                        
                        self.last7DaysLabel.text = String(newlist.count)
                        self.last30DaysLabel.text =  String(newlist.count)
                        
                    }
                }
                
            }
        })
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        switch indexPath {
        case [0,1]:
            print("Color")
        case [1,0]:
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Canel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Undo last count", style: .destructive, handler:  {
                (action) in self.undoLastCount()
            }))
            
            self.present(alert,animated: true)
            
        case [1,1]:
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Canel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Reset Counter", style: .destructive, handler:  {
                (action) in self.resetCount()
            }))
            
            self.present(alert,animated: true)
            
        case [1,2]:
            self.exportCounter()
        default:
            print("unknown")
        }
    }
    
    @IBAction func onBackPress(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSavePress(_ sender: Any) {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let counterName = counterNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let userInfoDictionary = ["identifier":self.id,"counte_name" : counterName,
            ] as [String : Any]
        
        self.ref.child("users").child(userID).child("counters").child(self.id).updateChildValues(userInfoDictionary)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func undoLastCount()  {
        
        let userInfoDictionary = ["counter":self.count - 1] as [String : Any]
        
        self.ref.child("users").child(userID!).child("counters").child(self.id).updateChildValues(userInfoDictionary)
        
    }
    
    func resetCount()  {
        
        let userInfoDictionary = ["counter":0] as [String : Any]
        
        self.ref.child("users").child(userID!).child("counters").child(self.id).updateChildValues(userInfoDictionary)
        
        self.ref.child("users").child(userID!).child("counters").child(self.id).child("countersData").removeValue()
        
    }
    
    func exportCounter(){
        print("export")
        
        let sFileName =
        "\(self.name).csv"
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let documentUrl = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFileName)
        
        let output = OutputStream.toMemory()
        
        let csvWrtier = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        
        csvWrtier?.writeField("Date")
        csvWrtier?.writeField("Time")
        csvWrtier?.writeField("Counter Value")
        csvWrtier?.writeField("Increment")
        csvWrtier?.finishLine()
        
        var arrOfCounter = [[String]]()
        
        
        
        
        ref.child("users").child(userID!).child("counters").child(self.id).child("countersData").observe(.value, with: { (snapshot) in
                
                
                if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapShot {
                        
                        if let mainObj = snap.value as? [String: AnyObject]{
                            print("mainObj \(mainObj)")
                            print("inside \(snap.value)")
                            let date = mainObj["date"] as? String
                            
                            var newlist = [String]()
                            
                            for m in mainObj {
                                print("mf\(m.value)")
                                
                                newlist.append(m.key)
                                
                                let count = m.value["count"] as! Int
                                
                                arrOfCounter.append([snap.key,m.key,String(count),"1"])
                                
                            }
                            
                            for(elements) in arrOfCounter.enumerated(){
                                  csvWrtier?.writeField((elements.element[0]))
                                  csvWrtier?.writeField((elements.element[1]))
                                  csvWrtier?.writeField((elements.element[2]))
                                  csvWrtier?.writeField((elements.element[3]))
                                  
                                  csvWrtier?.finishLine()
                              }
                              
                              csvWrtier?.closeStream()
                              
                              let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
                              
                              do{
                                  try buffer.write(to: documentUrl)
                                  
                                  let shareSheetVC = UIActivityViewController(activityItems:[documentUrl], applicationActivities:nil )
                                  
                                self.present(shareSheetVC,animated:true)
                                  
                              }catch{
                                  
                              }
                            
                            
                        
                        }
                    }
                }
            })
        
        
        
        
        
//
//        arrOfCounter.append(["2021-02-27","17:20:44","4","1"])
//        arrOfCounter.append(["2021-02-27","17:20:45","3","1"])
//        arrOfCounter.append(["2021-02-27","17:20:46","2","1"])
//        arrOfCounter.append(["2021-02-27","17:20:47","1","1"])
        
  
        
    }
    
}
