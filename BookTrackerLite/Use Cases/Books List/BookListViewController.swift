//
//  ViewController.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 11.11.2024.
//

import UIKit

class BookListViewController: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.accessibilityIdentifier = "bookListTableView"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: String(describing: BookListTableViewCell.self),
                                 bundle: nil),
                           forCellReuseIdentifier: "bookListTableViewCell")
        return tableView
    }()
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search for books"
        return searchBar
    }()
    var viewModel: BookListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Book Tracker"
        setupSearchBar()
        setupTableView()
        viewModel?.getBestsellers()
    }

    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 100
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension BookListViewController: BookListViewModelDelegate {
    
    func didBooksUpdate() {
        tableView.reloadData()
    }
    
    func didErrorOccur(error: String) {
        showErrorAlert(message: error)
    }
    
}

extension BookListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getBooks(with: searchText)
    }
}

extension BookListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.booksCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookListTableViewCell", for: indexPath) as? BookListTableViewCell else {
            return UITableViewCell()
        }
        
        if let viewModel = viewModel,
           let model = viewModel.getBook(at: indexPath.row) {
            cell.viewModel = BookListTableViewCellViewModel(book: model,
                                                            bookService: viewModel.bookService)
        }
        
        return cell
    }
    
    
}
