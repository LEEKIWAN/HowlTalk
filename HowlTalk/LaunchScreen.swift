//
//  LaunchScreen.swift
//  HowlTalk
//
//  Created by 이기완 on 09/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import SKSplashView

class LaunchScreen: UIViewController {

    var splashView: SKSplashView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        log.debug("Asdf")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func twitterSplash() {
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "twitter background.png")
        self.view.addSubview(imageView)
        
        self.splashIcon = SKSplashIcon(image: UIImage(named: "twitter icon.png"), animationType: .bounce)
        
        
        SKSplashIcon.in
        //        self.splashIcon.setIconAnimationType(.bounce)
        let twitterColor = UIColor.blue
        
        self.splashView = SKSplashView(splashIcon: self.splashIcon, animationType: .none)
        self.splashView?.delegate = self
        
        self.splashView?.backgroundColor = twitterColor
        
        self.splashView?.animationDuration = 3
        
        self.view.addSubview(self.splashView!)
        
        self.splashView?.startAnimation()
        
    }
    
    func splashViewDidEndAnimating(_ splashView: SKSplashView!) {
        
    }
    
    func splashView(_ splashView: SKSplashView!, didBeginAnimatingWithDuration duration: Float) {
        
    }

}
