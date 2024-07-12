//
//  Travel_ScheduleApp.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 10.03.2024.
//

import SwiftUI

@main
struct Travel_ScheduleApp: App {
    @State private var schedule = Schedule.sampleData
    @StateObject var settings = SettingsViewModel(networkService: NetworkService())

    var body: some Scene {
        WindowGroup {
            RootTabView(schedule: $schedule)
                .environmentObject(settings)
                .environment(\.colorScheme, settings.darkMode ? .dark : .light)
        }
    }
}
