//
//  RowView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 22.04.2024.
//

import SwiftUI

struct RowView: View {
    @State var title: String

    var body: some View {
        HStack(spacing: .zero) {
            Text(title)
                .font(AppFonts.Regular.medium)
            Spacer()
            AppImages.Icons.forward
                .imageScale(.large)
        }
    }
}

#Preview {
    RowView(title: "Moscow")
}
