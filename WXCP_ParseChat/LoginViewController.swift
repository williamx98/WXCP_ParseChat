//
//  ViewController.swift
//  WXCP_ParseChat
//
//  Created by Will Xu  on 9/30/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signupPress(_ sender: Any) {
        activityIndicator.startAnimating()
        registerUser()
    }
    
    @IBAction func loginPress(_ sender: Any) {
        activityIndicator.startAnimating()
        loginUser()
    }
    
    func loginUser() {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                let alertController = UIAlertController(title: error.localizedDescription, message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {(action) in self.passwordField.text = ""}
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
                self.performSegue(withIdentifier: "toChatView", sender: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    func registerUser() {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                let alertController = UIAlertController(title: error.localizedDescription, message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {(action) in self.passwordField.text = ""}
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
                self.performSegue(withIdentifier: "toChatView", sender: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
}

