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

    @Binding var schedule: Schedule
    @Binding var navPath: [ViewsRouter]
    @Binding var direction: Int
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
                ZStack {
                    ScrollView(.vertical) {
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
                    if viewModel.state == .loading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .ypBlackDuo))
                    }
                }
            }
            Spacer()
        }
        .setCustomNavigationBar(title: title)
        .foregroundStyle(AppColors.LightDark.black)
        .onAppear {
            searchString = String()
            viewModel.fetchStations(for: schedule.destinations[direction].city)
        }
    }
}

private extension StationView {
    func saveSelected(station: Station) {
        Task {
            print(#fileID, #function, station)
            let updatedStation = try await viewModel.fetchStationInfo(for: station)
            print(#fileID, #function, updatedStation)
            schedule.destinations[direction].station = updatedStation
            navPath.removeAll()
        }
    }
}

#Preview {
    NavigationStack {
        StationView(
            schedule: .constant(Schedule.sampleData),
            navPath: .constant([]),
            direction: .constant(.departure),
            viewModel: TravelViewModel(networkService: NetworkService())
        )
    }
}
