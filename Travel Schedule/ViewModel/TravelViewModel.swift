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
    var isSearchButtonReady: Bool {
        !destinations[.departure].city.title.isEmpty &&
        !destinations[.departure].station.title.isEmpty &&
        !destinations[.arrival].city.title.isEmpty &&
        !destinations[.arrival].station.title.isEmpty
    }

    private let networkService: NetworkService
    private var store: [Components.Schemas.Settlements] = []

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
    }

    func fetchData() {
        Task {
            state = .loading
            let service = StationsListService(client: networkService.client)
            let stations = try await service.getStationsList()
            store = stations
            state = .loaded
        }
    }

    func fetchCities() {
        Task {
            state = .loading
            var newList: [City] = []
            guard
                let store,
                let countries = store.countries else { return }
            countries.forEach {
                $0.regions?.forEach {
                    $0.settlements?.forEach { settlement in
                        guard
                            let settlementTitle = settlement.title,
                            let settlementCodes = settlement.codes,
                            let yandexCode = settlementCodes.yandex_code,
                            let settlementStations = settlement.stations else { return }
                        newList.append(
                            City(
                                title: settlementTitle,
                                yandexCode: yandexCode,
                                stationsCount: settlementStations.count
                            )
                        )
                    }
                }
            }
            cities = newList.sorted { $0.stationsCount > $1.stationsCount }
            state = .loaded
        }
    }

    func fetchStations(for city: City) {
        Task {
            state = .loading
            var newList: [Station] = []
            guard
                let store,
                let countries = store.countries else { return }
            countries.forEach {
                $0.regions?.forEach {
                    $0.settlements?.forEach {
                        if $0.codes?.yandex_code == city.yandexCode {
                            $0.stations?.forEach { station in
                                guard let station = convert(from: station) else { return }
                                newList.append(station)
                            }
                        }
                    }
                }
            }
            stations = newList.sorted { $0.title < $1.title }
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

    func saveSelected(station: Station) async throws {
        state = .loading
        print(#fileID, #function, state)
        let service = NearestStationsService(client: networkService.client)
        let response = try await service.getNearestStations(
            lat: station.latitude,
            lng: station.longitude,
            distance: 0.1
        )
        guard let stations = response.stations else { throw ErrorType.serverError }

        print(#fileID, #function, "taken stations", stations.count)
        let filteredStations = stations.filter { $0.station_type == station.type }
        print(#fileID, #function, "filtered to", filteredStations.count, filteredStations)
        if filteredStations.isEmpty { throw ErrorType.serverError }
        guard
            let station = filteredStations.first,
            let type = station.station_type,
            let titleRawValue = station.title,
            let title = station.popular_title != nil
                ? station.popular_title
                : type == "airport" ? ["аэропорт", titleRawValue].joined(separator: " ") : titleRawValue,
            let code = station.code,
            let latitude = station.lat,
            let longitude = station.lng else { throw ErrorType.serverError }
        let newStation = Station(title: title, type: type, code: code, latitude: latitude, longitude: longitude)
        state = .loaded
        print(#fileID, #function, state, newStation)
        return newStation
    }
}

private extension TravelViewModel {
    func convert(from station: Components.Schemas.SettlementsStations) -> Station? {
        guard
            let type = station.station_type,
            type == "airport" || type == "train_station" || type == "river_port", // made list a little bit shorter
            let titleRawValue = station.title,
            let longitudeRawValue = station.longitude,
            let latitudeRawValue = station.latitude else { return nil }
        let latitude = extract(latitude: latitudeRawValue)
        let longitude = extract(longitude: longitudeRawValue)
        let title = type == "airport" ? ["аэропорт", titleRawValue].joined(separator: " ") : titleRawValue
        if latitude == 0 && longitude == 0 { return nil }
        return Station(
            title: title,
            type: type,
            code: "",
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
        case loading, loaded, error //error(ErrorType)

//        static func == (lhs: TravelViewModel.State, rhs: TravelViewModel.State) -> Bool {
//            switch (lhs, rhs) {
//                case (.loading, .loading): true
//                case (.loaded, .loaded): true
//                case (.error(let lhsError), .error(let rhsError)): lhsError == rhsError
//                default: false
//            }
//        }
    }
}
