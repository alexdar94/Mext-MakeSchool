//
//  ViewController.swift
//  Mext
//
//  Created by Alex Lee on 01/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //performSegueWithIdentifier("launchChatView", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "launchChatView" {
                // Action
            }
        }
    }
    
    @IBAction func didTapEmailLogin(sender: AnyObject) {
        if let email = self.emailTextField.text, password = self.passwordTextField.text {
            
            showSpinner({
                FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
                    self.hideSpinner({
                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        //self.navigationController!.popViewControllerAnimated(true)
                    })
                }
            })
        } else {
            self.showMessagePrompt("email/password can't be empty")
        }
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

