//
//  StoryPageView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 04.06.2024.
//

import SwiftUI

struct StoryPageView: View {
    // MARK: - Properties
    var model: StoryPage

    // MARK: - Body
    var body: some View {
        AppColors.Universal.black
            .ignoresSafeArea()
            .overlay {
                ZStack {
                    fullImage
                    information
                }
                .padding(.bottom, AppSizes.Spacing.large)
            }
    }
}

// MARK: - Private views
private extension StoryPageView {
    var fullImage: some View {
        Image(model.imageName)
            .resizable()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: AppSizes.CornerRadius.Custom.story))
            .padding(.top, AppSizes.Spacing.xSmall)
            .padding(.horizontal, .zero)
    }

    var information: some View {
        VStack(alignment: .leading, spacing: AppSizes.Spacing.medium) {
            Spacer()
            title
            description
        }
        .foregroundStyle(AppColors.Universal.white)
        .padding(.horizontal, AppSizes.Spacing.medium)
        .padding(.bottom, AppSizes.Spacing.Custom.story)
    }

    var title: some View {
        Text(model.title)
            .font(AppFonts.Bold.large)
            .lineLimit(LineLimits.title)
    }

    var description: some View {
        Text(model.description)
            .font(AppFonts.Regular.large)
            .lineLimit(LineLimits.description)
    }
}

// MARK: - Constants
private extension StoryPageView {
    enum LineLimits {
        static let title = 2
        static let description = 3
    }
}

#Preview {
    StoryPageView(model: StoryPage.mockData1[0])
}
