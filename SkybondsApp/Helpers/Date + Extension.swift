//
//  Date + Extension.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public extension Date {
    
//    func shortDate() -> Date {
//        let dateFormatter = formatterWithFormat(format: Constants.shortDateFormat)
//
//        return dateFormatter.date(from: dateFormatter.string(from: self))!
//    }
//
//    func stringDateWithFormat(format : String) -> String {
//        return formatterWithFormat(format: format).string(from: self)
//    }
    
    func stringDateWithFormatUTC(format : String) -> String {
        let formatter = formatterWithFormat(format: format)
        formatter.timeZone = TimeZone(identifier:"GMT")
        return formatter.string(from: self)
    }
    
//    func string(using format : String, isPosixLocale: Bool = false) -> String {
//        return formatterWithFormat(format: format, isPosixLocale: isPosixLocale).string(from: self)
//    }
//
//    func dateWithoutTime() -> Date {
//        let dateFormatter = formatterWithFormat(format: "yyyy-MM-dd")
//        let string = dateFormatter.string(from: self)
//        return dateFormatter.date(from: string)!
//    }
//
//    static var beforeYesterday: Date {
//        return Calendar.current.date(byAdding: .day, value: -2, to: Date().noon)!
//    }
//    static var yesterday: Date {
//        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
//    }
//    var noon: Date {
//        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
//    }
//
//    func isToday() -> Bool {
//        let today = Date().dateWithoutTime()
//        return self.dateWithoutTime().compare(today) == .orderedSame
//    }
//
    private func formatterWithFormat(format: String, isPosixLocale: Bool = false) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if isPosixLocale {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        return dateFormatter
    }
    
}
