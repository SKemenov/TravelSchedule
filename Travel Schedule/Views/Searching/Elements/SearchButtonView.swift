//
//  SearchButtonView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 03.06.2024.
//

import SwiftUI

struct SearchButtonView: View {
    private let searchButtonTitle = "Найти"
    let destinations: [Destination]
    let route: ViewsRouter

    private var isDepartureReady: Bool {
        !destinations[.departure].city.title.isEmpty && !destinations[.departure].station.title.isEmpty
    }
    private var isArrivalReady: Bool {
        !destinations[.arrival].city.title.isEmpty && !destinations[.arrival].station.title.isEmpty
    }

    var body: some View {
        if isDepartureReady && isArrivalReady {
            NavigationLink(value: route) {
                ButtonTitleView(title: searchButtonTitle)
                    .setCustomButton(width: AppSizes.Width.searchButton, padding: .all)
            }
        }
    }

    init(for destinations: [Destination], showView route: ViewsRouter) {
        self.destinations = destinations
        self.route = route
    }
}

#Preview {
    SearchButtonView(for: Destination.sampleData, showView: ViewsRouter.cityView)
        .background(AppColors.Universal.red.opacity(0.5))
}
