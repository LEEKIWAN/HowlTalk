//
//  SignUpViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 6. 5..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import TextFieldEffects

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onSignUpTouched(_ sender: UIButton) {
    }
    
    @IBAction func onCancelTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
