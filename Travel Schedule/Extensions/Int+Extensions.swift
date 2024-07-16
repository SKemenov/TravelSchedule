//
//  Int+Extensions.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 24.04.2024.
//

import Foundation

extension Int {
    static let departure = 0
    static let arrival = 1

    var getLocalizedInterval: String {
        let interval = self
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar

        formatter.unitsStyle = .full
        formatter.allowedUnits = interval > 60 * 60 * 24 // 1 day in seconds
        ? [.day, .hour]
        : [.hour, .minute]
        return formatter.string(from: TimeInterval(Double(interval))) ?? "today"
    }
}
