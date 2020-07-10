//
//  URLSession+Extensions.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    typealias FetchCallback = (Data?, URLResponse?, Error?) -> Void
    func fetch(request: URLRequest, completion: @escaping FetchCallback) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func cancel()
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {
    func fetch(request: URLRequest, completion: @escaping FetchCallback) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completion)
    }
}
