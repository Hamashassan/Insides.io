//
//  DetailsViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/31/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var navigationTtile: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTtile.text = "Today"

        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onCalendarPress(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "CalendarScreen") as! CalendarViewController
               
        
//               vc.name = counter.counterName
//               vc.id = counter.id
               //        vc.name = counter
               //        vc.reciv
               //        let vc = CounterSettingsViewController(name:"Hello")
               vc.modalPresentationStyle = .formSheet
               present(vc,animated: true)
               
        
    }
    
    @IBAction func onBackPress(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
