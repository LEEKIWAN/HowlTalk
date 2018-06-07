//
//  ViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 5. 22..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class ViewController: UIViewController {
    
    var remoteConfig: RemoteConfig!
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
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
            self.setThemeColor()
        }
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let storyBoard = UIStoryboard(name: "MainViewController", bundle: nil)
                let signUpViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController")
                self.present(signUpViewController, animated: true, completion: nil)
            }
        }
    }

    func setThemeColor() {
        let themeColor = remoteConfig["themeColor"].stringValue
        signInButton.backgroundColor = UIColor(hexString: themeColor!)
        logInButton.backgroundColor = UIColor(hexString: themeColor!)
        
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
    
    //MARK: - Event
    @IBAction func onLogInTouched(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if let error = error {
                UIAlertController.showError(viewController: self, title: "Error", message: error.localizedDescription)
            }
            
        }
    }
    
    @IBAction func onSignUpTouched(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "SignUpViewController", bundle: nil)
        let signUpViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController")
        self.present(signUpViewController, animated: true, completion: nil)
    }
}

