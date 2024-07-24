//
//  SettingsViewModel.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 28.06.2024.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @AppStorage("DarkMode") var darkMode: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var copyrightInfo = String()

    enum Titles {
        static let darkMode = "Тёмная тема"
        static let agreement = "Пользовательское соглашение"
        static let version = "Версия \(Bundle.main.appVersionLong).\(Bundle.main.appBuild)"
    }

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
        self.getCopyright()
    }

    func getCopyright() {
        Task {
            let service = CopyrightService(client: networkService.client)
            do {
                let response = try await service.getCopyright()
                copyrightInfo = response.copyright?.text ?? ""
            } catch {
                throw ErrorType.connectionError
            }
        }
    }
}
