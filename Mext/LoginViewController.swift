//
//  ViewController.swift
//  Mext
//
//  Created by Alex Lee on 01/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    let TAG = "LoginViewController"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        
        // Google sign in
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signInSilently()
        
        // Facebook sign in
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["email","user_friends"]
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func viewDidAppear(animated: Bool) {
        //performSegueWithIdentifier("launchChatView", sender: nil)
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
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.signOut()
    }
}


// MARK: Facebook login
extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        guard error == nil else {
            print(error.localizedDescription)
            return
        }

        if result.isCancelled {
            // Handle cancellations
        } else {
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.firebaseLogin(credential)
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            print("Result: \(result)")
            
            if result.grantedPermissions.contains("email") {
                print()
            }
            
            if result.grantedPermissions.contains("user_friends") {
                print("user friends returned")
            }
            
            var fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "email,user_friends"]);
            fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if error == nil {
                    
                    print("User Info : \(result)")
                } else {
                    print("Error Getting Info \(error)");
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // log out
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
}


