//
//  MainSearchView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct MainSearchView: View {
    @Binding var schedule: Schedule
    @Binding var navPath: [ViewsRouter]
    @Binding var directionId: Int
    @ObservedObject var viewModel: TravelViewModel

    var body: some View {
        HStack(alignment: .center, spacing: AppSizes.Spacing.large) {
            DestinationsListView(
                destinations: schedule.destinations,
                directionId: $directionId,
                viewModel: viewModel
            )

            SwapButtonView(destinations: $schedule.destinations)
        }
        .padding(AppSizes.Spacing.large)
        .background(AppColors.Universal.blue)
        .clipShape(RoundedRectangle(cornerRadius: AppSizes.CornerRadius.xLarge))
        .frame(height: AppSizes.Height.searchingForm)
        .padding(.top, AppSizes.Spacing.xLarge)
        .padding(.horizontal, AppSizes.Spacing.large)

        SearchButtonView(for: schedule.destinations, showView: ViewsRouter.routeView)

        Spacer()
    }
}

#Preview {
    NavigationStack {
        MainSearchView(
            schedule: .constant(Schedule.sampleData),
            navPath: .constant([]),
            directionId: .constant(0),
            viewModel: TravelViewModel(networkService: NetworkService())
        )
    }
}
