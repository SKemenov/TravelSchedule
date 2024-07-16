//
//  Carrier.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 23.04.2024.
//

import Foundation

struct Carrier: Hashable, Identifiable {
    let id = UUID()
    let code: Int
    let title: String
    let logoUrl: String
    let placeholder: String
    let email: String
    let phone: String
    let contacts: String
}

extension Carrier {
    static let sampleData: [Carrier] = [
        Carrier(
            code: 129,
            title: "РЖД",
            logoUrl: "rzhd",
            placeholder: "airplane",
            email: "i.lozgkina@yandex.ru",
            phone: "+7 (904) 329-27-71",
            contacts: "Контактная информация"
        ),
        Carrier(
            code: 8565,
            title: "ФГК",
            logoUrl: "fgk",
            placeholder: "cablecar",
            email: "i.lozgkina@yandex.ru",
            phone: "+7 (904) 329-27-71",
            contacts: "Контактная информация"
        ),
        Carrier(
            code: 26,
            title: "Урал логистика",
            logoUrl: "ural",
            placeholder: "ferry",
            email: "i.lozgkina@yandex.ru",
            phone: "+7 (904) 329-27-71",
            contacts: "Контактная информация"
        )
    ]
}
