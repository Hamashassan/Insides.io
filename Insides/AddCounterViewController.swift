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

class AddCounterViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var colors : [UIColor] = [.green, .orange, .red,.green, .orange, .red,.green, .orange, .red,.green, .orange, .red]
    
    @IBOutlet weak var counterNameField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref = Database.database().reference()
        
        counterNameField.becomeFirstResponder()
        
        createButton.addTarget(self, action: #selector(onCreatePress), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(onBackPress), for: .touchUpInside)
        
        let nav = self.navigationController?.navigationBar
                
        
        //Initialize the title for the ViewController
        nav?.topItem?.title = "Andrey"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped)
        )
        
        Util.styleTextField(counterNameField)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func editTapped(){
        print("edit")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorsCollectionViewCell
        
        cell.configureCell(color: .red)
        
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //
    //
    //        let colorCell = cell as? ColorsCollectionViewCell
    //
    //
    //        colorCell?.configureCell(color: colors[indexPath.row])    }
    
    
    
    
    
    //    {
    //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
    //        cell.backgroundColor = colors[indexPath.row]
    //
    //        return cell
    //
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func onCreatePress(){
        
        let identifier = UUID().uuidString
        
        print("Create")
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let counterName = counterNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let userInfoDictionary = ["identifier":identifier,"counte_name" : counterName,
                                  "counter_color" : "UIColor.red","counter":0] as [String : Any]
        
        self.ref.child("users").child(userID).child("counters").child(identifier).setValue(userInfoDictionary)
        
        
        
    }
    
    @objc func onBackPress(){
        self.dismiss(animated: true, completion: nil) }
    }
    

