//
//  NearestStationsService.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 10.03.2024.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestStations = Components.Schemas.Stations

protocol NearestStationsServiceProtocol {
    func getNearestStations(lat: Double, lng: Double, distance: Double) async throws -> NearestStations
}

actor NearestStationsService: NearestStationsServiceProtocol, Sendable {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getNearestStations(lat: Double, lng: Double, distance: Double) async throws -> NearestStations {
        let response = try await client.getNearestStations(
            query: .init(
                lat: lat,
                lng: lng,
                distance: distance
            )
        )
        return try response.ok.body.json
    }
}
