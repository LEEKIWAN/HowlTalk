//
//  ChattingDTO.swift
//  HowlTalk
//
//  Created by 이기완 on 14/06/2018.
//  Copyright © 2018 이기완. All rights reserved.
//

import UIKit

class ChattingDTO: NSObject {

    var UID: String?
    var destUID: String?
    
    var users: Dictionary<String, Bool> = [ : ]             // 채팅방의 사람들
    var comments: Dictionary<String, Comment> = [ : ]       // 채팅방의 대화내역
}

class Comment {
    public var uid: String?
    public var message: String?
    
}
