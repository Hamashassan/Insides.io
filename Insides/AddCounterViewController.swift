//
//  AddCounterViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/26/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Intents

class AddCounterViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    let one = UIColor.init(named: "one")
    
    var colors : [String] = ["#e56969", "#ef916b", "#e9b35d", "#e3ca2f", "#68c163" ,"#43cead" ,"#49c6da" ,"#4fb3f1" ,"#007aff", "#8453bc", "#b27adb", "#e691d2", "#8f9297", "#c2c2c2", "#989795" ]
    
    var dataSource : [String] = ["USA", "Brazil", "China", "UAE","USA", "Brazil", "China", "UAE","USA", "Brazil", "China", "UAE", ]
    
    @IBOutlet weak var counterNameField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    var selectedColor = "#007aff"
    
    
    
    
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let margin: CGFloat = 20
        
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        
        ref = Database.database().reference()
        
        counterNameField.becomeFirstResponder()
        
        createButton.addTarget(self, action: #selector(onCreatePress), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(onBackPress), for: .touchUpInside)
        
        let nav = self.navigationController?.navigationBar
        
        
        //Initialize the title for the ViewController
        nav?.topItem?.title = "Andrey"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.allowsSelection = true
        self.collectionView.allowsMultipleSelection = false
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        self.collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped)
        )
        
        Util.styleTextField(counterNameField)
        
        // Do any additional setup after loading the view.
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
    //        collectionViewHeight.constant = height + 40
    //        self.view.layoutIfNeeded()
    //    }
    
    @objc func editTapped(){
        print("edit")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Select ho bharwa",indexPath)
        
        let selectedColor = colors[indexPath.row]
        
        print("selected color ",selectedColor)
        
        self.selectedColor = selectedColor
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell {
            cell.onSelect()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorsCollectionViewCell {
            cell.onUnSelect()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorsCollectionViewCell
        
        
        
        cell.configure(color: colors[indexPath.row],size: 50)
        //
        //
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 5  //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        //
        
        return CGSize(width: size, height: size)
    }
    
    
    
    //    didSelectItemAt
    
    @objc func onCreatePress(){
        
        let identifier = UUID().uuidString
        
        print("Create")
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
//        let userDefaults = UserDefaults.standard
//
//        userDefaults.set(userID, forKey: "userId")
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.insides.io")
        sharedDefaults?.set(userID, forKey: "userID")
        
        let counterName = counterNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let userInfoDictionary = ["identifier":identifier,"counte_name" : counterName,
                                  "counter_color" : self.selectedColor,"counter":0] as [String : Any]
        
        self.ref.child("users").child(userID).child("counters").child(identifier).setValue(userInfoDictionary)
        
        self.donateUserActivity(id: identifier,title: counterName)
        
        self.onBackPress()
        
    }
    
    //    func saveToUserDefaults(id:String,counterName:String){
    //
    //    }
    
    @objc func onBackPress(){
        self.dismiss(animated: true, completion: nil) }
}


extension AddCounterViewController {
    func donateUserActivity(id: String,title:String) {
        //        let activityTypeName = "com.insides.io.counter"
        //        let activity = NSUserActivity(activityType: activityTypeName)
        //        activity.title = "Increment \(title)"
        //        activity.userInfo = ["id" : id]
        //        activity.isEligibleForSearch = true
        //        activity.isEligibleForPrediction = true
        //        //        activity.suggestedInvocationPhrase = "Increment \(counter.counterName)"
        //        view.userActivity = activity
        //
        //        activity.becomeCurrent()
        
        //        New code
        
        let intent = CounterIntent()
        intent.suggestedInvocationPhrase = "Intent \(title)"
        //        intent.c
        //        intent.ti
        //        intent.
        //        intent.userI
        
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if (error as NSError?) != nil {
                    print("error",error!)
                } else {
                    print("error undefined")
                }
            }
        }
        print("Successfull Donate")
    }
}


