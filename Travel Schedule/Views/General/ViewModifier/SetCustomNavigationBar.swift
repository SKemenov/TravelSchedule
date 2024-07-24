//
//  SetCustomNavigationBar.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 25.04.2024.
//

import SwiftUI

struct SetCustomNavigationBar: ViewModifier {
    @State var title: String

    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .setCustomNavBackButton()
    }
}
