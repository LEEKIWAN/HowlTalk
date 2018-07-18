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
    @IBOutlet weak var timeLabel: UILabel!
}

class OtherMessageCell: UITableViewCell {

    var UID: String?
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    func setData(cellData: UserDTO) {
        profileLabel.text = cellData.userName
        UID = cellData.userUID
        
        if let profileImageURL = cellData.profileImageURL {
            let url = URL(string: profileImageURL)
            profileImageView.kf.setImage(with: url, placeholder:  #imageLiteral(resourceName: "iconmonstr-user-19-240"))
        }
    }
    
    func willHideProfileImage(_ willHide: Bool) {
        profileLabel.isHidden = willHide
        profileImageView.isHidden = willHide
    }
    
}


class ChattingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var consSendButtonBMargin: NSLayoutConstraint!
    
    @IBOutlet weak var consTextViewheight: NSLayoutConstraint!
    
    
    var chattingRoomID: String?
    
    var uid: String? = Auth.auth().currentUser?.uid
    var destUID: String?
    var commentsArray: [CommentDTO] = []
    var destUserModel: UserDTO?
    
    var chattingDTO: ChattingDTO?
    
    //MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.requestChattingRoomInformation()
        self.requestDestinationUserInfo()
        self.textView.layer.cornerRadius = self.textView.frame.size.height / 2
        self.sendButton.layer.cornerRadius = self.sendButton.frame.size.height / 2
        self.textView.textContainerInset = UIEdgeInsets(top: textView.textContainerInset.top, left: 10, bottom: textView.textContainerInset.bottom, right: 60)


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

    //MARK: - Request

    func requestSendMessage() {
        
        if chattingRoomID == nil {
            self.requestCreateChattingRoom()
        }
        else {
            let value :Dictionary<String, Any> = [
                "uid" : uid!,
                "message" : textView.text!,
                "timeStamp" : ServerValue.timestamp()
                
            ]
            
            self.textView.text = ""
            self.sendButton.isHidden = true
            self.textViewDidChange(self.textView)
            Database.database().reference().child("ChattingRoom_TB").child(chattingRoomID!).child("comments").childByAutoId().setValue(value) { (error, reference) in
            }
        }
    }
    
    
    func requestCreateChattingRoom() {
        let userInfo: Dictionary<String, Any> = [
            "users" : [uid! : true, destUID! : true ]
        ]
        
        Database.database().reference().child("ChattingRoom_TB").childByAutoId().setValue(userInfo) { (error, reference) in
            self.chattingRoomID = reference.key
            print(self.chattingRoomID!)
            
            self.requestSendMessage()
            self.requestMessageList()
        }
    }
        
    
    func requestChattingRoomInformation() {
        Database.database().reference().child("ChattingRoom_TB").queryOrdered(byChild: "users/" + uid!).queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            print("requestChattingRoomInformation : \(snapshots)")
            
            for item in snapshots {
                if let chattingRoom = item.value as? [String : AnyObject] {
                    self.chattingDTO = ChattingDTO(JSON: chattingRoom)
                    
                    if self.chattingDTO?.users[self.destUID!] == true {
                        self.chattingRoomID = item.key
                        self.requestMessageList()
                    }
                }
            }
        }
    }
    
    
    func requestMessageList() {
        Database.database().reference().child("ChattingRoom_TB").child(self.chattingRoomID!).child("comments").observe(.value) { (snapshot) in
            self.commentsArray.removeAll()
        
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
        
            for data in snapshots {
                let dataDict = data.value as! [String : AnyObject]
                let comment = CommentDTO(JSON: dataDict)
                
                self.commentsArray.append(comment!)
                self.tableView.reloadData()
            }
            
            self.tableView.scrollToRow(at: IndexPath(row: self.commentsArray.count - 1 , section: 0), at: .bottom, animated: false)
        }
    }
    
    
    func requestDestinationUserInfo() {
        Database.database().reference().child("USER_TB").child(self.destUID!).observeSingleEvent(of: .value) { (snapshot) in
//            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            let dataDict = snapshot.value as! [String : AnyObject]
            self.destUserModel = UserDTO(JSON: dataDict)
        }
    }
    
    //MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height < 84  {
            self.consTextViewheight.constant = textView.contentSize.height
            self.textView.setContentOffset(CGPoint.zero, animated: true)
            self.view.layoutIfNeeded()
        }
        
        
        if (textView.text?.count)! > 0 {
            sendButton.isHidden = false
        }
        else {
            sendButton.isHidden = true
        }
    }
    
    
    //MARK: - event
    @IBAction func onSendTouched(_ sender: UIButton) {
        self.requestSendMessage()
    }
    
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
        
        let comment = commentsArray[indexPath.row];
        
        if(comment.uid == uid) {
            let view = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            view.messageLabel.text = comment.message;
            
            if let time = comment.timeStamp {
                view.timeLabel.text = time.toDateString
            }
            
            return view
        }
        else {
            let view = tableView.dequeueReusableCell(withIdentifier: "OtherMessageCell", for: indexPath) as! OtherMessageCell
            let prevView = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? OtherMessageCell
            
            view.setData(cellData: self.destUserModel!)
            
            if let prevView = prevView {
                if(view.UID == prevView.UID) {
                    view.willHideProfileImage(true)
                }
            }
            else {
                view.willHideProfileImage(false)
            }

            
            view.messageLabel.text = comment.message;
            
            if let time = comment.timeStamp {
                view.timeLabel.text = time.toDateString
            }
            
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
        
        self.consSendButtonBMargin.constant = keyboardHeight
        
        self.view.layoutIfNeeded()
        
        //self.tableView.scrollToRow(at: IndexPath(row: self.commentsArray.count - 1 , section: 0), at: .bottom, animated: false)
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        self.consSendButtonBMargin.constant = 0
        self.view.layoutIfNeeded()
    }
    
    
}
