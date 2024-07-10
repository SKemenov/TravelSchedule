//
//  SearchTabView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 25.04.2024.
//

import SwiftUI

struct SearchTabView: View {
    @Binding var stories: [Story]
    @Binding var schedule: Schedule
    @Binding var navPath: [ViewsRouter]
    @Binding var direction: Int
    @ObservedObject var viewModel: TravelViewModel

    var body: some View {
        VStack(spacing: .zero) {
            PreviewStoriesView(stories: $stories)
            MainSearchView(schedule: $schedule, navPath: $navPath, directionId: $direction, viewModel: viewModel)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        SearchTabView(
            stories: .constant(Story.mockData),
            schedule: .constant(Schedule.sampleData),
            navPath: .constant([]),
            direction: .constant(0),
            viewModel: TravelViewModel(networkService: NetworkService())
        )
    }
}
