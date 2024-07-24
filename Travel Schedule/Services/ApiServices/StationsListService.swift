//
//  StationsListService.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 13.03.2024.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationsList = Components.Schemas.StationsList

protocol StationsListServiceProtocol {
    func getStationsList() async throws -> StationsList
}

actor StationsListService: StationsListServiceProtocol, Sendable {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getStationsList() async throws -> StationsList {
        let response = try await client.getStationsList(.init())
        let httpBody = try response.ok.body.html
        let data = try await Data(collecting: httpBody, upTo: Resources.maxJsonSize)
        let stationList = try JSONDecoder().decode(StationsList.self, from: data)
        return stationList
    }
}
