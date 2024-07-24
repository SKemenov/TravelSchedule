//
//  StoriesListView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 23.04.2024.
//

import SwiftUI

struct PreviewStoriesView: View {
    // MARK: - Properties
    private let rows = [GridItem(.flexible())]
    @State var stories: [Story] = Story.mockData
    @State var isStoriesShowing = false
    @State var storyIndex = 0

    // MARK: - Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            previews
        }
        .frame(height: AppSizes.Height.stories)
    }
}

// MARK: - Private views
private extension PreviewStoriesView {
    var previews: some View {
        LazyHGrid(rows: rows, alignment: .center, spacing: AppSizes.Spacing.medium) {
            ForEach(Array(stories.enumerated()), id: \.offset) { index, story in
                StoryPreviewView(storyPreview: story)
                    .onTapGesture {
                        isStoriesShowing = true
                        storyIndex = index
                    }
                    .fullScreenCover(isPresented: $isStoriesShowing, onDismiss: didDismiss) {
                        StoriesView(stories: $stories, storyIndex: $storyIndex)
                    }
            }
        }
        .padding(.horizontal, AppSizes.Spacing.large)
        .padding(.vertical, AppSizes.Spacing.xxLarge)
    }
}

// MARK: - Private methods
private extension PreviewStoriesView {
    func didDismiss() {
        isStoriesShowing = false
    }
}

#Preview {
    PreviewStoriesView(stories: Story.mockData)
}
