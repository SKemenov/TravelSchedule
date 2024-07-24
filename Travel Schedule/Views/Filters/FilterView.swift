//
//  FilterView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 24.04.2024.
//

import SwiftUI

struct FilterView: View {
    // MARK: - Constants
    private let timeSectionTitle = "Время отправления"
    private let connectionSectionTitle = "Показывать варианты с пересадками"
    private let buttonTitle = "Применить"

    // MARK: - Properties
    @Binding var viewModelFilter: Filter
    @State var currentFilter = Filter()

    @Environment(\.presentationMode) var presentationMode

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            timeSectionView
            connectionSectionView
            Spacer()
            if currentFilter != viewModelFilter {
                buttonView
            }
        }
        .setCustomNavigationBar()
        .onAppear {
            loadFilter()
        }
    }
}

// MARK: - Private views
private extension FilterView {
    var timeSectionView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            show(title: timeSectionTitle)
            CheckboxView(type: .morning, isOn: $currentFilter.isMorning)
            CheckboxView(type: .afternoon, isOn: $currentFilter.isAfternoon)
            CheckboxView(type: .evening, isOn: $currentFilter.isEvening)
            CheckboxView(type: .night, isOn: $currentFilter.isAtNight)
        }
    }

    var connectionSectionView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            show(title: connectionSectionTitle)
            RadioButtonView(isOn: $currentFilter.isWithTransfers)
        }
    }

    var buttonView: some View {
        Button {
            saveFilter()
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text(buttonTitle)
                .setCustomButton(padding: .horizontal)
        }
    }
}

// MARK: - Private methods
private extension FilterView {
    func show(title: String) -> some View {
        Text(title)
            .font(AppFonts.Bold.medium)
            .padding(AppSizes.Spacing.large)
    }

    func loadFilter() {
        currentFilter = viewModelFilter
    }

    func saveFilter() {
        viewModelFilter = currentFilter
    }
}

#Preview {
    NavigationStack {
        FilterView(viewModelFilter: .constant(Filter.customSearch))
    }
}
