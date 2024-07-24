//
//  RoutesScreenViewModel.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 22.07.2024.
//

import SwiftUI

@MainActor
final class RoutesScreenViewModel: ObservableObject {
    enum State: Equatable {
        case loading, loaded, none, error
    }

    let notification = "Вариантов нет"
    let buttonTitle = "Уточнить время"

    @Published var filter = Filter()
    @Published private(set) var isError: Bool = false

    @Published private (set) var state: State = .loading
    @Published private (set) var carriers: [Carrier] = []
    @Published private (set) var currentError: ErrorType = .serverError

    @Published private (set) var destinations: [Destination]

    private (set) var routes: [Route]
    private (set) var routesDownloader: RoutesDownloader
    private (set) var imageDownloader: ImageDownloader

    var departure: String {
        destinations[.departure].station.title.contains(destinations[.departure].city.title)
        ? destinations[.departure].station.title
        : destinations[.departure].city.title + " (" + destinations[.departure].station.title + ")"
    }

    var arrival: String {
        destinations[.arrival].station.title.contains(destinations[.arrival].city.title)
        ? destinations[.arrival].station.title
        : destinations[.arrival].city.title + " (" + destinations[.arrival].station.title + ")"
    }

    var filteredRoutes: [Route] {
        let complexRoutes = filter.isWithTransfers
            ? routes
            : routes.filter { $0.isDirect == true }
        var allRoutes = filter.isAtNight
        ? complexRoutes.filter { $0.departureTime.starts(with: /0[0-5]/) }
        : []
        allRoutes += filter.isMorning
        ? complexRoutes.filter { $0.departureTime.starts(with: /0[6-9]/) || $0.departureTime.starts(with: /1[0-1]/) }
        : []
        allRoutes += filter.isAfternoon
        ? complexRoutes.filter { $0.departureTime.starts(with: /1[2-8]/) }
        : []
        allRoutes += filter.isEvening
        ? complexRoutes.filter { $0.departureTime.starts(with: /19/) || $0.departureTime.starts(with: /2[0-4]/) }
        : []
        return allRoutes.sorted { $0.date < $1.date }
    }

    init(
        destinations: [Destination],
        routes: [Route] = [],
        routesDownloader: RoutesDownloader,
        imageDownloader: ImageDownloader
    ) {
        self.destinations = destinations
        self.routes = routes
        self.routesDownloader = routesDownloader
        self.imageDownloader = imageDownloader
    }

    func searchRoutes() async throws {
        state = .loading
        var segments: [Components.Schemas.Segment] = []
        do {
            segments = try await routesDownloader.fetchData(
                from: destinations[.departure].station,
                to: destinations[.arrival].station
            )
        } catch {
            currentError = error.localizedDescription.contains("error 16.") ? .serverError : .connectionError
            state = .error
            throw currentError == .serverError ? ErrorType.serverError : ErrorType.connectionError
        }

        var convertedRoutes: [Route] = []
        segments.forEach { segment in
            let hasTransfers = segment.has_transfers ?? false
            if !hasTransfers {
                guard let duration = segment.duration else { return }
                let uid = segment.thread?.uid ?? "ND"
                let type = segment.from?.transport_type ?? "ND"
                guard
                    let carrier = segment.thread?.carrier,
                    let carrierCode = carrier.code else { return }

                if carriers.filter({ $0.code == carrierCode }).isEmpty {
                    convert(from: carrier, for: type)
                }

                let route = Route(
                    code: uid,
                    date: segment.start_date ?? "today",
                    departureTime: (segment.departure ?? "").returnTimeString,
                    arrivalTime: (segment.arrival ?? "").returnTimeString,
                    durationTime: duration.getLocalizedInterval,
                    connectionStation: String(),
                    carrierCode: carrierCode
                )
                convertedRoutes.append(route)
            }
        }
        routes = convertedRoutes
        state = routes.isEmpty ? .none : .loaded
    }

    func convert(from carrier: Components.Schemas.Carrier, for type: String) {
        var placeholder = String()
        switch type {
            case "plane": placeholder = "airplane.circle"
            case "train", "suburban": placeholder = "cablecar"
            case "water": placeholder = "ferry"
            default: placeholder = "bus.fill"
        }
        let convertedCarrier = Carrier(
            code: carrier.code ?? 0,
            title: carrier.title ?? "ND",
            logoUrl: carrier.logo ?? "",
            logoSVGUrl: carrier.logo_svg ?? "",
            placeholder: placeholder,
            email: carrier.email ?? "",
            phone: carrier.phone ?? "",
            contacts: carrier.contacts ?? ""
        )
        if convertedCarrier.code != 0 {
            carriers.append(convertedCarrier)
        }
    }
}
