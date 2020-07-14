//
//  RepositoriesViewModelSpec.swift
//  gitRepoStarsTests
//
//  Created by Marcelo de Aguiar on 14/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import gitRepoStars

class RepositoriesViewModelSpec: QuickSpec {
    override func spec() {
        describe("RepositoriesViewModel") {
            context("when refreshing repositories list") {
                it("should call loadRepositores") {
                    let expectedList = RepositoryList(items: [
                        .init(
                            name: "Repo1",
                            starts: 100,
                            owner: .init(login: "lalo", avatarURL: "http://avatar.com")
                        )
                    ])
                    let delegate = RepositoriesViewModelDelegateSpy()
                    let service = RepositoriesServiceMock()
                    service.onFetchSwiftReposSortedByStart = { .success(expectedList) }
                    let viewModel = RepositoriesViewModel(reposService: service)
                    viewModel.delegate = delegate

                    viewModel.loadRepositories()

                    expect(delegate.startRefreshCount).to(equal(1))
                    expect(delegate.endedRefreshCount).to(equal(1))
                    expect(delegate.loadedRepositories.count).to(equal(1))
                    expect(delegate.loadedRepositories[0]).to(equal(expectedList.items))
                }
            }

            context("when loading repositories page") {
                it("should call loadRepositoresPage") {
                    let expectedList = RepositoryList(items: [
                        .init(
                            name: "Repo1",
                            starts: 100,
                            owner: .init(login: "lalo", avatarURL: "http://avatar.com")
                        )
                    ])
                    let delegate = RepositoriesViewModelDelegateSpy()
                    let service = RepositoriesServiceMock()
                    service.onFetchSwiftReposSortedByStart = { .success(expectedList) }
                    let viewModel = RepositoriesViewModel(reposService: service)
                    viewModel.delegate = delegate

                    viewModel.loadRepositoriesNextPage()

                    expect(delegate.startLoadingPageCount).to(equal(1))
                    expect(delegate.endedLoadingPageCount).to(equal(1))
                    expect(delegate.loadedRepositoriesPage.count).to(equal(1))
                    expect(delegate.loadedRepositoriesPage[0]).to(equal(expectedList.items))
                }
            }

            context("when failed loading repositories page") {
                it("should call failed") {
                    let expectedErrorMessage = "Forced failure"
                    let delegate = RepositoriesViewModelDelegateSpy()
                    let service = RepositoriesServiceMock()
                    service.onFetchSwiftReposSortedByStart = { .failure(.unknow(expectedErrorMessage)) }
                    let viewModel = RepositoriesViewModel(reposService: service)
                    viewModel.delegate = delegate

                    viewModel.loadRepositories()

                    expect(delegate.startRefreshCount).to(equal(1))
                    expect(delegate.endedRefreshCount).to(equal(1))
                    expect(delegate.failed.count).to(equal(1))
                }
            }
        }
    }
}


