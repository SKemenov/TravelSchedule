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

    var body: some View {
        VStack(spacing: .zero) {
            RouteCarrierView(route: route, carrier: carrier)

            RouteTimeView(route: route)
        }
        .background(AppColors.Universal.lightGray)
        .frame(maxWidth: .infinity, maxHeight: AppSizes.Height.route)
        .clipShape(RoundedRectangle(cornerRadius: AppSizes.CornerRadius.xxLarge))
    }
}

#Preview {
    RouteView(route: Route.sampleData[0], carrier: Carrier.sampleData[0])
}
