//
//  SetRowElement.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 24.04.2024.
//

import SwiftUI

struct SetRowElement: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppFonts.Regular.medium)
            .padding(.horizontal, AppSizes.Spacing.large)
            .frame(maxWidth: .infinity, maxHeight: AppSizes.Height.row)
    }
}
