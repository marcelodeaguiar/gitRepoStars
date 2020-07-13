//
//  GitRepoListViewModel.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation

protocol RespositoriesViewModelType {
    var delegate: RepositoryViewModelDelegate? { get set }
    func loadRepositories()
    func loadRepositoriesNextPage()
}

protocol RepositoryViewModelDelegate: AnyObject {
    func startRefresh()
    func endedRefresh()
    func startLoadingPage()
    func endedLoadingPage()
    func loadedRespositories(_ repos: [Repository])
    func loadedRepositoriesPage(_ repos: [Repository])
    func failed(with message: String)
}

class RepositoriesViewModel: RespositoriesViewModelType {
    private let reposService: RepositoriesServiceType
    private var currentPage: Int = 0
    private var isLoadingPage: Bool = false

    weak var delegate: RepositoryViewModelDelegate?

    init(reposService: RepositoriesServiceType = RepositoriesService()) {
        self.reposService = reposService
    }

    func loadRepositories() {
        delegate?.startRefresh()
        reposService.fetchSwiftReposSortedByStar(page: 1) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let list):
                self.currentPage = 1
                self.delegate?.loadedRespositories(list.items)
            case .failure(let error):
                self.delegate?.failed(with: "Failed to load with error: \(error)")
            }
            self.delegate?.endedRefresh()
        }
    }

    func loadRepositoriesNextPage() {
        guard !isLoadingPage else { return }

        isLoadingPage = true
        delegate?.startLoadingPage()
        let nextPage = currentPage + 1
        reposService.fetchSwiftReposSortedByStar(page: nextPage) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let list):
                self.currentPage = nextPage
                self.delegate?.loadedRepositoriesPage(list.items)

            case .failure(let error):
                self.delegate?.failed(with: "Failed to load with error: \(error)")
            }
            self.isLoadingPage = false
            self.delegate?.endedLoadingPage()
        }
    }
}
