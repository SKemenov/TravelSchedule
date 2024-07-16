//
//  RoutesDownloader.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 12.07.2024.
//

import Foundation

actor RoutesDownloader {
//    private var cache: [String: Station] = [:]
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchData(
        from departure: Station,
        to arrival: Station
    ) async throws -> ([Route], [Int: Components.Schemas.Carrier]) {
        print("\n", #fileID, #function, "start searching routs from ", departure.code, " to ", arrival.code)
        let service = SearchService(client: networkService.client)
        let response = try await service.getSearches(from: departure.code, to: arrival.code, with: true)
        guard let segments = response.segments else { throw ErrorType.connectionError }
        if segments.isEmpty { return ([], [:]) }

        var routes: [Route] = []
        var carriers: [Int: Components.Schemas.Carrier] = [:]
        segments.forEach { segment in
            guard let duration = segment.duration else { return }
            let uid = segment.thread?.uid ?? "ND"
            guard let carrier = segment.thread?.carrier  else { return }
            let carrierCode = carrier.code ?? 0
            carriers[carrierCode] = carriers[carrierCode, default: carrier]

//            print(#fileID, #function, carrier)
            let route = Route(
                code: uid,
                date: segment.start_date ?? "today",
                departureTime: (segment.departure ?? "").returnTimeString,
                arrivalTime: (segment.arrival ?? "").returnTimeString,
                durationTime: duration.getLocalizedInterval,
                connectionStation: String(),
                carrierCode: carrierCode
            )
            routes.append(route)
        }
        return (routes, carriers)
    }

    private func getThread(for uid: String) async throws -> (String, String) {
        do {
            let threadService = ThreadService(client: networkService.client)
            let response = try await threadService.getThread(uid: uid)
            guard
                let stops = response.stops,
                let first = stops.first,
                let departure = first.departure,
                let last = stops.last,
                let arrival = last.arrival else { throw ErrorType.serverError }
            return (
                String(departure.suffix(8).prefix(5)),
                String(arrival.suffix(8).prefix(5))
            )
        } catch {
            print(error.localizedDescription)
            throw ErrorType.serverError
        }
    }
}
