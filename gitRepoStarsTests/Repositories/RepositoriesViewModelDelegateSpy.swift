//
//  RepositoriesDelegateSpy.swift
//  gitRepoStarsTests
//
//  Created by Marcelo de Aguiar on 14/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation
@testable import gitRepoStars

class RepositoriesViewModelDelegateSpy: RepositoriesViewModelDelegate {
    var startRefreshCount: Int = 0
    var endedRefreshCount: Int = 0
    var startLoadingPageCount: Int = 0
    var endedLoadingPageCount: Int = 0
    var loadedRepositories: [[Repository]] = []
    var loadedRepositoriesPage: [[Repository]] = []
    var failed: [String] = []

    func startRefresh() {
        startRefreshCount += 1
    }

    func endedRefresh() {
        endedRefreshCount += 1
    }

    func startLoadingPage() {
        startLoadingPageCount += 1
    }

    func endedLoadingPage() {
        endedLoadingPageCount += 1
    }

    func loadedRespositories(_ repos: [Repository]) {
        loadedRepositories.append(repos)
    }

    func loadedRepositoriesPage(_ repos: [Repository]) {
        loadedRepositoriesPage.append(repos)
    }

    func failed(with message: String) {
        failed.append(message)
    }
}
