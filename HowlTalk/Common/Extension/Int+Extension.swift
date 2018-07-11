//
//  Int+Extension.swift
//  HowlTalk
//
//  Created by 이기완 on 2018. 7. 11..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit

extension Int {
    var toDateString: String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let date = Date(timeIntervalSince1970: Double(self)/1000)
        
        return dateFormatter.string(from: date)
    }
}
