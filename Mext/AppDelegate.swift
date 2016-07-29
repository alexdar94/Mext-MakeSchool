//
//  AppDelegate.swift
//  Mext
//
//  Created by Alex Lee on 01/07/2016.
//  Copyright © 2016 Alex Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    let logTag = "AppDelegate"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
//        try! FIRAuth.auth()?.signOut()
        isLogin()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func isLogin () {
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            dispatch_async(dispatch_get_main_queue(), { 
                if let user = user {
                    // User is signed in.
                    print("\(self.logTag) login")
                    let messageInboxViewController = storyboard.instantiateViewControllerWithIdentifier("MessageInboxViewController") as! MessageInboxViewController
                    
                    FirebaseHelper.getUser(user.uid){ user -> Void in
                        messageInboxViewController.currUser = user
                        self.window?.rootViewController = messageInboxViewController
                    }
                } else {
                    // No user is signed in.
                    print("\(self.logTag) not login")
                                    let loginViewController = storyboard.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
                    
                                    self.window?.rootViewController = loginViewController
                }

            })
            
        }
    }
    
    // MARK: Google Sign In
    // [Deprecated] Google sign in
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
                                            UIApplicationOpenURLOptionsAnnotationKey: annotation!]
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    
    // Google sign in
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        if GIDSignIn.sharedInstance().handleURL(url,
                                                sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                annotation: options[UIApplicationOpenURLOptionsAnnotationKey]) {
            return true
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     openURL: url,
                                                                     sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
                                                                     annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
                                                                     accessToken: authentication.accessToken)
        firebaseLogin(credential)
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
    }
    
    func firebaseLogin(credential: FIRAuthCredential) {
        if let user = FIRAuth.auth()?.currentUser {
            user.linkWithCredential(credential) { (user, error) in
                if let error = error {
                    return
                }
            }
        } else {
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                if let error = error {
                    return
                }
            }
        }
    }
    
    func signOut(){
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

