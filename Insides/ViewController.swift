//
//  ViewController.swift
//  Insides
//
//  Created by Hamas Hassan on 1/18/21.
//  Copyright © 2021 Hamas Hassan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GIDSignInDelegate {
    
    
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpLabel: UILabel!
    
    
    @IBOutlet weak var appleButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var ref: DatabaseReference!
    
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
        
        
        
        // initialize firebase
        ref = Database.database().reference()
        
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
        
        googleButton.addTarget(self, action: #selector(onGoogleSignInPress), for: .touchUpInside)
        
        
        
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func onGoogleSignInPress(){
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        let userId = user.userID              // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Login error: \(error?.localizedDescription)")
                return
            }else{
                
                guard let userID = Auth.auth().currentUser?.uid else { return }
                
                let userInfoDictionary = ["username" : "" ,
                                          "email" : email ?? "","couunters":[]] as [String : Any]
                
                self.ref.child("users").child(userID).setValue(userInfoDictionary)
                
                self.transitionToHome()
            }
        })
        
        
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

