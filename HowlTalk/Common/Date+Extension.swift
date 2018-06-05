//
//  Date+Extension.swift
//  CalendarWidget
//
//  Created by 이기완 on 2018. 5. 5..
//  Copyright © 2018년 이기완. All rights reserved.
//

import UIKit

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
