//
//  RouteCarrierView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 03.06.2024.
//

import SwiftUI

struct RouteCarrierView: View {
    let route: Route
    let carrier: Carrier

    private var connectionInValue: String { "С пересадкой в \(route.connectionStation)" }

    var body: some View {
        HStack(spacing: AppSizes.Spacing.small) {
            Image(carrier.logoName)
                .resizable()
                .scaledToFit()
                .frame(width: AppSizes.Size.logo, height: AppSizes.Size.logo)
                .padding(.leading, AppSizes.Spacing.medium)
            HStack(spacing: .zero) {
                VStack(alignment: .leading) {
                    Text(carrier.title)
                        .font(AppFonts.Regular.medium)
                        .foregroundStyle(AppColors.Universal.black)
                    if !route.isDirect {
                        Text(connectionInValue)
                            .font(AppFonts.Regular.small)
                            .foregroundStyle(AppColors.Universal.red)
                    }
                }
                Spacer()
                Text(route.date.getLocalizedShortDate)
                    .font(AppFonts.Regular.small)
                    .foregroundStyle(AppColors.Universal.black)
            }
        }
        .padding(.top, AppSizes.Spacing.medium)
        .padding(.trailing, AppSizes.Spacing.small)
    }
}

#Preview {
    RouteCarrierView(route: Route.sampleData[0], carrier: Carrier.sampleData[0])
        .background(AppColors.Universal.lightGray)
}
