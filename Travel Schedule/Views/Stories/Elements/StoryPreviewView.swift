//
//  StoryPreviewView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 06.06.2024.
//

import SwiftUI

struct StoryPreviewView: View {
    // MARK: - Properties
    private let titleLineLimit = 3
    var storyPreview: Story

    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            previewImage
            title
            border
        }
        .padding(.zero)
        .frame(width: AppSizes.Width.storyPreview, height: AppSizes.Height.storyPreview)
        .contentShape(RoundedRectangle(cornerRadius: AppSizes.CornerRadius.large))
    }
}

// MARK: - Private Views
private extension StoryPreviewView {
    var previewImage: some View {
        Image(storyPreview.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: AppSizes.Width.storyPreview, height: AppSizes.Height.storyPreview)
            .clipShape(RoundedRectangle(cornerRadius: AppSizes.CornerRadius.large))
            .opacity(storyPreview.isShowed ? .halfOpacity : .fullOpacity)
    }

    var title: some View {
        Text(storyPreview.title)
            .foregroundColor(AppColors.Universal.white)
            .font(AppFonts.Regular.small)
            .padding(.horizontal, AppSizes.Spacing.small)
            .padding(.bottom, AppSizes.Spacing.medium)
            .lineLimit(titleLineLimit)
    }

    var border: some View {
        RoundedRectangle(cornerRadius: AppSizes.CornerRadius.large)
            .strokeBorder(
                AppColors.Universal.blue,
                lineWidth: storyPreview.isShowed ? .zero : AppSizes.Line.large
            )
    }
}

#Preview {
    let newStory = Story.mockData[0]
    var showedStory = Story.mockData[0]
    showedStory.isShowed = true
    return HStack {
        StoryPreviewView(storyPreview: newStory)
        StoryPreviewView(storyPreview: showedStory)
    }
}
