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
    @Published var copyrightInfo = String()

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
