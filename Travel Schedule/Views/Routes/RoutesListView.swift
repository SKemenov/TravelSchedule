//
//  RoutesListView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 23.04.2024.
//

import SwiftUI

struct RoutesListView: View {
    private let notification = "Вариантов нет"
    private let buttonTitle = "Уточнить время"

    @State var currentFilter = Filter()
    @State private var isError: Bool = false
    @ObservedObject var viewModel: TravelViewModel

    private var filteredRoutes: [Route] {
        let complexRoutes = currentFilter.isWithTransfers
            ? viewModel.routes
            : viewModel.routes.filter { $0.isDirect == true }
        var allRoutes = currentFilter.isAtNight
            ? complexRoutes.filter { $0.departureTime.starts(with: /0[0-5]/) }
            : []
        allRoutes += currentFilter.isMorning
        ? complexRoutes.filter { $0.departureTime.starts(with: /0[6-9]/) || $0.departureTime.starts(with: /1[0-1]/) }
        : []
        allRoutes += currentFilter.isAfternoon
            ? complexRoutes.filter { $0.departureTime.starts(with: /1[2-8]/) }
            : []
        allRoutes += currentFilter.isEvening
            ? complexRoutes.filter { $0.departureTime.starts(with: /19/) || $0.departureTime.starts(with: /2[0-4]/) }
            : []
        return allRoutes.sorted { $0.date < $1.date }
    }

    var body: some View {
        VStack(spacing: .zero) {
            (Text(viewModel.departure) + Text(AppImages.Icons.arrow).baselineOffset(-1) + Text(viewModel.arrival))
                .font(AppFonts.Bold.medium)

            if viewModel.state == .loading {
                Spacer()
                    .overlay {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .ypBlackDuo))
                    }
            } else if viewModel.state == .none {
                SearchResultEmptyView(notification: notification)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(filteredRoutes) { route in
                        if let carrier = viewModel.carriers.first(where: { $0.code == route.carrierCode }) {
                            NavigationLink {
                                CarrierView(carrier: carrier)
                            } label: {
                                RouteView(route: route, carrier: carrier)
                            }
                        }
                    }
                }
                .padding(.top, AppSizes.Spacing.large)
                Spacer()

                NavigationLink {
                    FilterView(filter: $currentFilter)
                } label: {
                    HStack(alignment: .center, spacing: AppSizes.Spacing.xSmall) {
                        ButtonTitleView(title: buttonTitle)
                        MarkerView(currentFilter: currentFilter)
                    }
                    .setCustomButton(padding: .top)
                }
            }
        }
        .padding(.horizontal, AppSizes.Spacing.large)
        .setCustomNavigationBar()
        .task {
            do {
                if viewModel.routes.isEmpty {
                    try await viewModel.searchRoutes()
                }
            } catch {
                isError = true
            }
        }
        .sheet(isPresented: $isError, onDismiss: {
            isError = false
        }, content: {
            ErrorView(errorType: viewModel.currentError)
        })
    }
}

#Preview {
    NavigationStack {
        RoutesListView(
            viewModel: TravelViewModel(networkService: NetworkService())
        )
    }
}
