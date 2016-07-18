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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Google sign in
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signInSilently()
        
        // Facebook sign in
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["email","user_friends"]
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
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.signOut()
    }
    
}


// MARK: Facebook login
extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if result.isCancelled {
            // Handle cancellations
        }
        else {
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.firebaseLogin(credential)
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            print(result)
            if result.grantedPermissions.contains("email")
            {
                
                //print(result.valueForKey("email"))
            }
            if result.grantedPermissions.contains("user_friends")
            {
                print("user friends returned")
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
}


