//
//  ThreadService.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 13.03.2024.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Threads = Components.Schemas.ThreadObject

protocol ThreadServiceProtocol {
    func getThread(uid: String) async throws -> Threads
}

actor ThreadService: ThreadServiceProtocol, Sendable {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getThread(uid: String) async throws -> Threads {
        let response = try await client.getThread(query: .init(uid: uid))
        return try response.ok.body.json
    }
}
