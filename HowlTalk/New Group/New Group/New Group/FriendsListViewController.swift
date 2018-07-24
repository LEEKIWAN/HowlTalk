//
//  FriendsListViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 12/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import NVActivityIndicatorView

class FriendsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var statusMessageLabel: UILabel!
    @IBOutlet weak var statusMessageButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        statusMessageButton.layer.cornerRadius = 3
        statusMessageButton.layer.borderWidth = 1
        statusMessageButton.layer.borderColor = UIColor.darkGray.cgColor
        statusMessageButton.titleLabel?.numberOfLines = 2
        
    }
    
    
    func setData(cellData: UserDTO) {
        nameLabel.text = cellData.userName
        
        if let profileImageURL = cellData.profileImageURL {
            let url = URL(string: profileImageURL)
            profileImageView.kf.setImage(with: url, placeholder:  #imageLiteral(resourceName: "iconmonstr-user-19-240"))
        }
        
        if let message = cellData.statusMessage, message.count > 0 {
            statusMessageButton.setTitle(message, for: .normal)
            statusMessageButton.isHidden = false
        }
        else {
            statusMessageButton.isHidden = true
        }
    }
    
}

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    
    var userArray: [UserDTO] = []
    let databaseRef = Database.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestFriendsList()
    }
    
    
    //MARK: - request
    func requestFriendsList() {
        startAnimating()
        
        databaseRef.child("USER_TB").observe(.value) { (snapshot) in
            self.userArray.removeAll()
            
            for child in snapshot.children {
                let data = child as! DataSnapshot
                let value = data.value as! [String : AnyObject]
                
                let userDTO = UserDTO(JSON: value)
                
//                let myUID = Auth.auth().currentUser?.uid
//                if userDTO?.userUID == myUID {              // 내 유저 아이디
//                    continue
//                }
                
                self.userArray.append(userDTO!) 
                
            }
            
            self.stopAnimating()
            self.tableView.reloadData()
        }
        
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chattingViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChattingViewController") as! ChattingViewController
        
        chattingViewController.destUID = self.userArray[indexPath.row].userUID
        
        self.navigationController?.pushViewController(chattingViewController, animated: true)
        
    }
    
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! FriendsListTableViewCell
        let cellData = self.userArray[indexPath.row]
        cell.setData(cellData: cellData)
        
        return cell
    }
}
