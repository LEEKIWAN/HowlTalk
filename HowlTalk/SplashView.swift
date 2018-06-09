//
//  LaunchScreen.swift
//  HowlTalk
//
//  Created by 이기완 on 09/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import SKSplashView

class SplashView: UIViewController, SKSplashDelegate {

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
        
        let storyBoard = UIStoryboard(name: "LogInViewController", bundle: nil)
        let logInViewController = storyBoard.instantiateViewController(withIdentifier: "LogInViewController")
        UIApplication.shared.keyWindow?.rootViewController = logInViewController
        
        
        self.dismiss(animated: false)
    }
    
    func splashView(_ splashView: SKSplashView!, didBeginAnimatingWithDuration duration: Float) {
        
        
    }

}
