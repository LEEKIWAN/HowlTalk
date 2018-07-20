//
//  NotificationDTO.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 7. 20..
//  Copyright © 2018년 이기완. All rights reserved.
//

import ObjectMapper

class NotificationDTO: Mappable {
    public var to: String?
    public var notification: NotificationMsgDTO = NotificationMsgDTO()
    
    
    init () {
        
    }
    
    required init?(map: Map) {
    }
    
    
    func mapping(map: Map) {
        to <- map["to"]
        notification <- map["notification"]
    }
    
    
}
