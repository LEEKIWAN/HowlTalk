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

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setEvent()
    }
    
    func setEvent() {
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onProfileImageTouched)))
    }
    
  
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
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
                    self.showErrorAlertController("Error", error.localizedDescription)
                    return
                }
                if result != nil {
                    let alertController = UIAlertController(title: "회원가입", message: "회원가입이 완료되었습니다.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { (alertAction) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    // 업로드 이미지
                    let image = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1)
                    
                    // 메타데이터
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpeg"
                    
                    metaData.do
                    
                    self.storageRef.child("UserProfileImage").child((result?.user.uid)!).putData(image!, metadata: metaData, completion: { (metaData, error) in
                        if let error = error {
                            log.error(error)
                            return
                        }
                        
                        Database.database().reference().child("USER_TB").child((result?.user.uid)!).setValue(["name" : self.nameTextField.text!, "profileImageURL" : metaData?.path])
                        
//                        metaData?.storageReference?.downloadURL(completion: { (url, error) in
//                            if let error = error {
//                                log.error(error)
//                                return
//                            }
//
//
//
//                        })
                        
                        
                    })
                
                }
        }
    }
    
    @IBAction func onCancelTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func showErrorAlertController(_ title: String , _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
