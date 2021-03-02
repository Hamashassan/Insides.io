//
//  SignUpViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/28/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var confirmPasswordInput: UITextField!
    
    @IBOutlet weak var appleButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize firebase
        ref = Database.database().reference()
        
        // hiding error Label
        errorLabel.alpha = 0
        
        // focus to usernameInput
        usernameInput.becomeFirstResponder()
        
        //
        signUpButton.addTarget(self, action: #selector(onSignUpPress), for: .touchUpInside)
        
        // signin label onPress
        self.setupLabelTap()
        
        // Social Button Shadow
        Util.styleSocialButton(appleButton)
        Util.styleSocialButton(googleButton)
        
        // Input Field custom style
        Util.styleTextField(usernameInput)
        Util.styleTextField(emailInput)
        Util.styleTextField(passwordInput)
        Util.styleTextField(confirmPasswordInput)
        
        
    }
    
    // sign in label on press
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // sign in label on press
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.signInLabel.isUserInteractionEnabled = true
        self.signInLabel.addGestureRecognizer(labelTap)
    }
    
    // Sigup button handler
    @objc func onSignUpPress(){
        
        let error = validateFields()
        
        if error != nil {
            
            showError(error!)
            
        }
        else {
            errorLabel.alpha = 0
            // Create cleaned versions of the data
            let username = usernameInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { result, error in
                
                
                if error != nil {
                    
                    self.showError("Something went wrong, Please try again")
                    
                }else{
                    
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    
                  let sharedDefaults = UserDefaults(suiteName: "group.com.insides.io")
                    sharedDefaults?.set(userID, forKey: "userID")

                    
                    let userInfoDictionary = ["username" : username,
                                              "email" : email,"couunters":[]] as [String : Any]
                    
                    self.ref.child("users").child(userID).setValue(userInfoDictionary)
                    
                    self.transitionToHome()
                }
                
                
            })
            
        }    }
    
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if usernameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the email is correct
        
        let email = emailInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPassword = confirmPasswordInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Util.isValidEmail(email) == false {
            return "Invalid email address"
        }
        
        if password != confirmPassword {
            return "Password mismatch."
        }
        
        return nil
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeScreen") as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
