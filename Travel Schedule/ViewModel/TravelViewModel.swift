//
//  TravelViewModel.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 29.06.2024.
//

import Foundation

@MainActor
final class TravelViewModel: ObservableObject {
    @Published var copyrightInfo = String()
    @Published private (set) var cities: [City] = []
    @Published private (set) var stations: [Station] = []
    @Published private (set) var state: State = .loading
    private let networkService: NetworkService
    private var store: StationsList?

    init(networkService: NetworkService) {
        self.networkService = networkService
        self.getCopyright()
        self.fetchData()
    }

    func getCopyright() {
        Task {
            let service = CopyrightService(client: networkService.client)
            do {
                let response = try await service.getCopyright()
                copyrightInfo = response.copyright?.text ?? "dummy string"
            } catch {
                print(error.localizedDescription)
                throw ErrorType.connectionError
            }
        }
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
}

private extension TravelViewModel {
    func convert(from station: Components.Schemas.SettlementsStations) -> Station? {
        guard
            let type = station.station_type,
            type == "airport" || type == "train_station" || type == "river_port",
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
        case loading, loaded, error(ErrorType)

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
