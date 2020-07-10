//
//  URLSessionMock.swift
//  gitRepoStarsTests
//
//  Created by Marcelo de Aguiar on 10/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation
@testable import gitRepoStars

struct URLSessionMock: URLSessionProtocol {
    let next: (Data?, URLResponse?, Error?)
    func fetch(request: URLRequest, completion: @escaping FetchCallback) -> URLSessionDataTaskProtocol {
        let (data, response, error) = next
        completion(data, response, error)
        return URLSessionDataTaskMock()
    }
}

struct URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    func resume() {
    }
    func cancel() {
    }
}

