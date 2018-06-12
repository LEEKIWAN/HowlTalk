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

import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, FBSDKGraphRequestConnectionDelegate {

    var window: UIWindow?
    var currentView: String!
    var databaseRef: DatabaseReference!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    
        FirebaseApp.configure()

        self.databaseRef = Database.database().reference()
        
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
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    
        return facebookDidHandle || googleDidHandle
    }
    
    
    
    //MARK:- GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            log.error(error.localizedDescription)
            self.moveToName(menuName: .Login)
            return
        }
        
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        
        var userUID: String? = nil
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
        PreferenceManager.profileImageURL = imageURL?.absoluteString
        PreferenceManager.loginMethod = SocialLoginMethod.Google.rawValue
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if let error = error {
                log.error(error.localizedDescription)
                return
            }
            userUID = result?.user.uid
            PreferenceManager.userUID = userUID
            self.databaseRef.child("USER_TB").child(userUID!).setValue(["userID" : userID, "userName" : name, "userEmail" : email, "profileImageURL" : imageURL?.absoluteString])
            
            self.moveToName(menuName: .Main)
        }
        
    }
    
    func requestFacebookUserInfo() {
        if FBSDKAccessToken.current() != nil {
            let requestUserInfo = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id,name,link, picture, email, gender, birthday ,location ,devices ,currency, education"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(requestUserInfo, completionHandler: { (connection, result, error) in
                if let error = error {
                    log.error(error.localizedDescription)
                    self.moveToName(menuName: .Login)
                    return
                }
                
                if let userData = result as? [String:AnyObject] {
                    
                    var userUID: String?
                    let userID = userData["id"] as? String
                    let picture = userData["picture"] as! NSDictionary
                    let pictureData = picture.object(forKey: "data") as! NSDictionary
                    let imageURL = pictureData.object(forKey: "url") as! String
                    let userEmail  = userData["email"] as? String
                    let userName = userData["name"] as? String
                    
                    PreferenceManager.userID = userID
                    PreferenceManager.userEmail = userEmail
                    PreferenceManager.userName = userName
                    PreferenceManager.profileImageURL = imageURL
                    PreferenceManager.loginMethod = SocialLoginMethod.Facebook.rawValue
                    
                    print("FaceBook ===> \(userData)")
                    
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                    Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
                        if let error = error {
                            log.error(error.localizedDescription)
                            
                            return
                        }
                        userUID = result?.user.uid
                        PreferenceManager.userUID = result?.user.uid
                        self.databaseRef.child("USER_TB").child(userUID!).setValue(["userID" : userID, "userName" : userName, "userEmail" : userEmail, "profileImageURL" : imageURL])
                        
                        self.moveToName(menuName: .Main)
                    }
                    
                }
            })
            connection.delegate = self
            connection.start()
            
            
        }
    }
    
    func directSignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.moveToName(menuName: .Login)
                return
            }
            if let user = user {
                PreferenceManager.userUID = user.user.uid
                PreferenceManager.userEmail = user.user.email
                PreferenceManager.userPassword = password
                PreferenceManager.loginMethod = SocialLoginMethod.Direct.rawValue
               
                self.moveToName(menuName: .Main)
            }
        }
    }
    
    
    func moveToName(menuName: MenuName) {
        if menuName == MenuName.Login && self.currentView != "LoginViewController" {
            self.currentView = "LoginViewController"
            let storyboard = UIStoryboard.init(name: "LogInViewController", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
            self.window?.rootViewController = loginViewController
        }
        else if menuName == MenuName.Main && self.currentView != "MainViewController" {
            self.currentView = "MainViewController"
            let storyboard = UIStoryboard.init(name: "MainViewController", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            self.window?.rootViewController = mainViewController
        }
        else if menuName == MenuName.Greeting {
            
//            let navigationViewController = UINavigationController.init()
//            let greetingsView = UIStoryboard.init(name: "GreetingsView", bundle: nil)
//            let greetingsViewController = greetingsView.instantiateViewController(withIdentifier: "GreetingsView") as! GreetingsViewController
//            greetingsViewController.isGreeting = true
//
//            navigationViewController.viewControllers = [greetingsViewController]
//            self.window?.rootViewController = navigationViewController
        }
        
    }
}

