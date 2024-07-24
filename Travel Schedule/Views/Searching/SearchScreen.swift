//
//  SearchScreen.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 25.04.2024.
//

import SwiftUI

struct SearchScreen: View {
    @Binding var navPath: [ViewsRouter]
    @ObservedObject var rootViewModel: RootViewModel
    @ObservedObject var viewModel: SearchScreenViewModel

    var body: some View {
        VStack(spacing: .zero) {
            PreviewStoriesView()
            MainSearchView(
                navPath: $navPath,
                rootViewModel: rootViewModel,
                viewModel: viewModel
            )
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        SearchScreen(
            navPath: .constant([]),
            rootViewModel: RootViewModel(networkService: NetworkService()),
            viewModel: SearchScreenViewModel()
        )
    }
}
