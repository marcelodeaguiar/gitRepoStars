//
//  RepositoriesServiceSpy.swift
//  gitRepoStarsTests
//
//  Created by Marcelo de Aguiar on 14/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation
@testable import gitRepoStars

class RepositoriesServiceMock: RepositoriesServiceType {
    var onFetchSwiftReposSortedByStart: (() -> Result<RepositoryList, ApiError>)?

    func fetchSwiftReposSortedByStar(page: Int, _ completion: @escaping (Result<RepositoryList, ApiError>) -> Void) {
        guard let handler = onFetchSwiftReposSortedByStart else {
            fatalError("Mock should be initialized with a handler")
        }
        completion(handler())
    }
}
