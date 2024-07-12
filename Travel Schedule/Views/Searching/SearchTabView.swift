//
//  SearchTabView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 25.04.2024.
//

import SwiftUI

struct SearchTabView: View {
    @Binding var stories: [Story]
    @Binding var navPath: [ViewsRouter]
    @ObservedObject var viewModel: TravelViewModel

    var body: some View {
        VStack(spacing: .zero) {
            PreviewStoriesView(stories: $stories)
            MainSearchView(
                navPath: $navPath,
                viewModel: viewModel
            )
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        SearchTabView(
            stories: .constant(Story.mockData),
            navPath: .constant([]),
            viewModel: TravelViewModel(networkService: NetworkService())
        )
    }
}
