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
    func getCarriers(code: String, system: Operations.getCarrier.Input.Query.systemPayload?) async throws -> Carriers
}

final class CarriersService: CarriersServiceProtocol {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getCarriers(code: String, system: Operations.getCarrier.Input.Query.systemPayload?) async throws -> Carriers {
        let response = try await client.getCarrier(query: .init(code: code, system: system))
        return try response.ok.body.json
    }
}
