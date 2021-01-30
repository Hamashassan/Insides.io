//
//  Util.swift
//  Insides
//
//  Created by Hamas Hassan on 1/29/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    static func styleTextField(_ textfield:UITextField) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0 ,y: textfield.frame.height - 2 ,width: textfield.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 200/255  , green: 199/255, blue: 204/255, alpha: 1).cgColor
        textfield.borderStyle = .none
        textfield.layer.addSublayer(bottomLine)
    }
    
    static func styleSocialButton(_ button:UIButton) {
        
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        button.layer.masksToBounds = false
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    
}
