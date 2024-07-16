//
//  Route.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 23.04.2024.
//

import Foundation

struct Route: Hashable, Identifiable {
    let id = UUID()
    let code: String
    let date: String
    var departureTime: String
    var arrivalTime: String
    var durationTime: String
    let connectionStation: String
    var isDirect: Bool {
        connectionStation.isEmpty
    }
    let carrierCode: Int
//    let carrierID: UUID
}

extension Route {
    static let sampleData: [Route] = [
        Route(
            code: "020U_6_2",
            date: "14 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            durationTime: "20 часов",
            connectionStation: "Костроме", 
            carrierCode: 129
//            carrierID: Carrier.sampleData[0].id
        ),
        Route(
            code: "020U_6_2",
            date: "15 января",
            departureTime: "01:15",
            arrivalTime: "09:00",
            durationTime: "9 часов",
            connectionStation: "",
            carrierCode: 129
        ),
        Route(
            code: "020U_6_2",
            date: "16 января",
            departureTime: "12:30",
            arrivalTime: "21:00",
            durationTime: "9 часов",
            connectionStation: "",
            carrierCode: 129
        ),
        Route(
            code: "020U_6_2",
            date: "17 января",
            departureTime: "22:30",
            arrivalTime: "08:15",
            durationTime: "20 часов",
            connectionStation: "Костроме",
            carrierCode: 129
        ),
        Route(
            code: "020U_6_2",
            date: "17 января",
            departureTime: "18:00",
            arrivalTime: "01:00",
            durationTime: "7 часов",
            connectionStation: "",
            carrierCode: 129
        )
    ]
}
