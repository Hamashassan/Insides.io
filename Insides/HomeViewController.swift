//
//  HomeViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/25/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    
    
    var counters : [Counter] = []
    
    var ref = Database.database().reference()
    
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.backgroundView = nil;
        tableView?.isOpaque = false;
        tableView?.backgroundColor = .clear
        
        
        
        print("userID \(userID!)")
        
        ref.child("users").child(userID!).child("counters").observe(.value, with: { (snapshot) in
            
            //        self.ref.child("users").observe(.value, with: { (snapshot) in
            
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                self.counters.removeAll()
                for snap in snapShot {
                    print("mySnap \(snap)")
                    if let mainObj = snap.value as? [String: AnyObject]{
                        let id = mainObj["identifier"] as? String
                        let counterName = mainObj["counte_name"] as? String
                        let counter = mainObj["counter"] as? Int
                        let color = mainObj["counter_color"] as? String
                        
                        self.counters.append(Counter.init(id: id ?? "", counterName: counterName ?? "", count: counter ?? 0, counterColor: .blue))
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
            
            
        })
        { (error) in
            print(error.localizedDescription)
        }
        
        
        //        self.counters = createCounters()
        
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    //    func createCounters() -> [Counter] {
    //        var temp : [Counter] = []
    //
    //        let counter1 id: UUID, = Counter.init(counterName: "Counter Name", count: 0, counterColor: .green)
    //
    //        let counter2 = Coid: <#UUID#>, unter.init(counterName: "Counter Name 2", count: 0, counterColor: .blue)
    //
    //        let counter3 = Counteid: <#UUID#>, r.init(counterName: "Counter Name 3", count: 0, counterColor: .red)
    //
    //        temp.append(counter1)
    //        temp.append(counter2)
    //        temp.append(counter3)
    //
    //        return temp
    //
    //
    //    }
    
    
    
    @IBAction func didTapButton(){
        
        let vc = storyboard?.instantiateViewController(identifier: "CreateCounter") as! AddCounterViewController
        vc.modalPresentationStyle = .formSheet
        present(vc,animated: true)
        
        //          let vc = storyboard?.instantiateViewController(identifier: "CreateCounter") as! AddCounterViewController
        //        let navController = UINavigationController(rootViewController: vc) // Creating a navigation controller with VC1 at the root of the navigation stack.
        //        self.present(navController, animated:true, completion: nil)
    }
    
    @IBAction func onAppSettingsPress(){
        //           let vc = storyboard?.instantiateViewController(identifier: "AppSettings") as! AppSettingsTableViewController
        //
        //           vc.modalPresentationStyle = .formSheet
        //           vc.title = "Create Counter"
        //
        //           present(vc,animated: true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let counter = self.counters[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CounterCell") as! CounterCell
        
        cell.counterButton.tag = indexPath.row
        cell.counterButton.addTarget(self, action: #selector(onCounterButtonPress(sender:)), for: .touchUpInside)
        
        
        
        cell.counterSettingButton.tag = indexPath.row
        cell.counterSettingButton.addTarget(self, action: #selector(onCounterSettingsPress), for: .touchUpInside)
        
        
        
        cell.setCounter(counter: counter)
        
        //        Cell Style
        
        //        cell.backgroundColor = UIColor.systemBackground
        cell.layer.borderColor = UIColor.black.cgColor
        //        cell.layer.borderWidth = 1
        
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        
        return cell
    }
    
    
    
    
    
    @objc func onCounterButtonPress(sender: UIButton){
        
        let counter = self.counters[sender.tag]
        
        dump("mycounter \(counter.id)")
        
        let userInfoDictionary = ["counter":counter.count + 1] as [String : Any]
        
        self.ref.child("users").child(userID!).child("counters").child(counter.id).updateChildValues(userInfoDictionary)
        
        print()
    }
    
    @objc func onCounterSettingsPress(sender: UIButton){
        
        let counter = self.counters[sender.tag]
        
        dump("mycounter \(counter.counterName)")
        
        let vc = storyboard?.instantiateViewController(identifier: "CounterSettings") as! CounterSettingsViewController
        
        vc.name = counter.counterName
//        vc.name = counter
        //        vc.reciv
//        let vc = CounterSettingsViewController(name:"Hello")
        vc.modalPresentationStyle = .formSheet
        present(vc,animated: true)
        
        //         let userInfoDictionary = ["counter":counter.count + 1] as [String : Any]
        //
        //         self.ref.child("users").child(userID!).child("counters").child(counter.id).updateChildValues(userInfoDictionary)
        //
        //         print()
    }
    
    
    
}
