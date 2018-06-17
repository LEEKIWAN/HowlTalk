//
//  ChattingViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 14/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import Firebase

class ChattingViewController: UIViewController {

    var chattingRoomID: String?
    
    var uid: String? = Auth.auth().currentUser?.uid
    
    var destUID: String?
    
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onSendTouched(_ sender: UIButton) {
        self.isCreatedRoom()
        self.createRoom()
    }


    func createRoom() {
        let userInfo: Dictionary<String, Any> = ["users" : [uid! : true, destUID! : true ] ]
        
        if chattingRoomID == nil {
            Database.database().reference().child("ChattingRoom_TB").childByAutoId().setValue(userInfo) { (error, reference) in
            }
        }
        else {
            let value :Dictionary<String, Any> = [ "comments" : [ "uid" : uid!, "message" : textField.text ] ]
            
            Database.database().reference().child("ChattingRoom_TB").child("comments").childByAutoId().setValue(value) { (error, reference) in
            }
        }
    }
    
    func isCreatedRoom() {
        Database.database().reference().child("ChattingRoom_TB").queryOrdered(byChild: "users/" + uid!).queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            for snapshot in snapshots {
                 self.chattingRoomID = snapshot.key
            }
            
        }
    }
}
