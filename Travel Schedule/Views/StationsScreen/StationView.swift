//
//  StationView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct StationView: View {
    // MARK: - Properties
    @Binding var navPath: [ViewsRouter]
    @ObservedObject var destinationsViewModel: SearchScreenViewModel
    @ObservedObject var viewModel: StationScreenViewModel

    // MARK: - Body
    var body: some View {
        VStack(spacing: .zero) {
            searchBar
            if viewModel.filteredStations.isEmpty {
                emptyView
            } else {
                stationsList
            }
            Spacer()
        }
        .setCustomNavigationBar(title: viewModel.title)
        .foregroundStyle(AppColors.LightDark.black)
        .task {
            fetchData()
        }
        .overlay {
            if viewModel.state == .loading {
                progressView
            }
        }
    }
}

// MARK: - Private views
private extension StationView {
    var searchBar: some View {
        SearchBarView(searchText: $viewModel.searchString)
    }

    var emptyView: some View {
        SearchResultEmptyView(notification: viewModel.notification)
    }

    var stationsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: .zero) {
                ForEach(viewModel.filteredStations) { station in
                    Button {
                        saveSelected(station: station)
                    } label: {
                        RowView(title: station.title)
                    }
                    .setRowElement()
                    .padding(.vertical, AppSizes.Spacing.large)
                }
            }
            .padding(.vertical, AppSizes.Spacing.large)
        }
    }

    var progressView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .ypBlackDuo))
    }
}

// MARK: - Private methods
private extension StationView {
    func saveSelected(station: Station) {
        destinationsViewModel.saveSelected(station: station)
        returnToRoot()
    }

    func returnToRoot() {
        navPath.removeAll()
    }

    func fetchData() {
        viewModel.searchString = String()
        viewModel.fetchStations()
    }
}

#Preview {
    NavigationStack {
        StationView(
            navPath: .constant([]),
            destinationsViewModel: SearchScreenViewModel(destinations: Destination.sampleData),
            viewModel: StationScreenViewModel(store: [], city: City.sampleData[0])
        )
    }
}
