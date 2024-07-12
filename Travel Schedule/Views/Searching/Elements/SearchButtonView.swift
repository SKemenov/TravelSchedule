//
//  SearchButtonView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 03.06.2024.
//

import SwiftUI

struct SearchButtonView: View {
    private let searchButtonTitle = "Найти"
    let route: ViewsRouter

    var body: some View {
        NavigationLink(value: route) {
            ButtonTitleView(title: searchButtonTitle)
                .setCustomButton(width: AppSizes.Width.searchButton, padding: .all)
        }
    }

    init(showView route: ViewsRouter) {
        self.route = route
    }
}

#Preview {
    SearchButtonView(
        showView: ViewsRouter.cityView
    )
        .background(AppColors.Universal.red.opacity(0.5))
}
