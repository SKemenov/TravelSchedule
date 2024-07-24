//
//  CityScreenViewModel.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 23.07.2024.
//

import SwiftUI

@MainActor
final class CityScreenViewModel: ObservableObject {
    enum State: Equatable {
        case loading, loaded
    }
    let title = "Выбор города"
    let notification = "Город не найден"

    @Published var searchString = String()
    @Published private (set) var state: State = .loading

    var filteredCities: [City] {
        searchString.isEmpty
            ? cities
            : cities.filter { $0.title.lowercased().contains(searchString.lowercased()) }
    }

    private var cities: [City]
    private var store: [Components.Schemas.Settlements]

    init(
        store: [Components.Schemas.Settlements],
        cities: [City] = []
    ) {
        self.store = store
        self.cities = cities
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
}
