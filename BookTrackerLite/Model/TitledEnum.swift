//
//  TitledEnum.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 26.11.2024.
//

import Foundation

protocol TitledEnum: CaseIterable {
    var title: String { get }
    static var sortedTitles: [String] { get }
}

extension TitledEnum {
    static var sortedTitles: [String] {
        allCases.map(\.title).sorted()
    }
}
