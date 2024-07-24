//
//  SettingsView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(spacing: .zero) {
            switchView
            agreementView
            Spacer()
            footerView
        }
        .padding(.vertical, AppSizes.Spacing.xxLarge)
        .foregroundStyle(AppColors.LightDark.black)
    }
}

private extension SettingsView {
    enum Titles {
        static let darkMode = "Тёмная тема"
        static let agreement = "Пользовательское соглашение"
        static let version = "Версия \(Bundle.main.appVersionLong).\(Bundle.main.appBuild)"
    }

    var switchView: some View {
        Toggle(Titles.darkMode, isOn: $viewModel.darkMode)
            .setRowElement()
            .tint(AppColors.Universal.blue)
    }

    var agreementView: some View {
        NavigationLink {
            AgreementView()
        } label: {
            RowView(title: Titles.agreement)
        }
        .setRowElement()
    }

    var footerView: some View {
        VStack(alignment: .center, spacing: AppSizes.Spacing.large) {
            Text(viewModel.copyrightInfo)
            Text(Titles.version)
        }
        .font(AppFonts.Regular.small)
        .frame(minHeight: AppSizes.Height.about)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(SettingsViewModel(networkService: NetworkService()))
    }
}
