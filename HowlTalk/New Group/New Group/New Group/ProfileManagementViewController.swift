//
//  ProfileManagementViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 7. 22..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit
import Firebase

class ProfileManagementViewController: UIViewController {

    var uid: String? = Auth.auth().currentUser?.uid
    var userInfo: UserDTO?
    
    @IBOutlet weak var statusMessageButton: UIButton!
    @IBOutlet weak var statusMessageLabel: UILabel!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.requestMyUserInfo()
    }
    
    func requestMyUserInfo() {
        Database.database().reference().child("USER_TB").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            //            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            let dataDict = snapshot.value as! [String : AnyObject]
            self.userInfo = UserDTO(JSON: dataDict)
            
            self.statusMessageLabel.text = self.userInfo?.statusMessage
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStatusMessageChangeView" {
            if let destViewController = segue.destination as? StatusMessageChangeViewController {
                destViewController.willSetStatusMessage = self.userInfo?.statusMessage
            }
        }
    }
    
}
