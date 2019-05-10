//
//  Date+Ex.swift
//  Base Extensions
//
//  Created by Dat Ng on 8/22/18.
//  Copyright © 2018 datnm (laohac83x@gmail.com). All rights reserved.
//

import Foundation
import UIKit

public extension Date {
    // "yyyy-MM-dd'T'HH:mm:ssZZZZZ", Locale(identifier: "en_US_POSIX")
    func toStringFormat8601() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
    
    func toString(format dateFormat: String, timeZone: TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if timeZone != nil { dateFormatter.timeZone = timeZone }
        return dateFormatter.string(from: self)
    }
    
    func toStringJpTimeZone(format dateFormat: String) -> String {
        return self.toString(format: dateFormat, timeZone: TimeZone.jp)
    }
    
    var isFirstDayOfMonth: Bool {
        return Calendar.current.dateComponents(Set<Calendar.Component>([.day]), from: self).day == 1
    }
    
    var isLastDayOfMonth: Bool {
        return self.addingTimeInterval(24 * 60 * 60).isFirstDayOfMonth
    }
    
    var isFirstMonthOfYear: Bool {
        return Calendar.current.dateComponents(Set<Calendar.Component>([.month]), from: self).month == 1
    }
    
    var day: Int {
        return Calendar.current.dateComponents(Set<Calendar.Component>([.day]), from: self).day ?? 0
    }
    
    var month: Int {
        return Calendar.current.dateComponents(Set<Calendar.Component>([.month]), from: self).month ?? 0
    }
    
    var year: Int {
        return Calendar.current.dateComponents(Set<Calendar.Component>([.year]), from: self).year ?? 0
    }
    
    var second: Int {
        return Calendar.current.dateComponents(Set<Calendar.Component>([.second]), from: self).second ?? 0
    }
    
    var minute: Int {
        return Calendar.current.dateComponents(Set<Calendar.Component>([.minute]), from: self).minute ?? 0
    }
    
    var hour: Int {
        return Calendar.current.dateComponents(Set<Calendar.Component>([.hour]), from: self).hour ?? 0
    }
    
    func isEqualDateIgnoreTime(toDate: Date?) -> Bool {
        if let dateCompare = toDate {
            return self.day == dateCompare.day && self.month == dateCompare.month && self.year == dateCompare.year
        }
        return false
    }
    
    var isToday: Bool {
        return self.isEqualDateIgnoreTime(toDate: Date())
    }
    
    func addingDays(_ days: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
    }
}

public extension TimeZone {
    init?(hoursFromGMT: Int) {
        self.init(secondsFromGMT: hoursFromGMT * 3600)
    }
    
    static var jp: TimeZone = TimeZone(hoursFromGMT: 9) ?? TimeZone.current
}
