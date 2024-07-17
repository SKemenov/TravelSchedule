//
//  SearchBarView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 24.04.2024.
//

import SwiftUI

struct SearchBarView: View {
    // MARK: - Constants
    private let cornerRadius = AppSizes.CornerRadius.Custom.searchBar
    private let padding = AppSizes.Spacing.large
    private let height = AppSizes.Height.searchBar
    private let iconSize = AppSizes.Size.icon
    private let iconPadding = AppSizes.Spacing.small
    private let placeholder = "Введите запрос"

    // MARK: - Properties
    @Binding var searchText: String

    @Environment(\.colorScheme) var colorScheme

// MARK: - View
    var body: some View {
        HStack(spacing: .zero) {
            show(icon: AppImages.Icons.search)
                .foregroundStyle(searchText.isEmpty ? AppColors.Universal.gray : AppColors.LightDark.black)

            showTextField()

            if !searchText.isEmpty {
                Button {
                    cancelSearching()
                } label: {
                    show(icon: AppImages.Icons.cancel)
                        .foregroundStyle(AppColors.Universal.gray)
                }
            }
        }
        .frame(height: height)
        .background(colorScheme == .light ? AppColors.Universal.lightGray : AppColors.Universal.darkGray)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .padding(.horizontal, padding)
    }
}

// MARK: - Private methods
private extension SearchBarView {
    func show(icon: Image) -> some View {
        icon
            .resizable()
            .frame(width: iconSize, height: iconSize)
            .padding(.horizontal, iconPadding)
    }

    func showTextField() -> some View {
        TextField(placeholder, text: $searchText)
            .font(AppFonts.Regular.medium)
            .foregroundStyle(AppColors.LightDark.black)
            .autocorrectionDisabled(true)
            .autocapitalization(.none)
    }

    @MainActor
    func cancelSearching() {
        searchText = String()
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    VStack {
        VStack {
            SearchBarView(searchText: .constant(""))
            SearchBarView(searchText: .constant("some text"))
        }
        .environment(\.colorScheme, .light)
        .padding(.vertical, 44)

        VStack {
            SearchBarView(searchText: .constant(""))
            SearchBarView(searchText: .constant("some text"))
        }
        .environment(\.colorScheme, .dark)
    }
}
