//
//  ErrorType.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 22.04.2024.
//

import Foundation

enum ErrorType: Int, CaseIterable, Error {
    case serverError = 0
    case connectionError

    var description: String {
        switch self {
            case .serverError: return String(localized: "Ошибка сервера")
            case .connectionError: return String(localized: "Нет интернета")
        }
    }

    var imageName: String {
        switch self {
            case .serverError: return "serverError"
            case .connectionError: return "noInternet"
        }
    }
}
