//
//  SwapButtonView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 03.06.2024.
//

import SwiftUI

struct SwapButtonView: View {
    @ObservedObject var viewModel: TravelViewModel

    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(AppColors.Universal.white)
                .frame(width: AppSizes.Size.swappingButton)
            Button {
                viewModel.swapDestinations()
            } label: {
                AppImages.Icons.swap
                    .foregroundStyle(AppColors.Universal.blue)
            }
        }
    }
}

#Preview {
    SwapButtonView(viewModel: TravelViewModel(networkService: NetworkService()))
        .padding()
        .background(AppColors.Universal.red.opacity(0.5))
}
