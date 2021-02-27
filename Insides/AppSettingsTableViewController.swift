//
//  AppSettingsTableViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/27/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AppSettingsTableViewController: UITableViewController {
    
    
    let userDefault = UserDefaults()
    
    @IBOutlet weak var sendFeedbackCell: UITableViewCell!
    
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    
    let userID = Auth.auth().currentUser?.uid
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = userDefault.value(forKey: "isDark"){
            darkThemeSwitch.setOn(value as! Bool, animated: true)
        }
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        switch indexPath {
        case [1,0]:
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Canel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Reset all Counters", style: .destructive, handler:  {
                (action) in self.resetAllCounters()
            }))
            
            self.present(alert,animated: true)
            
        case [1,1]:
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Canel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete all Counters", style: .destructive, handler:  {
                (action) in self.deleteAllCounters()
            }))
            
            self.present(alert,animated: true)
            
        case [1,2]:
            self.exportCounter()
        case [2,0]:
            print("Feedback")
        case [2,1]:
            print("Privacy")
        case [3,0]:
            print("Logout")
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                resetToLogin()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        default:
            print("unknown")
        }
    }
    
    @IBAction func onDarkThemePress(_ sender: Any) {
        //        print("hi")
        //        UIApplication.shared.keyWindow.overrideUserInterfaceStyle
        
        if ((sender as AnyObject).isOn == true) {
            
            userDefault.set(true, forKey: "isDark")
            
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .dark
        } else {
            userDefault.set(false, forKey: "isDark")
            UIApplication.shared.keyWindow?.overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func onBackPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetToLogin() {
        
        let login = storyboard?.instantiateViewController(identifier: "LoginScreen") as? ViewController
        
        view.window?.rootViewController = login
        view.window?.makeKeyAndVisible()
        
    }
    
    func resetAllCounters()  {
        ref.child("users").child(userID!).child("counters").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot {
                    print("mySnap \(snap)")
                    
                    if let mainObj = snap.value as? [String: AnyObject]{
                        let id = mainObj["identifier"] as? String
                        
                        
                        let userInfoDictionary = ["counter":0] as [String : Any]
                        
                        self.ref.child("users").child(self.userID!).child("counters").child(id!).updateChildValues(userInfoDictionary)
                        
                        self.ref.child("users").child(self.userID!).child("counters").child(id!).child("countersData").removeValue()
                        //
                    }
                    
                }
                
            }
            
            
        })
        
    }
    
    func deleteAllCounters()  {
        ref.child("users").child(userID!).child("counters").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot {
                    print("mySnap \(snap)")
                    
                    if let mainObj = snap.value as? [String: AnyObject]{
                        let id = mainObj["identifier"] as? String
                        
                        
                        
                        self.ref.child("users").child(self.userID!).child("counters").child(id!).removeValue()
                        //
                    }
                    
                }
                
            }
            
            
        })
    }
    
    func exportCounter(){
        print("export")
        
        let sFileName =
        "insides.csv"
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let documentUrl = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFileName)
        
        let output = OutputStream.toMemory()
        
        let csvWrtier = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        
        csvWrtier?.writeField("Date")
        csvWrtier?.writeField("Time")
        csvWrtier?.writeField("Counter Name")
        csvWrtier?.writeField("Counter Value")
        csvWrtier?.writeField("Increment")
        csvWrtier?.finishLine()
        
        var arrOfCounter = [[String]]()
        
        
        ref.child("users").child(userID!).child("allCounters").observe(.value, with: { (snapshot) in
            
            
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
                            
                             let name = m.value["counter_name"] as! String
                            
                            arrOfCounter.append([snap.key,m.key,name,String(count),"1"])
                            
                        }
                        
                        
                        
                        
                        
                    }
                }
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
        })
        
        
        
        
        
        //
        //        arrOfCounter.append(["2021-02-27","17:20:44","4","1"])
        //        arrOfCounter.append(["2021-02-27","17:20:45","3","1"])
        //        arrOfCounter.append(["2021-02-27","17:20:46","2","1"])
        //        arrOfCounter.append(["2021-02-27","17:20:47","1","1"])
        
        
        
    }
    
}
