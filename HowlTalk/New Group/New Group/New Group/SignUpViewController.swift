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
    
    @objc func onProfileImageTouched() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onSignUpTouched(_ sender: UIButton) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if let error = error {
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
