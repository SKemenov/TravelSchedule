//
//  CopyrightService.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 12.03.2024.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Copyright = Components.Schemas.CopyrightObject

protocol CopyrightServiceProtocol {
    func getCopyright() async throws -> Copyright
}

actor CopyrightService: CopyrightServiceProtocol, Sendable {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getCopyright() async throws -> Copyright {
        let response = try await client.getCopyright(query: .init())
        return try response.ok.body.json
    }
}
