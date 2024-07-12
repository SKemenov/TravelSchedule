//
//  DestinationsListView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 03.06.2024.
//

import SwiftUI

struct DestinationsListView: View {
    private let dummyDirection = ["Откуда", "Куда"]
    @ObservedObject var viewModel: TravelViewModel

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: .zero) {
                ForEach(Array(viewModel.destinations.enumerated()), id: \.offset) { index, destination in
                    let city = destination.city.title
                    let station = destination.station.title.isEmpty
                        ? ""
                    : " (" + destination.station.title + ")"
                    let destinationLabel = city.isEmpty
                        ? dummyDirection[index]
                        : city + station
                    return NavigationLink(value: ViewsRouter.cityView) {
                        HStack {
                            Text(destinationLabel)
                                .foregroundStyle(
                                    viewModel.state == .loading
                                        ? .clear
                                        : city.isEmpty
                                            ? AppColors.Universal.gray
                                            : AppColors.Universal.black
                                )
                            Spacer()
                        }
                        .padding(AppSizes.Spacing.large)
                        .frame(maxWidth: .infinity, maxHeight: AppSizes.Height.searchingRow)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        viewModel.setDirection(to: index)
                    })
                }
            }
            .background(AppColors.Universal.white)
            .clipShape(RoundedRectangle(cornerRadius: AppSizes.CornerRadius.xLarge))
            if viewModel.state == .loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .ypBlackDuo))
            }
        }
    }
}

#Preview {
    VStack {
        DestinationsListView(viewModel: TravelViewModel(networkService: NetworkService()))
        DestinationsListView(viewModel: TravelViewModel(
            networkService: NetworkService(),
            destinations: Destination.sampleData
        ))
    }
    .padding()
    .background(AppColors.Universal.blue)
}
