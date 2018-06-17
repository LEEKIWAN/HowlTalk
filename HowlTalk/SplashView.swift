//
//  LaunchScreen.swift
//  HowlTalk
//
//  Created by 이기완 on 09/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import SKSplashView
import GoogleSignIn
import FBSDKLoginKit

class SplashView: UIViewController, SKSplashDelegate {
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var splashView: SKSplashView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashAnimation()
    }
    
    func splashAnimation() {
        let splashIcon = SKSplashIcon(image: UIImage(named: "whiteApple"), animationType: .bounce)
        splashIcon?.iconSize = CGSize(width: 90, height: 90)
        self.splashView = SKSplashView(splashIcon: splashIcon, animationType: .none)
        self.view.addSubview(self.splashView!)
        
        self.splashView?.delegate = self
        self.splashView?.animationDuration = 2
        self.splashView?.startAnimation()
    }
    
    
    func splashViewDidEndAnimating(_ splashView: SKSplashView!) {
        
//        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
//            appDelegate.moveToName(menuName: .Main)
//            GIDSignIn.sharedInstance().signInSilently()
//            return
//        }
//
//        else if FBSDKAccessToken.currentAccessTokenIsActive() {
//            appDelegate.moveToName(menuName: .Main)
//            appDelegate.requestFacebookUserInfo()
//            return
//        }
//        else if PreferenceManager.loginMethod == SocialLoginMethod.Direct.rawValue {
//            appDelegate.moveToName(menuName: .Main)
//            print("\(PreferenceManager.userEmail) \(PreferenceManager.userPassword)")
//            appDelegate.directSignIn(email: PreferenceManager.userEmail!, password: PreferenceManager.userPassword!)
//            return
//        }
//        else {
            self.dismiss(animated: false, completion: nil)
            appDelegate.moveToName(menuName: .Login)
            
//        }
    }
    
    func splashView(_ splashView: SKSplashView!, didBeginAnimatingWithDuration duration: Float) {
        
        
    }

}
