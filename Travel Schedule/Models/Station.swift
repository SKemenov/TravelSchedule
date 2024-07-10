//
//  Station.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import Foundation

// MARK: - Struct
struct Station: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let type: String
    let code: String
    let latitude: Double
    let longitude: Double
}

// MARK: - Mock data
extension Station {
    static let sampleData = [
        Station(title: "Киевский вокзал", type: "dummy", code: "dummy", latitude: 0, longitude: 0),
        Station(title: "Курский вокзал", type: "dummy", code: "dummy", latitude: 0, longitude: 0),
        Station(title: "Ярославский вокзал", type: "dummy", code: "dummy", latitude: 0, longitude: 0),
        Station(title: "Белорусский вокзал", type: "dummy", code: "dummy", latitude: 0, longitude: 0),
        Station(title: "Савеловский вокзал", type: "dummy", code: "dummy", latitude: 0, longitude: 0),
        Station(title: "Ленинградский вокзал", type: "dummy", code: "dummy", latitude: 0, longitude: 0)
    ]
}
