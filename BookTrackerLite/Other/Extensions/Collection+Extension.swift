//
//  Collection+Extension.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 14.11.2024.
//

import Foundation

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
