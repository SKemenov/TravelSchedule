//
//  String+Extensions.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 17.07.2024.
//

import Foundation

extension String {
    var getLocalizedShortDate: String {
        let apiDateFormatter = DateFormatter()
        apiDateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = apiDateFormatter.date(from: self) else { return "API date format wrong" }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter.string(from: date)
    }
    var returnTimeString: String {
        return String(self.suffix(14).prefix(5))
    }
}
