//
//  NearestSettlementService.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 13.03.2024.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Settlement = Components.Schemas.Settlement

protocol NearestSettlementServiceProtocol {
    func getNearestSettlement(lat: Double, lng: Double, distance: Double) async throws -> Settlement
}

actor NearestSettlementService: NearestSettlementServiceProtocol, Sendable {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getNearestSettlement(lat: Double, lng: Double, distance: Double) async throws -> Settlement {
        let response = try await client.getNearestSettlement(
            query: .init(
                lat: lat,
                lng: lng,
                distance: distance
            )
        )
        return try response.ok.body.json
    }
}
