//
//  GitRepoListService.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation

protocol RepositoriesServiceType {
    func fetchSwiftReposSortedByStar(page: Int, _ completion: @escaping (Result<RepositoryList, ApiError>) -> Void)
}

struct RepositoriesService: RepositoriesServiceType {
    private let apiBasePath = "https://api.github.com/search/repositories"
    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchSwiftReposSortedByStar(page: Int = 1, _ completion: @escaping (Result<RepositoryList, ApiError>) -> Void) {
        guard let url = URL(string: "\(apiBasePath)?q=language:swift&sort=stars&page=\(page)") else {
            completion(.failure(.invalidPath))
            return
        }

        let client = HttpClient(session: session)
        let request = URLRequest(url: url)
        client.get(request: request, completion: completion)
    }
}
