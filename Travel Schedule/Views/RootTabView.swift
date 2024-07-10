//
//  RootTabView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct RootTabView: View {
    @Binding var schedule: Schedule
//    @State var schedule = Schedule.sampleData
    @State var navPath: [ViewsRouter] = []
    @State var direction: Int = .departure
    @State var stories: [Story] = Story.mockData
    @StateObject var viewModel = TravelViewModel(networkService: NetworkService())

    var body: some View {
        NavigationStack(path: $navPath) {
            TabView {
                SearchTabView(
                    stories: $stories,
                    schedule: $schedule,
                    navPath: $navPath,
                    direction: $direction,
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
            .accentColor(AppColors.LightDark.black)
            .toolbar(.visible, for: .tabBar)
            .navigationDestination(for: ViewsRouter.self) { pathValue in
                switch pathValue {
                    case .cityView:
                        CityView(
                            schedule: $schedule,
                            navPath: $navPath,
                            direction: $direction,
                            viewModel: viewModel
                        )
                            .toolbar(.hidden, for: .tabBar)
                    case .stationView:
                        StationView(
                            schedule: $schedule,
                            navPath: $navPath,
                            direction: $direction,
                            viewModel: viewModel
                        )
                            .toolbar(.hidden, for: .tabBar)
                    case .routeView:
                        RoutesListView(schedule: $schedule)
                            .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
}

#Preview {
    RootTabView(schedule: .constant(Schedule.sampleData))
        .environmentObject(SettingsViewModel())
}
