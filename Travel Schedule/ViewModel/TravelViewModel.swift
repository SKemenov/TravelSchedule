//
//  TravelViewModel.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 29.06.2024.
//

import Foundation

@MainActor
final class TravelViewModel: ObservableObject {
    @Published private (set) var state: State = .loading
    @Published private (set) var cities: [City]
    @Published private (set) var stations: [Station]

    @Published private (set) var routes: [Route] = []
    @Published private (set) var carriers: [Carrier] = []

    @Published private (set) var destinations: [Destination]
    @Published private (set) var direction: Int = .departure
    @Published private (set) var currentError: ErrorType = .serverError

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

    var isSearchButtonReady: Bool {
        !destinations[.departure].city.title.isEmpty &&
        !destinations[.departure].station.title.isEmpty &&
        !destinations[.arrival].city.title.isEmpty &&
        !destinations[.arrival].station.title.isEmpty
    }

    private let networkService: NetworkService
    private var store: [Components.Schemas.Settlements] = []
    private var stationsDownloader: StationsDownloader
    private var routesDownloader: RoutesDownloader

    init(
        networkService: NetworkService,
        cities: [City] = [],
        stations: [Station] = [],
        destinations: [Destination] = Destination.emptyDestination
    ) {
        self.networkService = networkService
        self.cities = cities
        self.stations = stations
        self.destinations = destinations
        self.stationsDownloader = StationsDownloader(networkService: networkService)
        self.routesDownloader = RoutesDownloader(networkService: networkService)
    }

    func fetchData() throws {
        Task {
            state = .loading
            do {
                store = try await stationsDownloader.fetchData()
                state = .loaded
            } catch {
                currentError = error.localizedDescription.contains("error 0.") ? .serverError : .connectionError
                state = .error
                throw currentError == .serverError ? ErrorType.serverError : ErrorType.connectionError
            }
        }
    }

    func fetchCities() {
        Task {
            state = .loading
            var convertedCities: [City] = []
            store.forEach { settlement in
                guard
                    let title = settlement.title,
                    let settlementCodes = settlement.codes,
                    let yandexCode = settlementCodes.yandex_code,
                    let settlementStations = settlement.stations else { return }
                let city = City(
                    title: title,
                    yandexCode: yandexCode,
                    stationsCount: settlementStations.count
                )
                convertedCities.append(city)
            }
            cities = convertedCities.sorted { $0.stationsCount > $1.stationsCount }
            state = .loaded
        }
    }

    func fetchStations(for city: City) {
        Task {
            state = .loading
            var convertedStations: [Station] = []
            var type: Set<String> = []
            store.forEach {
                if $0.codes?.yandex_code == city.yandexCode {
                    $0.stations?.forEach { settlementStation in
                        guard let station = convert(from: settlementStation) else { return }
                        type.insert(station.type)
                        convertedStations.append(station)
                    }
                }
            }
            let sortedStations = convertedStations.sorted { $0.title < $1.title }
            var customSortedStations = sortedStations.filter { $0.type == "airport" }
            customSortedStations += sortedStations.filter { $0.type == "train_station" }
            customSortedStations += sortedStations.filter { $0.type == "marine_station" }
            customSortedStations += sortedStations.filter { $0.type == "river_port" }
            customSortedStations += sortedStations.filter { $0.type == "bus_station" }
            customSortedStations += sortedStations.filter {
                $0.type != "airport" && $0.type != "train_station" && $0.type != "marine_station"
                && $0.type != "river_port" && $0.type != "bus_station"
            }
            stations = customSortedStations
            state = .loaded
        }
    }

    func swapDestinations() {
        (destinations[.departure], destinations[.arrival]) = (destinations[.arrival], destinations[.departure])
    }

    func setDirection(to direction: Int) {
        self.direction = direction
    }

    func saveSelected(city: City) {
        destinations[direction].city = city
    }

    func saveSelected(station: Station) {
        destinations[direction].station = station
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

    func resetRoutes() {
        routes = []
    }
}

private extension TravelViewModel {
    func convert(from carrier: Components.Schemas.Carrier, for type: String) {
        var placeholder = String()
        switch type {
            case "plane": placeholder = "airplane"
            case "train", "suburban": placeholder = "cablecar"
            case "water": placeholder = "ferry"
            default: placeholder = "bus"
        }
        let convertedCarrier = Carrier(
            code: carrier.code ?? 0,
            title: carrier.title ?? "ND",
            logoUrl: carrier.logo ?? "",
            placeholder: placeholder,
            email: carrier.email ?? "",
            phone: carrier.phone ?? "",
            contacts: carrier.contacts ?? ""
        )
        if convertedCarrier.code != 0 {
            carriers.append(convertedCarrier)
        }
    }

    func convert(from station: Components.Schemas.SettlementsStations) -> Station? {
        guard
            let type = station.station_type,
            let titleRawValue = station.title,
            let code = station.codes?.yandex_code,
            let longitudeRawValue = station.longitude,
            let latitudeRawValue = station.latitude else { return nil }
        let latitude = extract(latitude: latitudeRawValue)
        let longitude = extract(longitude: longitudeRawValue)
        if latitude == 0 && longitude == 0 { return nil }
        return Station(
            title: type == "airport" ? ["Аэропорт", titleRawValue].joined(separator: " ") : titleRawValue,
            type: type,
            code: code,
            latitude: latitude,
            longitude: longitude
        )
    }

    func extract(longitude: Components.Schemas.SettlementsStations.longitudePayload) -> Double {
        var coordinate: Double = 0
        switch longitude {
            case .case1(let doubleValue): coordinate = doubleValue
            case .case2: break
        }
        return coordinate
    }

    func extract(latitude: Components.Schemas.SettlementsStations.latitudePayload) -> Double {
        var coordinate: Double = 0
        switch latitude {
            case .case1(let doubleValue): coordinate = doubleValue
            case .case2: break
        }
        return coordinate
    }
}

extension TravelViewModel {
    enum State: Equatable {
        case loading, loaded, none, error
    }
}
