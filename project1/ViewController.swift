//
//  ViewController.swift
//  project1
//
//  Created by Rosalie Ma on 4/12/19.
//  Copyright © 2019 Rosalie Ma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    var ref: DatabaseReference?
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ref = Database.database().reference()
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        let user_name = username.text!
        let pass_word = password.text!
        
        self.ref?.child("UserAccountInfo").child(user_name).setValue(pass_word)
        
        let alert = UIAlertController(title: "Account created!", message: "Please login to your account.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        let user_name = username.text!
        let pass_word = password.text!
        
        self.ref?.child("UserAccountInfo").child(user_name).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let password = snapshot.value as? String
            if password == pass_word {
                UserDefaults.standard.set(user_name, forKey: "Username")
                self.performSegue(withIdentifier: "SignInTo3Functions",
                                  sender: self)
            }
            else {
                let alert = UIAlertController(title: "Wrong!", message: "Please re-enter.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

