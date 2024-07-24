//
//  SetCustomNavBackButton.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 25.04.2024.
//

import SwiftUI

struct SetCustomNavBackButton: ViewModifier {
    @Environment(\.dismiss) var dismiss

    @ViewBuilder
    @MainActor
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        AppImages.Icons.backward
                            .imageScale(.large)
                            .foregroundStyle(AppColors.LightDark.black)
                    }
                    .padding(.leading, -AppSizes.Spacing.xSmall)
                    .padding(.trailing, AppSizes.Spacing.xSmall)
                }
            }
            .contentShape(Rectangle()) // Start of the gesture to dismiss the navigation
            .gesture(
                DragGesture(coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width > .zero
                            && value.translation.height > -30
                            && value.translation.height < 30 {
                            dismiss()
                        }
                    }
            )
    }
}
