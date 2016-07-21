//
//  SignUpViewController.swift
//  Mext
//
//  Created by Alex Lee on 14/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    let TAG = "SignUpViewController"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //performSegueWithIdentifier("launchChatView", sender: nil)
    }
    
    @IBAction func didTapSignUp(sender: AnyObject) {
        if let email = self.emailTextField.text, password = self.passwordTextField.text,  username = self.usernameTextField.text{
            
            showSpinner({
                FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                    self.hideSpinner({
                        if let error = error {
                            self.showMessagePrompt(error.localizedDescription)
                            return
                        }
                        
                        if let FIRUser = FIRAuth.auth()?.currentUser {
                            let user = User(UID: FIRUser.uid, email: FIRUser.email!, displayName: username, photoUrl: "", phoneNumber: "0123" )
                            FirebaseHelper.saveNewUser(user)
//                            let changeRequest = user.profileChangeRequest()
//                            
//                            changeRequest.displayName = username
//                            changeRequest.photoURL = NSURL(string: "")
//                            changeRequest.commitChangesWithCompletion { error in
//                                if let error = error {
//                                    // An error happened.
//                                    print(error)
//                                } else {
//                                    // Profile updated.
//                                    print(user.displayName)
//                                }
//                            }
                        }
                    })
                }
            })
        } else {
            self.showMessagePrompt("Email, Password, Username cannot be empty!")
        }
        
    }
    
}
