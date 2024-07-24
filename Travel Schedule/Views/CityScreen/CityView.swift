//
//  CityView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct CityView: View {
    @Binding var navPath: [ViewsRouter]
    @ObservedObject var destinationsViewModel: SearchScreenViewModel
    @ObservedObject var viewModel: CityScreenViewModel

    var body: some View {
        VStack(spacing: .zero) {
            SearchBarView(searchText: $viewModel.searchString)
            if viewModel.filteredCities.isEmpty {
                emptyView
            } else {
                listView
            }
            Spacer()
        }
        .setCustomNavigationBar(title: viewModel.title)
        .foregroundStyle(AppColors.LightDark.black)
        .task {
            viewModel.searchString = String()
            viewModel.fetchCities()
        }
        .overlay {
            if viewModel.state == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .ypBlackDuo))
            }
        }
    }
}

private extension CityView {
    var emptyView: some View {
        SearchResultEmptyView(notification: viewModel.notification)
    }

    var listView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: .zero) {
                ForEach(viewModel.filteredCities) { city in
                    NavigationLink(value: ViewsRouter.stationView) {
                        RowView(title: city.title)
                    }
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { destinationsViewModel.saveSelected(city: city) }
                    )
                    .setRowElement()
                    .padding(.vertical, AppSizes.Spacing.large)
                }
            }
        }
        .padding(.vertical, AppSizes.Spacing.large)
    }
}

#Preview {
    NavigationStack {
        CityView(
            navPath: .constant([]),
            destinationsViewModel: SearchScreenViewModel(destinations: Destination.sampleData),
            viewModel: CityScreenViewModel(store: [])
        )
    }
}
