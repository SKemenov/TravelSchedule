//
//  MainSearchView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct MainSearchView: View {
    @Binding var navPath: [ViewsRouter]
    @ObservedObject var viewModel: TravelViewModel

    var body: some View {
        HStack(alignment: .center, spacing: AppSizes.Spacing.large) {
            DestinationsListView(viewModel: viewModel)
            SwapButtonView(viewModel: viewModel)
        }
        .padding(AppSizes.Spacing.large)
        .background(AppColors.Universal.blue)
        .clipShape(RoundedRectangle(cornerRadius: AppSizes.CornerRadius.xLarge))
        .frame(height: AppSizes.Height.searchingForm)
        .padding(.top, AppSizes.Spacing.xLarge)
        .padding(.horizontal, AppSizes.Spacing.large)

        if viewModel.isSearchButtonReady { SearchButtonView(showView: ViewsRouter.routeView) }

        Spacer()
    }
}

#Preview {
    NavigationStack {
        MainSearchView(
            navPath: .constant([]),
            viewModel: TravelViewModel(networkService: NetworkService())
        )
    }
}
