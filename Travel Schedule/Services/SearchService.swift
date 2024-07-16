//
//  SearchService.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 13.03.2024.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Searches = Components.Schemas.SearchObject

protocol SearchServiceProtocol {
    func getSearches(from: String, to: String, with transfers: Bool) async throws -> Searches
}

final class SearchService: SearchServiceProtocol {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getSearches(from fromStation: String, to toStation: String, with transfers: Bool) async throws -> Searches {
//        let date = Date.now.formatted(date: .numeric, time: .omitted)
        let date = String(Date.now.ISO8601Format().prefix(10))
        print(#fileID, #function, date)
        let response = try await client.getSearches(
            query: .init(from: fromStation, to: toStation, date: date, transfers: transfers)
        )
        return try response.ok.body.json
    }
}
