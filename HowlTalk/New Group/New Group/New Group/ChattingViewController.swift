//
//  ChattingViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 14/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import Firebase


class MyMessageCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
}

class OtherMessageCell: UITableViewCell {
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
}


class ChattingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var chattingRoomID: String?
    
    var uid: String? = Auth.auth().currentUser?.uid
    var destUID: String?
    var commentsArray: [CommentDTO] = []
    var userModel: UserDTO?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var consSendButtonBMargin: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.requestChattingRoom()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func onSendTouched(_ sender: UIButton) {
        self.requestCreateChattingRoom()
    }
    
    //MARK: - Request

    func requestCreateChattingRoom() {
        let userInfo: Dictionary<String, Any> = ["users" : [uid! : true, destUID! : true ] ]
        
        if chattingRoomID == nil {
            Database.database().reference().child("ChattingRoom_TB").childByAutoId().setValue(userInfo) { (error, reference) in
                if error != nil {
                    self.requestChattingRoom()
                }
            }
        }
        else {
            let value :Dictionary<String, Any> = [ "uid" : uid!, "message" : textField.text!]
            Database.database().reference().child("ChattingRoom_TB").child(chattingRoomID!).child("comments").childByAutoId().setValue(value) { (error, reference) in
            }
        }
    }
    
    
    // 상대방 나인지 구분은 안되어ㅣㅇㅆ따.
    func requestChattingRoom() {
        Database.database().reference().child("ChattingRoom_TB").queryOrdered(byChild: "users/" + uid!).queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]

            for snapshot in snapshots {
                if let chattingRoom = snapshot.value as? [String : AnyObject] {
                    let chattingDTO = ChattingDTO(JSON: chattingRoom)

                    if chattingDTO?.users[self.destUID!] == true {
                        self.chattingRoomID = snapshot.key
                        self.sendButton.isEnabled = true

                        self.requestMessageList()
                    }
                }

            }

        }
    }
    
    
    func requestMessageList() {
        self.commentsArray.removeAll()
         Database.database().reference().child("ChattingRoom_TB").child(self.chattingRoomID!).child("comments").observe(.value) { (snapshot) in
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            for data in snapshots {
                let dataDict = data.value as! [String : AnyObject]
                let comment = CommentDTO(JSON: dataDict)
                
                self.commentsArray.append(comment!)
                self.tableView.reloadData()
            }
        }
    }
    


    
    func getDestinationUserInfo() {
        Database.database().reference().child("users").child(self.destUID!).observeSingleEvent(of: .value) { (snapshot) in
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
        }
    }
    
    //MARK: - event
    @IBAction func onBackgroundTouched(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    //MARK: - UITableViewDataSource
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let commnet = commentsArray[indexPath.row];
        
        if(commnet.uid == uid) {
            let view = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            view.messageLabel.text = commnet.message;
            return view
        }
        else {
            let view = tableView.dequeueReusableCell(withIdentifier: "OtherMessageCell", for: indexPath) as! OtherMessageCell
//            view.profileLabel.text = userModel
            view.messageLabel.text = commnet.message;
            return view
        }
    }
    
    
    //MARK: - UIKeyBoardNotification
    @objc func keyboardWillShow(notification: NSNotification){
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        var keyboardHeight = keyboardSize.height
        
        if #available(iOS 11.0, *) {
            let bottomInset = view.safeAreaInsets.bottom
            keyboardHeight -= bottomInset
        }
        
        self.consSendButtonBMargin.constant = keyboardHeight + 2
        
        self.view.layoutIfNeeded()
        
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        self.consSendButtonBMargin.constant = 5
        self.view.layoutIfNeeded()
    }
}
