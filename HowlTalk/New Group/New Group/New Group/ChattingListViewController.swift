//
//  ChattingListViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 7. 9..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import Firebase

class ChattingRoom: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
}

class ChattingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var uid: String? = Auth.auth().currentUser?.uid
    
    var chattingRoomArray: [ChattingDTO] = []
    var destUsers: [String] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestChattingRoomList()
    }
    
    
    func requestChattingRoomList() {
        Database.database().reference().child("ChattingRoom_TB").queryOrdered(byChild: "users/" + uid!).queryEqual(toValue: true).observeSingleEvent(of: .value) { (snapshot) in
            
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            for item in snapshots {
                if let chattingRoom = item.value as? [String : AnyObject] {
                    let chattingDTO = ChattingDTO(JSON: chattingRoom)
                    
                    self.chattingRoomArray.append(chattingDTO!)
                }
                
            }
            
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chattingRoomArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChattingRoom", for: indexPath)
        
        var destinationUid: String?
        
        for item in chattingRoomArray[indexPath.row].users {
            if(item.key != self.uid) {
                destinationUid = item.key
                
            }
        }
        
        return cell
    }

    
}


