//
//  FriendsDTO.swift
//  HowlTalk
//
//  Created by 이기완 on 12/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import ObjectMapper


class UserDTO: Mappable {
    
    var userUID: String?
    var userID: String?
    var userName: String?
    var userEmail: String?
    var profileImageURL: String?
    var pushToken: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userUID <- map["userUID"]
        userID <- map["userID"]
        userName <- map["userName"]
        userEmail <- map["userEmail"]
        profileImageURL <- map["profileImageURL"]
    }

    
}
