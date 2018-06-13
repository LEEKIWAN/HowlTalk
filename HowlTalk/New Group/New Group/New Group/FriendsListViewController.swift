//
//  FriendsListViewController.swift
//  HowlTalk
//
//  Created by 이기완 on 12/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher
import NVActivityIndicatorView

class FriendsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    func setData(cellData: UserDTO) {
        nameLabel.text = cellData.userName
        
        let url = URL(string: cellData.profileImageURL!)
        profileImageView.kf.setImage(with: url, placeholder:  #imageLiteral(resourceName: "iconmonstr-user-19-240"))
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
    
    func requestFriendsList() {
        startAnimating()
        
        databaseRef.child("USER_TB").observe(.value) { (snapshot) in
            self.userArray.removeAll()
            
            for child in snapshot.children {
                
                let data = child as! DataSnapshot
                let value = data.value as! NSDictionary
                
                let userID = value["userID"] as? String ?? ""
                let userEmail = value["userEmail"] as? String ?? ""
                let userName = value["userName"] as? String ?? ""
                let profileImageURL = value["profileImageURL"] as? String ?? ""
                
                let userDTO = UserDTO()
                
                userDTO.userID = userID
                userDTO.userName = userName
                userDTO.userEmail = userEmail
                userDTO.profileImageURL = profileImageURL
                self.userArray.append(userDTO)
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
//        tableView.deselectRow(at: indexPath, animated: true)
        
        let chattingViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChattingViewController")
        self.navigationController?.pushViewController(chattingViewController!, animated: true)
        
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
