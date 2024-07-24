//
//  RouteView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct RouteView: View {
    let route: Route
    let carrier: Carrier
    var imageDownloader: ImageDownloader
    @State private (set) var carrierIcon = Image(systemName: "nosign.app")

    // MARK: - Body
    var body: some View {
        VStack(spacing: .zero) {
            RouteCarrierView(route: route, carrier: carrier, carrierIcon: $carrierIcon)
            timelineView
        }
        .background(AppColors.Universal.lightGray)
        .frame(maxWidth: .infinity, maxHeight: AppSizes.Height.route)
        .clipShape(RoundedRectangle(cornerRadius: AppSizes.CornerRadius.xxLarge))
        .task {
            let placeholderLogo = Image(systemName: carrier.placeholder)
            self.carrierIcon = carrier.logoSVGUrl.isEmpty
            ? await imageDownloader.fetchImage(from: carrier.logoUrl) ?? placeholderLogo
            : await imageDownloader.fetchSvgImage(from: carrier.logoSVGUrl) ?? placeholderLogo
        }
    }
}

// MARK: - Private views
private extension RouteView {
    var timelineView: some View {
        HStack(spacing: .zero) {
            timeDetailsView(field: .left, title: route.departureTime)
            Spacer()
            timeDetailsView(field: .center, title: route.durationTime)
            Spacer()
            timeDetailsView(field: .right, title: route.arrivalTime)
        }
        .background(
            lineView
        )
        .foregroundStyle(AppColors.Universal.black)
        .padding(.vertical, AppSizes.Spacing.medium)
        .padding(.horizontal, AppSizes.Spacing.small)
        .frame(maxWidth: .infinity, maxHeight: AppSizes.Height.timeLine)
    }

    var lineView: some View {
        Rectangle()
            .frame(height: AppSizes.Line.small)
            .foregroundStyle(AppColors.Universal.gray)
    }
}

// MARK: - Private methods
private extension RouteView {
    func timeDetailsView(field: FieldPosition, title: String) -> some View {
        Text(title)
            .font(field == .center ? AppFonts.Regular.small : AppFonts.Regular.medium)
            .padding(.horizontal, AppSizes.Spacing.xSmall)
            .background(AppColors.Universal.lightGray)
    }

    enum FieldPosition {
        case left, center, right
    }
}

#Preview {
    RouteView(route: Route.sampleData[0], carrier: Carrier.sampleData[1], imageDownloader: ImageDownloader())
}
