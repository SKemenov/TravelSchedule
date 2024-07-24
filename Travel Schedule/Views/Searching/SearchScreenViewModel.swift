//
//  SearchScreenViewModel.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 24.07.2024.
//

import SwiftUI

@MainActor
final class SearchScreenViewModel: ObservableObject {
    let searchButtonTitle = "Найти"
    let dummyDirection = ["Откуда", "Куда"]

    @Published private (set) var destinations: [Destination]
    @Published private (set) var direction: Int = .departure
    @Published private (set) var currentError: ErrorType = .serverError

    var isSearchButtonReady: Bool {
        !destinations[.departure].city.title.isEmpty &&
        !destinations[.departure].station.title.isEmpty &&
        !destinations[.arrival].city.title.isEmpty &&
        !destinations[.arrival].station.title.isEmpty
    }

    init(
        destinations: [Destination] = Destination.emptyDestination
    ) {
        self.destinations = destinations
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
}
