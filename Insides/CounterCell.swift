//
//  CounterCell.swift
//  Insides
//
//  Created by Hamas Hassan on 1/28/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit

class CounterCell: UITableViewCell {
    
    @IBOutlet weak var counterName: UILabel!
    @IBOutlet weak var counterSettingButton: UIButton!
    @IBOutlet weak var counterButton: UIButton!
    
    var counter:Counter?
    //
    
 
    
    func setCounter(counter: Counter!){
        
        counterButton.layer.cornerRadius = 10; // this value vary as per your desire
        
        self.counter = counter
        
        counterName.text = counter.counterName
        counterButton.backgroundColor = counter.counterColor
        counterButton.setTitle(String(counter.count), for: .normal)
        
    }
    
    
}
