
//
//  ColorsCollectionViewCell.swift
//  Insides
//
//  Created by Hamas Hassan on 1/27/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//
import UIKit

class ColorsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    func configure(color: String,size: CGFloat){
        
        
//        label?.text = name
       
//       self.contentView.isUserInteractionEnabled = true

        self.contentView.backgroundColor = hexStringToUIColor(hex: color)
        self.contentView.layer.cornerRadius = size/2
    }
    
    
    
    
    
    
    func onSelect(){
        self.onUnSelect()
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.init(named: "selection")?.cgColor
    }
    
    func onUnSelect(){
        contentView.layer.borderWidth = 0
//        contentView.layer.borderColor = UIColor.white.cgColor
      }
    
    @IBAction func onBtnPress(_ sender: Any) {
        print("Pressing")
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
