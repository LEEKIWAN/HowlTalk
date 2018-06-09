//
//  LaunchScreen.swift
//  HowlTalk
//
//  Created by 이기완 on 09/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import SKSplashView

class LaunchScreen: UIViewController, SKSplashDelegate {

    var splashView: SKSplashView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splashAnimation()
    }
    
    func splashAnimation() {
        let splashIcon = SKSplashIcon(image: UIImage(named: "whiteApple"), animationType: .bounce)
        splashIcon?.iconSize = CGSize(width: 100, height: 100)
        self.splashView = SKSplashView(splashIcon: splashIcon, animationType: .none)
        self.view.addSubview(self.splashView!)
        
        self.splashView?.delegate = self
        self.splashView?.animationDuration = 3
        self.splashView?.startAnimation()
    }
    
    
    func splashViewDidEndAnimating(_ splashView: SKSplashView!) {
        log.debug("asdf")
    }
    
    func splashView(_ splashView: SKSplashView!, didBeginAnimatingWithDuration duration: Float) {
        log.debug("begin")
    }

}
