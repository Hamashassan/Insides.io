//
//  FirebaseHelper.swift
//  Insides
//
//  Created by Hamas Hassan on 3/2/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import os.log

import Firebase

class FirebaseHelper {
    
    init() {
        
    }
    
    static func getAllCounters(completionHandler:@escaping (_ songArray: [String]?)->()){
        FirebaseApp.configure()
        
        let ref = Database.database().reference()
        
        //                let userID = "lpfrCtFks1TbfQolvuRuP7RP8IH2"
        //                let userID = Auth.auth().currentUser?.uid ?? "abcd"
        
        //        let userDefaults = UserDefaults.standard
        
        //        let userID = userDefaults.object(forKey: "userId") as? String ?? String()
        
        //        os_log("userID %@",userID!)
        
        //        var countersName = [String]()
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.insides.io")
        
        guard let userID = sharedDefaults?.string(forKey: "userID") else { return }
        
        os_log("in getAllCounters userID %@",userID)
        
        
        ref.child("users").child(userID).child("counters").observe(.value, with: { (snapshot) in
            
            //        self.ref.child("users").observe(.value, with: { (snapshot) in
            
            var newList = [String]()
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot {
                    print("mySnap \(snap)")
                    
                    if let mainObj = snap.value as? [String: AnyObject]{
                        //                        let id = mainObj["identifier"] as? String
                        let counterName = mainObj["counte_name"] as? String
                        //                        let counter = mainObj["counter"] as? Int
                        //                        let color = mainObj["counter_color"] as? String
                        os_log("Firebase counter %@",counterName as! CVarArg)
                        newList.append(counterName!)
                        
                    }
                    
                }
                
            }
            
            if newList.isEmpty {
                completionHandler(nil)
            }else {
                completionHandler(newList)
            }
            
        })
        
        
        
        
        
        
        
        
        //        return countersName
        
    }
    
    static func findCounterByName(name:String,completionHandler:@escaping (_ songArray: String)->()){
        
        FirebaseApp.configure()
        
        let ref = Database.database().reference()
        
        //        let userDefaults = UserDefaults.standard
        
        //        let userID = userDefaults.object(forKey: "userId") as? String
        
        //        os_log("userID %@",userID as! CVarArg)
        
        //        let userID = Auth.auth().currentUser?.uid
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.insides.io")
        
        guard let userID = sharedDefaults?.string(forKey: "userID") else { return }
        
        var counterId = ""
        
        
        ref.child("users").child(userID).child("counters").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapShot {
                    print("mySnap \(snap)")
                    
                    if let mainObj = snap.value as? [String: AnyObject]{
                        
                        let counterName = mainObj["counte_name"] as? String
                        
                        if(name as AnyObject === counterName as AnyObject?){
                            let id = mainObj["identifier"] as? String
                            
                            counterId = id!
                        }
                    }
                }
            }
            completionHandler(counterId)
        })
        
        
        
        
    }
    
    
    
    
    static func incrementCounter(id:String){
        
        FirebaseApp.configure()
        
        let ref = Database.database().reference()
        
        //        let userID = Auth.auth().currentUser?.uid
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.insides.io")
        
        guard let userID = sharedDefaults?.string(forKey: "userID") else { return }
        
        
        //        let userID = "lpfrCtFks1TbfQolvuRuP7RP8IH2"
        
        //        let userDefaults = UserDefaults.standard
        //
        //        let userID = userDefaults.object(forKey: "userId") as? String
        //
        //        let userID = Auth.auth().currentUser?.uid
        //
        print("called from siri \(id)")
        
        
        ref.child("users").child(userID).child("counters").child(id).observeSingleEvent(of: .value, with: { (snap) in
            
            if let mainObj = snap.value as? [String: AnyObject]{
                let count = mainObj["counter"] as? Int
                
                let userInfoDictionary = ["counter":count! + 1] as [String : Any]
                
                ref.child("users").child(userID).child("counters").child(id).updateChildValues(userInfoDictionary)
                
                let parentDate = Date()
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "dd-MM-yyyy"
                let myparentDate = formatter1.string(from: parentDate)
                
                let today = Date()
                let formatter2 = DateFormatter()
                formatter2.dateFormat = "hh:mm:ss a"
                let mydate = formatter2.string(from: today)
                print("mydate \(mydate)")
                
                let dateData = ["date":mydate,"count":count! + 1] as [String : Any]
                
                
                ref.child("users").child(userID).child("counters").child(id).child("countersData")
                    .child(myparentDate).child(mydate).setValue(dateData)
                
                
                
            }
            
        })};
    
    
    
}





