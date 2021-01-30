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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let colorView = UIView(frame: bounds)
        colorView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        self.backgroundView = colorView
    }
    
    func configureCell(color:UIColor) {
        //        self.backgroundColor = UIColor (red: 123.0/255.0, green: 200.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        
        colorView.backgroundColor = UIColor (red: 123.0/255.0, green: 200.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        
        colorView.layer.cornerRadius = 44/2
        
    }
    
}
