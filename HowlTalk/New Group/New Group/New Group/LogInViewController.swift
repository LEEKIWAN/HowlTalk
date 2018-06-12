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
import NVActivityIndicatorView


class LoginViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate, UITextFieldDelegate, NVActivityIndicatorViewable {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var remoteConfig: RemoteConfig! = RemoteConfig.remoteConfig()
    
    let facebookLoginManager = FBSDKLoginManager()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentsView: UIView!
    
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.remoteConfigFetch()
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func remoteConfigFetch() {
        remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        startAnimating()
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)) { (status, error) -> Void in
            
            self.stopAnimating()
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
    @IBAction func onBackgroundTouched(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func onLogInTouched(_ sender: UIButton) {
        startAnimating()
        
        appDelegate.directSignIn(email: emailTextField.text!, password: passwordTextField.text!)
        
        stopAnimating()
    }
    
    @IBAction func onSignUpTouched(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "SignUpViewController", bundle: nil)
        let signUpViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController")
        self.present(signUpViewController, animated: false, completion: nil)
    }
    
    @IBAction func onForgotPasswordTouched(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "PasswordFindViewController", bundle: nil)
        let passwordFindViewController = storyBoard.instantiateViewController(withIdentifier: "PasswordFindViewController")
        self.present(passwordFindViewController, animated: false, completion: nil)
        
    }
    
    @IBAction func onGoogleSignInTouched(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func onFacebookSignInTouched(_ sender: UIButton) {
        facebookLoginManager.logIn(withReadPermissions: ["public_profile", "user_friends","email" ,"user_birthday" ,"user_hometown" ,"user_likes" ,"user_location" ,"user_photos" ,"user_status"], from: self) {
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

    
    //MARK: - UIKeyBoardNotification
    @objc func keyboardWasShown(notification: NSNotification){
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        scrollView.contentInset =  UIEdgeInsets.init(top: 0 , left: 0, bottom: keyboardHeight, right: 0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardHeight, right: 0)

    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        scrollView.contentInset =  UIEdgeInsets.init(top: 0 , left: 0, bottom: 0, right: 0)
        scrollView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0 , left: 0, bottom: 0, right: 0)
    }
    
}

