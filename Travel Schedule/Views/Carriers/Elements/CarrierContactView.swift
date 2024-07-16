//
//  CarrierContactView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 03.06.2024.
//

import SwiftUI

struct CarrierContactView: View {
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

    let carrier: Carrier
    let type: ContactType

    @Environment(\.openURL) private var openURL

    private var emailUrl: String { "mailto:" + carrier.email }
    private var phoneUrl: String { "tel:" + carrier.phone }

    var body: some View {
        if type == .contacts {
            VStack(alignment: .leading, spacing: .zero) {
                Text(type.title)
                    .font(AppFonts.Regular.medium)
                    .foregroundStyle(AppColors.LightDark.black)
                Text(carrier.contacts)
                    .font(AppFonts.Regular.small)
                    .foregroundStyle(AppColors.LightDark.black)
                Spacer()
            }
            .frame(height: AppSizes.Height.row * 2)
        } else {
            VStack(alignment: .leading, spacing: .zero) {
                Text(type.title)
                    .font(AppFonts.Regular.medium)
                    .foregroundStyle(AppColors.LightDark.black)
                Button {
                    guard let url = URL(string: type == .email ? emailUrl : phoneUrl) else { return }
                    openURL(url)
                } label: {
                    Text(type == .email ? carrier.email : carrier.phone)
                        .font(AppFonts.Regular.small)
                        .foregroundStyle(AppColors.Universal.blue)
                }
            }
            .frame(height: AppSizes.Height.row)
        }
    }
}

#Preview {
    VStack {
        CarrierContactView(carrier: Carrier.sampleData[0], type: .email)
        CarrierContactView(carrier: Carrier.sampleData[0], type: .phone)
        CarrierContactView(carrier: Carrier.sampleData[0], type: .contacts)
    }
}
