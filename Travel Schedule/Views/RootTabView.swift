//
//  RootTabView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct RootTabView: View {
    @Binding var schedule: Schedule
    @State var navPath: [ViewsRouter] = []
    @State var stories: [Story] = Story.mockData
    @StateObject var viewModel = TravelViewModel(networkService: NetworkService())

    var body: some View {
        NavigationStack(path: $navPath) {
            TabView {
                SearchTabView(
                    stories: $stories,
                    navPath: $navPath,
                    viewModel: viewModel
                )
                    .tabItem {
                        AppImages.Tabs.schedule
                    }
                SettingsView()
                    .tabItem {
                        AppImages.Tabs.settings
                    }
            }
            .task {
                viewModel.fetchData()
            }
            .accentColor(AppColors.LightDark.black)
            .toolbar(.visible, for: .tabBar)
            .navigationDestination(for: ViewsRouter.self) { pathValue in
                switch pathValue {
                    case .cityView:
                        CityView(
                            navPath: $navPath,
                            viewModel: viewModel
                        )
                            .toolbar(.hidden, for: .tabBar)
                    case .stationView:
                        StationView(
                            navPath: $navPath,
                            viewModel: viewModel
                        )
                            .toolbar(.hidden, for: .tabBar)
                    case .routeView:
                        RoutesListView(schedule: $schedule, viewModel: viewModel)
                            .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
}

#Preview {
    RootTabView(schedule: .constant(Schedule.sampleData))
        .environmentObject(SettingsViewModel(networkService: NetworkService()))
}
