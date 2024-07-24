//
//  RouteCarrierView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 03.06.2024.
//

import SwiftUI
import SVGKit

struct RouteCarrierView: View {
    // MARK: - Properties
    let route: Route
    let carrier: Carrier
    @Binding var carrierIcon: Image

    private var connectionInValue: String { "С пересадкой в \(route.connectionStation)" }

    // MARK: - Body
    var body: some View {
        HStack(spacing: AppSizes.Spacing.small) {
            iconView
            VStack(alignment: .leading) {
                carrierTitleView
                if !route.isDirect {
                    connectionInfoView
                }
            }
            Spacer()
            departureDateView
        }
        .padding(.top, AppSizes.Spacing.medium)
        .padding(.horizontal, AppSizes.Spacing.medium)
    }
}

// MARK: - Private Views
private extension RouteCarrierView {
    var iconView: some View {
        carrierIcon
            .frame(width: AppSizes.Size.logo, height: AppSizes.Size.logo)
    }

    var carrierTitleView: some View {
        Text(carrier.title)
            .font(AppFonts.Regular.medium)
            .foregroundStyle(AppColors.Universal.black)
    }

    var connectionInfoView: some View {
        Text(connectionInValue)
            .font(AppFonts.Regular.small)
            .foregroundStyle(AppColors.Universal.red)
    }

    var departureDateView: some View {
        Text(route.date.getLocalizedShortDate)
            .font(AppFonts.Regular.small)
            .foregroundStyle(AppColors.Universal.black)
    }

    var placeholderImageView: some View {
        Image(systemName: carrier.placeholder)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: AppSizes.Size.logo / 1.5, height: AppSizes.Size.logo / 1.5)
            .foregroundStyle(AppColors.LightDark.black)
    }
}

#Preview {
    RouteCarrierView(
        route: Route.sampleData[0],
        carrier: Carrier.sampleData[0],
        carrierIcon: .constant(Image(systemName: "cablecar"))
    )
        .background(AppColors.Universal.lightGray)
}
