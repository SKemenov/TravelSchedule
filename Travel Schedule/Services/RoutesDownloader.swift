//
//  RoutesDownloader.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 12.07.2024.
//

import Foundation

actor RoutesDownloader {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchData(from departure: Station, to arrival: Station) async throws -> [Components.Schemas.Segment] {
        let service = SearchService(client: networkService.client)
        let response = try await service.getSearches(from: departure.code, to: arrival.code, with: true)
        guard let segments = response.segments else { throw ErrorType.serverError }
        return segments
    }
}
