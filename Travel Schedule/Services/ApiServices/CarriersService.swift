//
//  CarriersService.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 13.03.2024.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Carriers = Components.Schemas.Carriers

protocol CarriersServiceProtocol {
    func getCarriers(code: Int, system: Components.Parameters.systemParam?) async throws -> Carriers
    func getCarriers(code: Int) async throws -> Carriers
}

actor CarriersService: CarriersServiceProtocol, Sendable {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getCarriers(code: Int) async throws -> Carriers {
        let response = try await client.getCarrier(query: .init(code: code))
        return try response.ok.body.json
    }

    func getCarriers(code: Int, system: Components.Parameters.systemParam?) async throws -> Carriers {
        let response = try await client.getCarrier(query: .init(code: code, system: system))
        return try response.ok.body.json
    }
}
