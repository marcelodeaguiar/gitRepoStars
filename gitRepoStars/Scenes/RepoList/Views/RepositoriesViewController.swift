//
//  ViewController.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController, BindableType {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = self.refreshControl
        tableView.tableFooterView = self.nextPageIndicator
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: String(describing: RepositoryCell.self))
        return tableView
    }()
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.6)
        return indicator
    }()
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refresh
    }()
    private lazy var nextPageIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        indicator.hidesWhenStopped = true
        indicator.frame = .init(x: 0, y: 0, width: 44, height: 44)
        return indicator
    }()

    typealias ViewModelType = RespositoriesViewModelType
    private var repositories: [Repository] = []
    private (set) var viewModel: RespositoriesViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Repositories"
        view.addSubview(tableView)
        view.addSubview(loadingIndicatorView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            loadingIndicatorView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingIndicatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func bind(to viewModel: RespositoriesViewModelType) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
        self.viewModel.loadRepositories()
    }

    @objc
    private func didPullToRefresh() {
        viewModel.loadRepositories()
    }
}

// MARK: - RepositoriesViewModelDelegate
extension RepositoriesViewController: RepositoriesViewModelDelegate {
    func startRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicatorView.startAnimating()
        }
    }

    func endedRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.loadingIndicatorView.stopAnimating()
        }
    }

    func startLoadingPage() {
        DispatchQueue.main.async { [weak self] in
            self?.nextPageIndicator.isHidden = false
            self?.nextPageIndicator.startAnimating()
        }
    }

    func endedLoadingPage() {
        DispatchQueue.main.async { [weak self] in
            self?.nextPageIndicator.stopAnimating()
        }
    }

    func loadedRespositories(_ repos: [Repository]) {
        self.repositories = repos
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func loadedRepositoriesPage(_ repos: [Repository]) {
        let rowIndexes = repos
            .enumerated()
            .map { $0.offset + repositories.count }
            .map { IndexPath(row: $0, section: 0)}

        repositories = repositories + repos
        DispatchQueue.main.async { [weak self] in
            self?.tableView.performBatchUpdates({
                self?.tableView.insertRows(at: rowIndexes, with: .none)
            }, completion: nil)
        }
    }

    func failed(with message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ops", message: "Something went wrong: \(message)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = String(describing: RepositoryCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? RepositoryCell else {
            fatalError("Can't dequeue cell with id \(cellId)")
        }

        let repository = repositories[indexPath.row]
        cell.setup(with: repository)
        return cell
    }
}

extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > repositories.count - 10 {
            viewModel.loadRepositoriesNextPage()
        }
    }
}
