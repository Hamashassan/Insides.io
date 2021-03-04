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
    
//    override func layoutSubviews() {
//          super.layoutSubviews()
//          //set the values for top,left,bottom,right margins
//          let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//          contentView.frame = contentView.frame.inset(by: margins)
////          contentView.layer.cornerRadius = 8
//    }
    //
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
 
    
    func setCounter(counter: Counter!){
        
       
        
        counterButton.layer.cornerRadius = 10; // this value vary as per your desire
        
        self.counter = counter
        
        let count = counter.type == "all" ? counter.count : counter.todayCount
        
        
        counterName.text = counter.counterName
        counterButton.backgroundColor = counter.counterColor
        counterButton.setTitle(String( count), for: .normal)
        
    }
    
    
}
