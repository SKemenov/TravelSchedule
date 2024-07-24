//
//  CarrierView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 24.04.2024.
//

import SwiftUI

struct CarrierView: View {
    // MARK: - Properties
    private let title = "Информация о перевозчике"
    @State var carrier: Carrier
    var imageDownloader: ImageDownloader
    @Environment(\.openURL) private var openURL

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            imageView
            titleView
            show(info: carrier.email, for: .email)
            show(info: carrier.phone, for: .phone)
            show(info: carrier.contacts, for: .contacts)
            Spacer()
        }
        .padding(.horizontal, AppSizes.Spacing.large)
        .setCustomNavigationBar(title: title)
    }
}

// MARK: - Private views
private extension CarrierView {
    enum ContactType {
        case email, phone, contacts

        var title: String {
            switch self {
                case .email: "E-mail"
                case .phone: "Телефон"
                case .contacts: "Контакты"
            }
        }
    }
    var carrierTitle: String { "ОАО «\(carrier.title)»" }
    var emailUrl: String { "mailto:" + carrier.email }
    var phoneUrl: String { "tel:" + carrier.phone }

    var imageView: some View {
        AsyncImage(url: URL(string: carrier.logoUrl)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            placeholderImageView
        }
        .frame(maxWidth: .infinity, maxHeight: AppSizes.Height.carrierFullLogo)
        .background(AppColors.Universal.white)
        .clipShape(RoundedRectangle(cornerRadius: AppSizes.CornerRadius.xxLarge))
    }

    var placeholderImageView: some View {
        Image(systemName: carrier.placeholder)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: AppSizes.Height.carrierFullLogo / 2)
            .padding(.vertical, AppSizes.Height.carrierFullLogo / 4)
    }

    var titleView: some View {
        Text(carrierTitle)
            .font(AppFonts.Bold.medium)
            .frame(maxWidth: .infinity, maxHeight: AppSizes.Height.carrierTitle, alignment: .leading)
            .padding(.vertical, AppSizes.Spacing.large)
    }
}

// MARK: - Private methods
private extension CarrierView {
    func show(info: String, for type: ContactType) -> some View {
        return VStack(alignment: .leading, spacing: .zero) {
            show(header: type.title)
            switch type {
                case .email: showButton(for: .email)
                case .phone: showButton(for: .phone)
                case .contacts: show(info: carrier.contacts)
            }
        }.frame(height: type == .contacts ? AppSizes.Height.row * 2 : AppSizes.Height.row)
    }

    func show(header: String) -> some View {
        Text(header)
            .font(AppFonts.Regular.medium)
            .foregroundStyle(AppColors.LightDark.black)
    }

    func show(info: String) -> some View {
        VStack(spacing: .zero) {
            Text(info)
                .font(AppFonts.Regular.small)
                .foregroundStyle(AppColors.LightDark.black)
            Spacer()
        }
    }

    func showButton(for type: ContactType) -> some View {
        Button {
            guard let url = URL(string: type == .email ? emailUrl : phoneUrl) else { return }
            openURL(url)
        } label: {
            show(info: type == .email ? carrier.email : carrier.phone)
        }
    }
}

#Preview {
    NavigationStack {
        CarrierView(carrier: Carrier.sampleData[0], imageDownloader: ImageDownloader())
    }
}
