//
//  ChattingViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 14/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import Firebase

class ChattingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var chattingRoomID: String?
    
    var uid: String? = Auth.auth().currentUser?.uid
    
    var destUID: String?
    
    var commentsArray: [CommentDTO] = []
    
    var userModel: UserDTO?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isCreatedRoom()
    }

    @IBAction func onSendTouched(_ sender: UIButton) {
        self.createRoom()
    }


    func createRoom() {
        let userInfo :Dictionary<String, Any> = ["users" : [uid! : true, destUID! : true ] ]
        
        if chattingRoomID == nil {
            self.sendButton.isEnabled = false
            Database.database().reference().child("ChattingRoom_TB").childByAutoId().setValue(userInfo) { (error, reference) in
                if error != nil {
                    self.isCreatedRoom()
                }
            }
        }
        else {
            let value :Dictionary<String, Any> = [ "uid" : uid!, "message" : textField.text! ]
            
            Database.database().reference().child("ChattingRoom_TB").child(chattingRoomID!).child("comments").childByAutoId().setValue(value) { (error, reference) in
            }
        }
    }
    
    
    // 상대방 나인지 구분은 안되어ㅣㅇㅆ따.
    func isCreatedRoom() {
        Database.database().reference().child("ChattingRoom_TB").queryOrdered(byChild: "users/" + uid!).queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            for snapshot in snapshots {
                
                if let chattingRoomDic = snapshot.value as? [String : AnyObject] {
                    let chattingModel = ChattingDTO(JSON: chattingRoomDic)
                    
                    if chattingModel?.users[self.destUID!] == true {
                        self.chattingRoomID = snapshot.key
                        self.sendButton.isEnabled = true
                        
                        self.getMessageList()
                    }
                }
                
            }
            
        }
    }
    
    //MARK: - event
    @IBAction func onBackgroundTouched(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func getMessageList() {
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
//            snapshot.
//            self.userModel = UserDTO()
            
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        view.textLabel?.text = self.commentsArray[indexPath.row].message
        
        return view
    }
}

class MyMessageCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
}

class DestinationCell: UITableViewCell {
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
}
