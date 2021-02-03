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

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var segmentTab: UISegmentedControl!
    

    
    @IBOutlet weak var bottomDetailView: UIView!
    
    
    var counters : [Counter] = []
    
    var ref = Database.database().reference()
    
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.backgroundView = nil;
        tableView?.isOpaque = false;
        tableView?.backgroundColor = .clear
        
     
        bottomDetailView.layer.cornerRadius = 20
        bottomDetailView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        bottomDetailView.layer.shadowColor = UIColor.black.cgColor
        bottomDetailView.layer.shadowOpacity = 0.5
        bottomDetailView.layer.shadowOffset = .zero
        bottomDetailView.layer.shadowRadius = 3
        
        
//        bottomDetailView.backgroundColor = .red
        
//        segmentTab.bo
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
//        navigationController?.title = "hi"
        
//
//
//        let titles = ["All", "Missed"]
//       var segmentControl = UISegmentedControl(items: titles)
//        segmentControl.tintColor = UIColor.white
//        segmentControl.backgroundColor = UIColor.blue
//        segmentControl.selectedSegmentIndex = 0
//        for index in 0...titles.count-1 {
//            segmentControl.setWidth(60, forSegmentAt: index)
//        }
//        segmentControl.sizeToFit()
////        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
//        segmentControl.selectedSegmentIndex = 0
//        segmentControl.sendActions(for: .valueChanged)
//        navigationItem.titleView = segmentControl
////        navigationController?.navigationBar.barTintColor = UIColor.init(named: "backgroundColor")
//
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.layoutIfNeeded()
//
//        let add = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onAddCounter))
//          let play = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddCounter))
//        navigationItem.rightBarButtonItems = [add]
//        navigationItem.leftBarButtonItem = play

        
        
        
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
    
    
    @objc func onAddCounter(){
        let vc = storyboard?.instantiateViewController(identifier: "CreateCounter") as! AddCounterViewController
             vc.modalPresentationStyle = .formSheet
             present(vc,animated: true)
    }
    
    
    
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
        
         print("indexPath \(indexPath)")
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 12

        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
       
        
        let vc = storyboard?.instantiateViewController(identifier:
            "DetailsScreen") as! DetailsViewController
        
        
        
        print("Working fvcf \(navigationController)")
        
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        //        vc.name = counter.counterName
        //        vc.id = counter.id
        //        vc.name = counter
        //        vc.reciv
        //        let vc = CounterSettingsViewController(name:"Hello")
        //        vc.modalPresentationStyle = .formSheet
        //        present(vc,animated: true)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func incrementCounter(id:String){
        
        print("called from siri \(id)")
        
//        let id2 =  "258D98B7-0B56-4567-8F72-6D0E6FE1C158"
        
        ref.child("users").child(userID!).child("counters").child(id).observeSingleEvent(of: .value, with: { (snap) in
            
            if let mainObj = snap.value as? [String: AnyObject]{
                let count = mainObj["counter"] as? Int
                
                let userInfoDictionary = ["counter":count! + 1] as [String : Any]
                
                self.ref.child("users").child(self.userID!).child("counters").child(id).updateChildValues(userInfoDictionary)
                
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    @objc func onCounterButtonPress(sender: UIButton){
        
        
        let counter = self.counters[sender.tag]
        
        dump("mycounter \(counter.id)")
        
        
        
        let userInfoDictionary = ["counter":counter.count + 1] as [String : Any]
        
        self.ref.child("users").child(userID!).child("counters").child(counter.id).updateChildValues(userInfoDictionary)
        
        
        
    }
    
    
    @objc func onCounterSettingsPress(sender: UIButton){
        
        let counter = self.counters[sender.tag]
        
        dump("mycounter \(counter.counterName)")
        
        let vc = storyboard?.instantiateViewController(identifier: "CounterSettings") as! CounterSettingsViewController
        
        vc.name = counter.counterName
        vc.id = counter.id
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
