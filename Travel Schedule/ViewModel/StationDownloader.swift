//
//  StationDownloader.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 11.07.2024.
//

import Foundation

actor StationDownloader {
    private var cache: [String: Station] = [:]
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func details(for station: Station) async throws -> Station? {
        let service = NearestStationsService(client: networkService.client)
        let coordinate = [String(station.latitude), String(station.longitude)].joined(separator: "-")
        print("\n", #fileID, #function, coordinate)
        if let cached = cache[coordinate] {
            print("\n", #fileID, #function, "Found in cache:", cached)
            return cached
        }

        let response = try await service.getNearestStations(
            lat: station.latitude,
            lng: station.longitude,
            distance: 0.3
        )
        print("\n", #fileID, #function, "taken response, total ", response.pagination?.total)
        guard let stations = response.stations else { throw ErrorType.connectionError }
        if stations.isEmpty { throw ErrorType.serverError }
        print("\n", #fileID, #function, "taken stations, total", stations.count)
        let station = stations.sorted { $0.distance ?? 1000 < $1.distance ?? 1000 }[0]
        print("\n", #fileID, #function, "this station", station)
        let type = station.station_type ?? ""
        let titleRawValue = station.title ?? ""
        let popularTitleRawValue = station.popular_title ?? ""
        let title = !popularTitleRawValue.isEmpty
            ? popularTitleRawValue
            : type == "airport"
                ? ["аэропорт", titleRawValue].joined(separator: " ")
                : titleRawValue
        let updatedStation = Station(
            title: title,
            type: type,
            code: station.code ?? "",
            latitude: station.lat ?? 0,
            longitude: station.lng ?? 0
        )
        print("\n", #fileID, #function, "updated station", updatedStation)

        cache[coordinate] = cache[coordinate, default: updatedStation]
        print("\n", #fileID, #function, "final return after cache", cache[coordinate])
        return cache[coordinate]
    }
}
