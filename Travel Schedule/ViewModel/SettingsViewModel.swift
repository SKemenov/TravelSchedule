//
//  SettingsViewModel.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 28.06.2024.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var darkMode = false
}
