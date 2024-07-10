//
//  DestinationsListView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 03.06.2024.
//

import SwiftUI

struct DestinationsListView: View {
    let destinations: [Destination]
    private let dummyDirection = ["Откуда", "Куда"]
    @Binding var directionId: Int
    @ObservedObject var viewModel: TravelViewModel

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: .zero) {
                ForEach(Array(destinations.enumerated()), id: \.offset) { index, destination in
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
                        directionId = index
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
        DestinationsListView(
            destinations: Destination.emptyDestination,
            directionId: .constant(0),
            viewModel: TravelViewModel(networkService: NetworkService())
        )
        DestinationsListView(
            destinations: Destination.sampleData,
            directionId: .constant(0),
            viewModel: TravelViewModel(networkService: NetworkService())
        )
    }
    .padding()
    .background(AppColors.Universal.blue)
}
