//
//  PasswordFindViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 10/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects
import NVActivityIndicatorView

class PasswordFindViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var emailTextField: HoshiTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentsView: UIView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    //MARK: - event
    @IBAction func onSubmitTouched(_ sender: UIButton) {
        startAnimating()
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            self.stopAnimating()
            
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            let alert = UIAlertController(title: "비밀번호", message: "해당 이메일주소로 비밀번호 재설정 메일을 보내드렸습니다. 이메일 재설정 해주시길 바랍니다.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (alertAction) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func onBackgroundTouched(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func onCancelTouched(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
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

