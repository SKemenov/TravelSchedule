//
//  StationsDownloader.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 11.07.2024.
//

import Foundation

actor StationsDownloader {
    private var cache: [Components.Schemas.Settlements] = []
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchData() async throws -> [Components.Schemas.Settlements] {
        if !cache.isEmpty { return cache }
        let service = StationsListService(client: networkService.client)
        let response = try await service.getStationsList()
        guard let countries = response.countries else { throw ErrorType.serverError }
        countries.forEach {
            if $0.title == "Украина" { return } // API has country's stations, but has no active routes
            $0.regions?.forEach {
                $0.settlements?.forEach { settlement in
                    cache.append(settlement)
                }
            }
        }
        return cache
    }
}
