//
//  Array+Extensions.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 17.07.2024.
//

import Foundation

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let mainArrayAsSet = Set(self)
        let otherArrayAsSet = Set(other)
        return Array(mainArrayAsSet.symmetricDifference(otherArrayAsSet))
    }
}
