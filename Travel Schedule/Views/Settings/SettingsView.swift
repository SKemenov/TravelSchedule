//
//  SettingsView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 19.04.2024.
//

import SwiftUI

struct SettingsView: View {
    private enum Titles {
        static let darkMode = "Тёмная тема"
        static let agreement = "Пользовательское соглашение"
        static let description = "Приложение использует API «Яндекс.Расписания»"
        static let version = "Версия \(Bundle.main.appVersionLong).\(Bundle.main.appBuild)"
    }
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        VStack(spacing: .zero) {
            Toggle(Titles.darkMode, isOn: $settings.darkMode)
                .setRowElement()
                .tint(AppColors.Universal.blue)
            NavigationLink {
                AgreementView()
            } label: {
                RowSearchView(rowString: Titles.agreement)
            }
            .setRowElement()

            Spacer()

            VStack(alignment: .center, spacing: AppSizes.Spacing.large) {
                Text(Titles.description)
                Text(Titles.version)
            }
            .font(AppFonts.Regular.small)
            .frame(minHeight: AppSizes.Height.about)
        }
        .padding(.vertical, AppSizes.Spacing.xxLarge)
        .foregroundStyle(AppColors.LightDark.black)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(SettingsViewModel())
    }
}
