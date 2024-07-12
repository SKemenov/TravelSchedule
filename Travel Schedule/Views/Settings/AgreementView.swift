//
//  AgreementView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 22.04.2024.
//

import SwiftUI


struct AgreementView: View {
    private let title = "Пользовательское соглашение"
    private let urlString = "https://developer.apple.com/documentation/technologies"
    // private let urlString = "https://yandex.ru/legal/practicum_offer" // this url doesn't support dark mode

    @State private var isPresentWebView = false

    var body: some View {
        if let url = URL(string: urlString) {
            WebView(url: url)
                .ignoresSafeArea(.all, edges: .bottom)
                .setCustomNavigationBar(title: title)
        }
    }
}

#Preview {
    NavigationStack {
        AgreementView()
    }
}
