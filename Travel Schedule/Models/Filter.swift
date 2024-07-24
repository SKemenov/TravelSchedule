//
//  Filter.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 23.04.2024.
//

import Foundation

struct Filter: Hashable, Sendable {
    var isWithTransfers = true
    var isAtNight = true
    var isMorning = true
    var isAfternoon = true
    var isEvening = true
}

extension Filter {
    static let fullSearch = Filter()
    static let customSearch = Filter(isWithTransfers: false, isMorning: false)
}
