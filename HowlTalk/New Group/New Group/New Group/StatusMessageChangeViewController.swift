//
//  StatusMessageChangeViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 7. 23..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import Firebase

class StatusMessageChangeViewController: UIViewController, UITextViewDelegate {

    var willSetStatusMessage: String?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textLengthLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    override func viewDidLoad() {
        if let statusMsg = willSetStatusMessage {
            textView.text = statusMsg
        }
        
        self.setTextLength()
    }
    
    
    func setTextLength() {
        let cnt = self.textView.text.count
        textLengthLabel.text = "\(cnt) / 60"
    }
    
    //MARK: - EVENT
    
    @IBAction func onChangeTouched(_ sender: UIButton) {
        self.requestChangeStatusMessage()
    }
    
    func requestChangeStatusMessage() {
        let dic = ["statusMessage" : textView.text]
        let UID = Auth.auth().currentUser?.uid
        
//        Database.database().reference().child("USER_TB").child(UID!).updateChildValues(dic)
        
        Database.database().reference().child("USER_TB").child(UID!).updateChildValues(dic) { (error, reference) in
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        self.setTextLength()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text.count > 59 && textView.text != "" {
            return false
        }
        
        return true
    }
}
