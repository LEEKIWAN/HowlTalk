//
//  AppDelegate.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 5. 22..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
//FBSDKCoreKit/FBSDKCoreKit.h

import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, FBSDKGraphRequestConnectionDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        let googleDidHandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
//        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    
        return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
//        return facebookDidHandle || googleDidHandle
    }
    
    
    
    //MARK:- GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            log.error(error.localizedDescription)
            return
        }
        
        
        let thumbSize = CGSize.init(width: 500, height: 500)
        let userID = user!.userID
        let idToken = user!.authentication.idToken
        let accessToken = user!.authentication.accessToken
        let name = user.profile.name
        let email = user.profile.email
        var imageURL:URL? = nil
        
        if GIDSignIn.sharedInstance().currentUser.profile.hasImage {
            let dimension = round(thumbSize.width * UIScreen.main.scale)
            imageURL = user.profile.imageURL(withDimension: UInt(dimension))
        }
        
        print("AppDelegate ===> [1] ID : \(String(describing: userID)) | [2] idToken : \(String(describing: idToken)) | [3] accessToken : \(String(describing: accessToken)) | [4] name : \(String(describing: name)) | [5] email : \(String(describing: email)) [6] imageURL : \(String(describing: imageURL))")
        
        PreferenceManager.userID = user!.userID
        PreferenceManager.userName = user!.profile.name
        PreferenceManager.userEmail = user!.profile.email
        PreferenceManager.loginMethod = SocialLoginMethod.Google.rawValue
        
        
        let storyBoard = UIStoryboard(name: "MainViewController", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController")
        UIApplication.shared.keyWindow?.rootViewController = mainViewController
        
        
        
    }
    
    func requestFacebookUserInfo() {
        if FBSDKAccessToken.current() != nil {
            let requestUserInfo = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id,name,link, picture, email, gender, birthday ,location ,devices ,currency, education"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(requestUserInfo, completionHandler: { (connection, result, error) in
                if let userData = result as? [String:AnyObject] {
                    
                    PreferenceManager.userID = userData["id"] as? String
                    PreferenceManager.userEmail = userData["email"] as? String
                    PreferenceManager.userName = userData["name"] as? String
                    PreferenceManager.loginMethod = SocialLoginMethod.Facebook.rawValue
 
                    
//                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                }
            })
            connection.delegate = self
            connection.start()
        }
//        else {
//            self.moveToName(menuName: .Login)
//        }
    }
    
    
}

