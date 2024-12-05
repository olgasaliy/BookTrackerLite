//
//  FilterBookListViewController.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 25.11.2024.
//

import UIKit
import SwiftUI

class FilterBookListViewController: UIViewController {

    var viewModel: FilterBookListViewModel?
    var coordinator: BookListCoordinator?
    
    private var navigationBar = UINavigationBar()
    private var sortByContainer = UIView()
    private var categoriesContainer = UIView()
    private var availabilityContainer = UIView()
    private var languageContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let navigationItem = UINavigationItem(title: "Filters")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Apply",
            style: .done,
            target: self,
            action: #selector(applyTapped)
        )

        navigationBar.items = [navigationItem]
    }
    
    private func setupView() {
        view.backgroundColor = .white
        setupSortByView()
        
        NSLayoutConstraint.activate([
            sortByContainer.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            sortByContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortByContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    private func setupSortByView() {
        guard let viewModel else { return }
        sortByContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortByContainer)
        
        let sortByLabel: UILabel = {
            let label = UILabel()
            label.text = "Sort By"
            label.font = .systemFont(ofSize: 20, weight: .medium)
            label.textColor = .black
            return label
        }()

        let sortBySegmentedControl = CustomSegmentedControl(items: viewModel.getOrderByTitles(),
                                                            selectedSegmentIndex: Binding(get: { viewModel.selectedIndexOfOrderBy },
                                                                                          set: { viewModel.selectedIndexOfOrderBy = $0 }))
        let hostingController = UIHostingController(rootView: sortBySegmentedControl)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        let sortByStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [sortByLabel, hostingController.view])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        sortByContainer.addSubview(sortByStackView)
        NSLayoutConstraint.activate([
            sortByStackView.topAnchor.constraint(equalTo: sortByContainer.topAnchor),
            sortByStackView.leadingAnchor.constraint(equalTo: sortByContainer.leadingAnchor),
            sortByStackView.trailingAnchor.constraint(equalTo: sortByContainer.trailingAnchor),
            sortByStackView.bottomAnchor.constraint(equalTo: sortByContainer.bottomAnchor)
        ])
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        viewModel?.selectedIndexOfOrderBy = sender.selectedSegmentIndex
    }
    
    @objc func applyTapped() {
        viewModel?.applyFilter()
        coordinator?.closeFilterModal()
    }
    
    @objc func cancelTapped() {
        coordinator?.closeFilterModal()
    }

}
