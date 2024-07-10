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
