//
//  SearchTabView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 25.04.2024.
//

import SwiftUI

struct SearchTabView: View {
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
        SearchTabView(
            navPath: .constant([]),
            rootViewModel: RootViewModel(networkService: NetworkService()),
            viewModel: SearchScreenViewModel()
        )
    }
}
