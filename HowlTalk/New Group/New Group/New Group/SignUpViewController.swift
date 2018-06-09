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

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
    
    func setEvent() {
    }
    
    //MARK: - event
    
    @IBAction func onSignUpTouched(_ sender: UIButton) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if let error = error {
                    // 17007 - 등록된 이메일, 17008 - 메일형식 오류, 17026 - 짧은비밀번호 6자리, 17999 - 이메일 또는 비밀번호 잘못됨
                    UIAlertController.showError(viewController: self, title: "Error", message: error.localizedDescription)
                    return
                }
                if result != nil {
                    let alertController = UIAlertController(title: "회원가입", message: "회원가입이 완료되었습니다.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { (alertAction) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    // DB
                    self.databaseRef.child("USER_TB").child((result?.user.uid)!).setValue(["name" : self.nameTextField.text!])
                   
                }
        }
    }
    
    @IBAction func onCancelTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
