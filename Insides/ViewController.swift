//
//  ViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/18/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    
    @IBOutlet weak var appleButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var counters = ["C1","C2","C3","C1","C2","C3","C1","C2","C3","C1","C2","C3","C1","C2","C3","C1","C2","C3"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "counter")
        cell?.textLabel?.text = counters[indexPath.row]
        return cell!
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setupLabelTap()
        
        usernameField.becomeFirstResponder()
        
        errorLabel.alpha = 0
        
        // Social Button Shadow
        Util.styleSocialButton(appleButton)
        Util.styleSocialButton(googleButton)
        
        // Input Field custom style
        Util.styleTextField(usernameField)
        Util.styleTextField(passwordField)
        
        signInButton.addTarget(self, action: #selector(onSignInPress), for: .touchUpInside)
        
        
        
        
        
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @objc func onSignInPress(){
        
        let error = validateFields()
        
        if error != nil {
            
            showError(error!)
            
        }
        else {
            errorLabel.alpha = 0
            // Create cleaned versions of the data
            let email =  usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
                
                
                if error != nil {
                
                    self.showError("Something went wrong, Please try again")
                    
                }else{
                    
                    self.transitionToHome()
                
                }
            })
        }
    }
    
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        
        let vc = storyboard?.instantiateViewController(identifier: "SignUpScreen") as! SignUpViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func setupLabelTap() {
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.signUpLabel.isUserInteractionEnabled = true
        self.signUpLabel.addGestureRecognizer(labelTap)
        
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the email is correct
        
        let email = usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Util.isValidEmail(email) == false {
            return "Invalid email address"
        }
        
        return nil
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: "HomeScreen") as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
}

