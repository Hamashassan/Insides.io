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
            print("Export")
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
    
}
