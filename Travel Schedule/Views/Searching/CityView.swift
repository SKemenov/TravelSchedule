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

    @Binding var navPath: [ViewsRouter]
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
                                viewModel.saveSelected(city: city)
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
        .task {
            searchString = String()
            viewModel.fetchCities()
        }
    }
}

#Preview {
    NavigationStack {
        CityView(
            navPath: .constant([]),
            viewModel: TravelViewModel(networkService: NetworkService())
        )
    }
}
