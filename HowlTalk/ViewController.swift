//
//  ViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 5. 22..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var remoteConfig: RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            if status == .success {
                log.info("Config fetched!")
                self.remoteConfig.activateFetched()
            }
            else {
                log.warning("Config not fetched")
                log.error("Error: \(error?.localizedDescription ?? "No error available.")")
            }
            self.displayWelcome()
        }
        
    }
    
    func displayWelcome() {
        let message = remoteConfig["message"].stringValue
        let isEnableApp = remoteConfig["isEnableApp"].boolValue
        
        if !isEnableApp {
            let alert = UIAlertController(title: "공지사항", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
                exit(0)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

