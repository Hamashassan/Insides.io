//
//  CounterModal.swift
//  Insides
//
//  Created by Hamas Hassan on 1/28/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import Foundation
import UIKit



class Counter{
    
    
//          let currentDate =
    
    var id: String
    var counterName: String
    var count: Int
    var counterColor: UIColor
    var currentDate : String
    var todayCount: Int
    var type: String
    
    init(id:String,counterName:String,count:Int,counterColor:UIColor,currentDate:String,todayCount:Int,type:String) {
        self.id = id
        self.counterName = counterName
        self.count = count
        self.counterColor = counterColor
        self.currentDate = currentDate
         self.todayCount = todayCount
        self.type = type
    }
    
    
    
    
    
    
}
