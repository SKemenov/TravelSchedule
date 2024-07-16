//
//  RouteTimeDetailsView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 03.06.2024.
//

import SwiftUI

struct RouteTimeDetailsView: View {
    enum FieldPosition {
        case left, center, right
    }
    let route: Route
    let currentField: FieldPosition


    private var title: String
    private var font: Font
    private var edge: Edge.Set

    init(field currentField: FieldPosition, route: Route) {
        self.route = route
        self.currentField = currentField
        switch currentField {
            case .left:
                self.font = AppFonts.Regular.medium
                self.edge = .trailing
                self.title = route.departureTime
            case .center:
                self.font = AppFonts.Regular.small
                self.edge = .horizontal
                self.title = route.durationTime
            case .right:
                self.font = AppFonts.Regular.medium
                self.edge = .leading
                self.title = route.arrivalTime
        }
    }

    var body: some View {
        Text(title)
            .font(font)
            .padding(edge, AppSizes.Spacing.xSmall)
            .background(AppColors.Universal.lightGray)
    }
}

#Preview {
    HStack {
        RouteTimeDetailsView(field: .left, route: Route.sampleData[0])
        Spacer()
        RouteTimeDetailsView(field: .center, route: Route.sampleData[0])
        Spacer()
        RouteTimeDetailsView(field: .right, route: Route.sampleData[0])
    }
    .background(AppColors.Universal.lightGray)
    .padding()
}
