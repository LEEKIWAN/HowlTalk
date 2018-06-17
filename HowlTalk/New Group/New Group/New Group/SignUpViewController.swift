//
//  SignUpViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 6. 5..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import NVActivityIndicatorView

class SignUpViewController: UIViewController, UIGestureRecognizerDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let storageRef = Storage.storage().reference()
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setEvent()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

  
    
    
    func setEvent() {
    }
    
    //MARK: - event
    
    @IBAction func onBcakgroundTouched(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func onSignUpTouched(_ sender: UIButton) {
        startAnimating()
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            self.stopAnimating()
            if let error = error {
                // 17007 - 등록된 이메일, 17008 - 메일형식 오류, 17026 - 짧은비밀번호 6자리, 17999 - 이메일 또는 비밀번호 잘못됨
                UIAlertController.showError(viewController: self, title: "Error", message: error.localizedDescription)
                return
            }
            if result != nil {
                
                let alertController = UIAlertController(title: "회원가입", message: result?.description, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { (alertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
//                let userUID = result?.user.uid
                
                
                // DB
                self.databaseRef.child("USER_TB").child((result?.user.uid)!).setValue(["userUID" : result?.user.uid, "userID" : result?.user.providerID, "userName" : self.nameTextField.text!, "userEmail" : self.emailTextField.text!])
//               self.databaseRef.child("USER_TB").child(userUID!).setValue(["userID" : userID, ", "profileImageURL" : imageURL])
            }
            
        }
    }
    
    @IBAction func onCancelTouched(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
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
