//
//  StationView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct StationView: View {
    private let title = "Выбор станции"
    private let notification = "Станция не найдена"

    @Binding var navPath: [ViewsRouter]
    @ObservedObject var viewModel: TravelViewModel

    @State private var searchString = String()

    private var searchingResults: [Station] {
        searchString.isEmpty
            ? viewModel.stations
            : viewModel.stations.filter { $0.title.lowercased().contains(searchString.lowercased()) }
    }

    var body: some View {
        VStack(spacing: .zero) {
            SearchBarView(searchText: $searchString)
            if searchingResults.isEmpty {
                SearchResultEmptyView(notification: notification)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: .zero) {
                        ForEach(searchingResults) { station in
                            Button {
                                saveSelected(station: station)
                            } label: {
                                RowSearchView(rowString: station.title)
                            }
                            .setRowElement()
                            .padding(.vertical, AppSizes.Spacing.large)
                        }
                    }
                    .padding(.vertical, AppSizes.Spacing.large)
                }
            }
            Spacer()
        }
        .setCustomNavigationBar(title: title)
        .foregroundStyle(AppColors.LightDark.black)
        .task {
            searchString = String()
            viewModel.fetchStations(for: viewModel.destinations[viewModel.direction].city)
        }
        .overlay {
            if viewModel.state == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .ypBlackDuo))
            }
        }
    }
}

private extension StationView {
    func saveSelected(station: Station) {
        viewModel.saveSelected(station: station)
        returnToRoot()
    }

    func returnToRoot() {
        navPath.removeAll()
    }
}

#Preview {
    NavigationStack {
        StationView(
            navPath: .constant([]),
            viewModel: TravelViewModel(networkService: NetworkService())
        )
    }
}
