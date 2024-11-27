//
//  BookListCoordinator.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 25.11.2024.
//

import Foundation
import UIKit

class BookListCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let bookListVC = BookListViewController()
        bookListVC.viewModel = BookListViewModel(delegate: bookListVC)
        bookListVC.coordinator = self
        navigationController.pushViewController(bookListVC, animated: true)
    }
    
    func showFilterModal(filter: FilterBookList?, delegate: FilterBookListDelegate?) {
        let filterVM = FilterBookListViewModel(filter: filter, delegate: delegate)
        let filterVC = FilterBookListViewController()
        filterVC.coordinator = self
        filterVC.viewModel = filterVM
        filterVC.modalPresentationStyle = .formSheet
        navigationController.present(filterVC, animated: true, completion: nil)
    }
    
    func closeFilterModal() {
        navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
