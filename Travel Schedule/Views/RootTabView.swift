//
//  RootTabView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct RootTabView: View {
    // MARK: - Properties
    @State private var isError: Bool = false
    @StateObject var destinationsViewModel: SearchScreenViewModel
    @StateObject var rootViewModel: RootViewModel

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $rootViewModel.navPath) {
            TabView {
                searchScreenTab
                settingsScreenTab
            }
            .task {
                do {
                    try rootViewModel.fetchData()
                } catch {
                    isError = true
                }
            }
            .sheet(isPresented: $isError, onDismiss: {
                isError = false
            }, content: {
                errorView
            })
            .accentColor(AppColors.LightDark.black)
            .toolbar(.visible, for: .tabBar)
            .navigationDestination(for: ViewsRouter.self) { pathValue in
                switch pathValue {
                    case .cityView: citiesScreen
                    case .stationView: stationsScreen
                    case .routeView: routesScreen
                }
            }
        }
    }
}

// MARK: - Private Views
private extension RootTabView {
    var searchScreenTab: some View {
        SearchTabView(
            navPath: $rootViewModel.navPath,
            rootViewModel: rootViewModel,
            viewModel: destinationsViewModel
        )
        .tabItem {
            AppImages.Tabs.schedule
        }
    }

    var settingsScreenTab: some View {
        SettingsView()
            .tabItem {
                AppImages.Tabs.settings
            }
    }

    var errorView: some View {
        ErrorView(errorType: rootViewModel.currentError)
    }

    var citiesScreen: some View {
        CityView(
            navPath: $rootViewModel.navPath,
            destinationsViewModel: destinationsViewModel,
            viewModel: CityScreenViewModel(store: rootViewModel.store)
        )
        .toolbar(.hidden, for: .tabBar)
    }

    var stationsScreen: some View {
        StationView(
            navPath: $rootViewModel.navPath,
            destinationsViewModel: destinationsViewModel,
            viewModel: StationScreenViewModel(
                store: rootViewModel.store,
                city: destinationsViewModel.destinations[
                    destinationsViewModel.direction
                ].city
            )
        )
        .toolbar(.hidden, for: .tabBar)
    }

    var routesScreen: some View {
        RoutesListView(
            viewModel: RoutesScreenViewModel(
                destinations: destinationsViewModel.destinations,
                routesDownloader: rootViewModel.routesDownloader,
                imageDownloader: rootViewModel.imageDownloader
            )
        )
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    RootTabView(
        destinationsViewModel: SearchScreenViewModel(),
        rootViewModel: RootViewModel(networkService: NetworkService())
    )
        .environmentObject(SettingsViewModel(networkService: NetworkService()))
}
