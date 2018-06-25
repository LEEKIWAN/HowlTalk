//
//  CommentDTO.swift
//  HowlTalk
//
//  Created by 이기완 on 19/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import ObjectMapper

class CommentDTO: Mappable {
    public var uid: String?
    public var message: String?
    
    
    required init?(map: Map) {
    }
    
    
    func mapping(map: Map) {
        uid <- map["uid"]
        message <- map["message"]
    }
    
}
