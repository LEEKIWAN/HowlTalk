//
//  NotificationMsgDTO.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 7. 20..
//  Copyright © 2018년 이기완. All rights reserved.
//

import ObjectMapper

class NotificationMsgDTO: Mappable {
    public var title: String?
    public var body: String?
    
    init () {
        
    }
    
    required init?(map: Map) {
    }
    
    
    func mapping(map: Map) {
        title <- map["title"]
        body <- map["body"]
    }
    
}
