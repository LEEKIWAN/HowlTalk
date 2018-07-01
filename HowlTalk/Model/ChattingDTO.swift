//
//  ChattingDTO.swift
//  HowlTalk
//
//  Created by 이기완 on 14/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit
import ObjectMapper

class ChattingDTO: Mappable {
    
    var users: Dictionary<String, Bool> = [ : ]             // 채팅방의 사람들
    var comments: Dictionary<String, CommentDTO> = [ : ]       // 채팅방의 대화내역
    
    required init?(map: Map) {
    }
    
    
    func mapping(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
    }
    

}
