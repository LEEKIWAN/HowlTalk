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
import GoogleSignIn
import FBSDKLoginKit


class LoginViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate, UITextFieldDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var remoteConfig: RemoteConfig! = RemoteConfig.remoteConfig()
    let facebookLoginManager = FBSDKLoginManager()
    
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.remoteConfigFetch()
        
        GIDSignIn.sharedInstance().uiDelegate = self
//        facebookSignInButton.delegate = self
        
        
        if FBSDKAccessToken.currentAccessTokenIsActive() {
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func remoteConfigFetch() {
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
            self.showNoticeAlertView()
        }
    }
    
    func showNoticeAlertView() {
        let message = remoteConfig["message"].stringValue
        let isEnableApp = remoteConfig["isEnableApp"].boolValue
        
        
        if !isEnableApp {
            let alert = UIAlertController(title: "공지사항", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
                exit(0)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        if message!.count > 0 {
            let alert = UIAlertController(title: "공지사항", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
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
    
    @IBAction func onGoogleSignInTouched(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func onFacebookSignInTouched(_ sender: UIButton) {
        facebookLoginManager.logIn(withReadPermissions: ["user_friends","email","user_about_me" ,"user_birthday" ,"user_hometown" ,"user_likes" ,"user_location" ,"user_photos" ,"user_status","user_relationships" ,"user_education_history"], from: self) {
            (result, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            self.appDelegate.requestFacebookUserInfo()
        }
    }
    
    
    //MARK: -  FBSDKLoginButtonDelegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            log.error(error.localizedDescription)
            return
        }
//        self.appDelegate.requestFacebookUserInfo()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
 
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(emailTextField) {
            passwordTextField.becomeFirstResponder()
        }
        else if textField.isEqual(passwordTextField) {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    
}

