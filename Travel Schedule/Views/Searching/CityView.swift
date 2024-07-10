//
//  CityView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct CityView: View {
    private let title = "Выбор города"
    private let notification = "Город не найден"

    @Binding var schedule: Schedule
    @Binding var navPath: [ViewsRouter]
    @Binding var direction: Int
    @ObservedObject var viewModel: TravelViewModel

    @State private var searchString = String()

    private var searchingResults: [City] {
        searchString.isEmpty
            ? viewModel.cities
            : viewModel.cities.filter { $0.title.lowercased().contains(searchString.lowercased()) }
    }

    var body: some View {
        VStack(spacing: .zero) {
            SearchBarView(searchText: $searchString)
            if searchingResults.isEmpty {
                SearchResultEmptyView(notification: notification)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: .zero) {
                        ForEach(searchingResults) { city in
                            NavigationLink(value: ViewsRouter.stationView) {
                                RowSearchView(rowString: city.title)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                schedule.destinations[direction].city = city
                                print(city.yandexCode)
                            })
                            .setRowElement()
                            .padding(.vertical, AppSizes.Spacing.large)
                        }
                    }
                }
                .padding(.vertical, AppSizes.Spacing.large)
            }
            Spacer()
        }
        .setCustomNavigationBar(title: title)
        .foregroundStyle(AppColors.LightDark.black)
        .onAppear {
            searchString = String()
            viewModel.fetchCities()
        }
    }
}

#Preview {
    NavigationStack {
        CityView(
            schedule: .constant(Schedule.sampleData),
            navPath: .constant([]),
            direction: .constant(0),
            viewModel: TravelViewModel(networkService: NetworkService())
        )
    }
}
