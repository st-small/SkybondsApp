//
//  String + Extension.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public extension String {
    func date(using format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let formater = DateFormatter()
        formater.locale = Locale(identifier: "en_US_POSIX")
        formater.dateFormat = format
        formater.timeZone = TimeZone(secondsFromGMT: 0)
        let date = formater.date(from: self)
        return date
    }
}
