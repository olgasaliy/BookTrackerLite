//
//  Coordinator.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 25.11.2024.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
