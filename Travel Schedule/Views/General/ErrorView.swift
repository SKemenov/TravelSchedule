//
//  ErrorView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 23.04.2024.
//

import SwiftUI

struct ErrorView: View {
    let errorType: ErrorType

    var body: some View {
        Image(errorType.imageName)
        Text(errorType.description)
            .font(AppFonts.Bold.medium)
    }
}

#Preview {
    ErrorView(errorType: ErrorType.connectionError)
}
