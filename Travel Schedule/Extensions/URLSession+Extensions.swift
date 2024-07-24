//
//  URLSession+Extensions.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 23.07.2024.
//

import Foundation

// make it to prevent Warning: Passing argument of non-sendable type '(any URLSessionTaskDelegate)?' outside of actor-isolated context may introduce data races
extension URLSession {
    // this call is in a non-isolated context, so all is good :)
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(from: url, delegate: nil)
    }
}
