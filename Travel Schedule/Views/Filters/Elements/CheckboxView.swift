//
//  CheckboxView.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 03.06.2024.
//

import SwiftUI

struct CheckboxView: View {
    // MARK: - Properties
    let type: CheckboxType
    @Binding var isOn: Bool

    // MARK: - View
    var body: some View {
        Toggle(type.title, isOn: $isOn)
            .setRowElement()
            .toggleStyle(.checkBox)
    }
}

// MARK: - Constants
extension CheckboxView {
    enum CheckboxType {
        case morning, afternoon, evening, night

        var title: String {
            switch self {
                case .morning: return String(localized: "Утро 06:00 - 11:59")
                case .afternoon: return String(localized: "День 12:00 - 18:59")
                case .evening: return String(localized: "Вечер 19:00 - 23:59")
                case .night: return String(localized: "Ночь 00:00 - 05:59")
            }
        }
    }
}

#Preview {
    VStack {
        CheckboxView(type: .morning, isOn: .constant(Filter.fullSearch.isMorning))
        CheckboxView(type: .night, isOn: .constant(Filter.customSearch.isMorning))
    }
}
