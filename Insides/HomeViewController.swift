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
    
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var bottomDetailView: UIView!
    
    var dragInitialIndexPath: IndexPath?
    var dragCellSnapshot: UIView?
    
    
    var counters : [Counter] = []
    
    var ref = Database.database().reference()
    
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //         window?.overrideUserInterfaceStyle = .dark
        
        //        view.overrideUserInterfaceStyle = .dark
        
        tableView?.backgroundView = nil;
        tableView?.isOpaque = false;
        tableView?.backgroundColor = .clear
        //        tableView.isEditing = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
        longPress.minimumPressDuration = 0.2 // optional
        tableView.addGestureRecognizer(longPress)
        
        
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
            var total = 0
            var snaps = 0
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                self.counters.removeAll()
                for snap in snapShot {
                    print("mySnap \(snap)")
                    
                    if let mainObj = snap.value as? [String: AnyObject]{
                        let id = mainObj["identifier"] as? String
                        let counterName = mainObj["counte_name"] as? String
                        let counter = mainObj["counter"] as? Int
                        let color = mainObj["counter_color"] as? String
                        
                        total = total + counter!
                        snaps = snaps + 1
                        
                        
                        self.counters.append(Counter.init(id: id ?? "", counterName: counterName ?? "", count: counter ?? 0, counterColor: self.hexStringToUIColor(hex: color!) ))
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
            print("XX total XX",snaps)
            if snaps > 0 {
                self.totalLabel.text = "Total: \(total), Average: \(total/snaps)"
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
    @IBAction func infoButton(_ sender: Any) {
        //        let counterId = self.counters[indexPath.row].id
        
        let vc = storyboard?.instantiateViewController(identifier:
            "InfoScreen") as! InfoViewController
        
        //        vc.counterId = counterId
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func onLongPressGesture(sender: UILongPressGestureRecognizer) {
          let locationInView = sender.location(in: tableView)
          let indexPath = tableView.indexPathForRow(at: locationInView)
          
          if sender.state == .began {
              if indexPath != nil {
                  dragInitialIndexPath = indexPath
                  let cell = tableView.cellForRow(at: indexPath!)
                  dragCellSnapshot = snapshotOfCell(inputView: cell!)
                  var center = cell?.center
                  dragCellSnapshot?.center = center!
                  dragCellSnapshot?.alpha = 0.0
                  tableView.addSubview(dragCellSnapshot!)
                  
                  UIView.animate(withDuration: 0.25, animations: { () -> Void in
                      center?.y = locationInView.y
                      self.dragCellSnapshot?.center = center!
                      self.dragCellSnapshot?.transform = (self.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
                      self.dragCellSnapshot?.alpha = 0.99
                      cell?.alpha = 0.0
                  }, completion: { (finished) -> Void in
                      if finished {
                          cell?.isHidden = true
                      }
                  })
              }
          } else if sender.state == .changed && dragInitialIndexPath != nil {
              var center = dragCellSnapshot?.center
              center?.y = locationInView.y
              dragCellSnapshot?.center = center!
              
              // to lock dragging to same section add: "&& indexPath?.section == dragInitialIndexPath?.section" to the if below
              if indexPath != nil && indexPath != dragInitialIndexPath {
                  // update your data model
                  let dataToMove = counters[dragInitialIndexPath!.row]
                  counters.remove(at: dragInitialIndexPath!.row)
                  counters.insert(dataToMove, at: indexPath!.row)
                  
                  tableView.moveRow(at: dragInitialIndexPath!, to: indexPath!)
                  dragInitialIndexPath = indexPath
              }
          } else if sender.state == .ended && dragInitialIndexPath != nil {
              let cell = tableView.cellForRow(at: dragInitialIndexPath!)
              cell?.isHidden = false
              cell?.alpha = 0.0
              UIView.animate(withDuration: 0.25, animations: { () -> Void in
                  self.dragCellSnapshot?.center = (cell?.center)!
                  self.dragCellSnapshot?.transform = CGAffineTransform.identity
                  self.dragCellSnapshot?.alpha = 0.0
                  cell?.alpha = 1.0
              }, completion: { (finished) -> Void in
                  if finished {
                      self.dragInitialIndexPath = nil
                      self.dragCellSnapshot?.removeFromSuperview()
                      self.dragCellSnapshot = nil
                  }
              })
          }
      }
      
      func snapshotOfCell(inputView: UIView) -> UIView {
          UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
          inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
          let image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          
          let cellSnapshot = UIImageView(image: image)
          cellSnapshot.layer.masksToBounds = false
          cellSnapshot.layer.cornerRadius = 0.0
          cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
          cellSnapshot.layer.shadowRadius = 5.0
          cellSnapshot.layer.shadowOpacity = 0.4
          return cellSnapshot
      }
    
}

extension HomeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.counters.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    
    
    
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
        cell.layer.borderColor = UIColor.black.cgColor
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
        
        
        let counterId = self.counters[indexPath.row].id
        
        let counter = self.counters[indexPath.row].count
        
        let vc = storyboard?.instantiateViewController(identifier:
            "DetailsScreen") as! DetailsViewController
        
        vc.counterId = counterId
        vc.count = counter
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func incrementCounter(id:String){
        
        print("called from siri \(id)")
        
        ref.child("users").child(userID!).child("counters").child(id).observeSingleEvent(of: .value, with: { (snap) in
            
            if let mainObj = snap.value as? [String: AnyObject]{
                let count = mainObj["counter"] as? Int
                
                let userInfoDictionary = ["counter":count! + 1] as [String : Any]
                
                self.ref.child("users").child(self.userID!).child("counters").child(id).updateChildValues(userInfoDictionary)
                
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
                
                
                self.ref.child("users").child(self.userID!).child("counters").child(id).child("countersData")
                    .child(myparentDate).child(mydate).setValue(dateData)
                
                
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    @objc func onCounterButtonPress(sender: UIButton){
        
        //
        let counter = self.counters[sender.tag]
        
        dump("mycounter \(counter.id)")
        
        let userInfoDictionary = ["counter":counter.count + 1] as [String : Any]
        
        self.ref.child("users").child(userID!).child("counters").child(counter.id).updateChildValues(userInfoDictionary)
        
        let parentDate = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd-MM-yyyy"
        let myparentDate = formatter1.string(from: parentDate)
        
        let today = Date()
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh:mm:ss a"
        let mydate = formatter2.string(from: today)
        print("mydate \(mydate)")
        
        let dateData = ["date":mydate,"count":counter.count + 1,"counter_name":counter.counterName,"identifier":counter.id] as [String : Any]
        
        
        self.ref.child("users").child(userID!).child("counters").child(counter.id).child("countersData")
            .child(myparentDate).child(mydate).setValue(dateData)
        //
        self.ref.child("users").child(self.userID!).child("allCounters")
            .child(myparentDate).child(mydate).setValue(dateData)
        
    }
    
    
    @objc func onCounterSettingsPress(sender: UIButton){
        
        let counter = self.counters[sender.tag]
        
        dump("mycounter \(counter.counterName)")
        
        
        
        
        
        
        
        let vc = storyboard?.instantiateViewController(identifier: "CounterSettings") as! CounterSettingsViewController
        
        vc.name = counter.counterName
        vc.id = counter.id
        vc.count = counter.count
        vc.modalPresentationStyle = .formSheet
        present(vc,animated: true)
        
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
  
    
    
}
