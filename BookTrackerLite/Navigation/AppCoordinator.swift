//
//  AppCoordinator.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 25.11.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let bookListCoordinator = BookListCoordinator(navigationController: navigationController)
        bookListCoordinator.start()
    }
}
