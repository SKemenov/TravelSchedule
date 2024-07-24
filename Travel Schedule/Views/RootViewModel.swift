//
//  RootViewModel.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 24.07.2024.
//

import SwiftUI

@MainActor
final class RootViewModel: ObservableObject {
    enum State: Equatable {
        case loading, loaded, error
    }

    @Published private (set) var state: State = .loading
    @Published private (set) var currentError: ErrorType = .serverError
    @Published var navPath: [ViewsRouter] = []
    @Published private (set) var store: [Components.Schemas.Settlements] = []

    private let networkService: NetworkService
    private (set) var stationsDownloader: StationsDownloader
    private (set) var routesDownloader: RoutesDownloader
    private (set) var imageDownloader: ImageDownloader

    init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
        self.stationsDownloader = StationsDownloader(networkService: networkService)
        self.routesDownloader = RoutesDownloader(networkService: networkService)
        self.imageDownloader = ImageDownloader()
    }

    func fetchData() throws {
        Task {
            state = .loading
            do {
                store = try await stationsDownloader.fetchData()
                state = .loaded
            } catch {
                currentError = error.localizedDescription.contains("error 0.") ? .serverError : .connectionError
                state = .error
                throw currentError == .serverError ? ErrorType.serverError : ErrorType.connectionError
            }
        }
    }
}
