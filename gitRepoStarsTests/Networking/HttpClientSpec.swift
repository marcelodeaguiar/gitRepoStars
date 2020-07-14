//
//  HttpClientSpec.swift
//  gitRepoStarsTests
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Quick
import Nimble
@testable import gitRepoStars

class HttpClientSpec: QuickSpec {
    override func spec() {
        describe("requesting") {
            context("responded different json data") {
                it("should return serialization error") {
                    waitUntil(action: { done in
                        let url = URL(string: "http://anyurl.com")!
                        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        let responseData = "{ \"login_name\": \"marcelodeaguiar\", \"avatarurl\": \"http://avatar.com\" }".data(using: .utf8)
                        let session = URLSessionMock(next: (responseData, response, nil))
                        let client = HttpClient(session: session)
                        client.get(
                            request: URLRequest(url: URL(string: "http://anyurl.com")!),
                            completion: { (result: Result<RepositoryOwner, ApiError>) in
                                if case let .failure(error) = result, case .serialization = error {
                                    _ = succeed()
                                } else {
                                    fail("got wrong error")
                                }
                                done()
                            }
                        )
                    })
                }
            }

            context("responded 200") {
                it("should return serialized model") {
                    waitUntil(action: { done in
                        let url = URL(string: "http://anyurl.com")!
                        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        let responseData = "{ \"login\": \"marcelodeaguiar\", \"avatar_url\": \"http://avatar.com\" }".data(using: .utf8)
                        let session = URLSessionMock(next: (responseData, response, nil))
                        let client = HttpClient(session: session)
                        client.get(
                            request: URLRequest(url: URL(string: "http://anyurl.com")!),
                            completion: { (result: Result<RepositoryOwner, ApiError>) in
                                switch result {
                                case .success:
                                    _ = succeed()
                                case .failure(let error):
                                    fail("got error \(error)")
                                }
                                done()
                            }
                        )
                    })
                }
            }

            context("when response has no data") {
                it("should return serialization error") {
                    waitUntil(action: { done in
                        let url = URL(string: "http://anyurl.com")!
                        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
                        let session = URLSessionMock(next: (nil, response, nil))
                        let client = HttpClient(session: session)
                        client.get(
                            request: URLRequest(url: URL(string: "http://google.com")!),
                            completion: { (result: Result<RepositoryList, ApiError>) in
                                if case let .failure(error) = result, case .serialization = error {
                                    _ = succeed()
                                } else {
                                    fail("got wrong error")
                                }
                                done()
                            }
                        )
                    })
                }
            }

            context("when system has a custom error") {
                it("should return unknow error") {
                    waitUntil(action: { done in
                        let session = URLSessionMock(next: (nil, nil, NSError(domain: "error", code: 1, userInfo: nil)))
                        let client = HttpClient(session: session)
                        client.get(
                            request: URLRequest(url: URL(string: "http://anyurl.com")!),
                            completion: { (result: Result<RepositoryList, ApiError>) in
                                if case let .failure(error) = result, case .unknow = error {
                                    _ = succeed()
                                } else {
                                    fail("got wrong error")
                                }
                                done()
                            }
                        )
                    })
                }
            }

            context("an inproper http request") {
                it("should return unknow error") {
                    waitUntil(action: { done in
                        let session = URLSessionMock(next: (nil, nil, nil))
                        let client = HttpClient(session: session)
                        client.get(
                            request: URLRequest(url: URL(string: "http://anyrurl.com")!),
                            completion: { (result: Result<RepositoryList, ApiError>) in
                                if case let .failure(error) = result, case .unknow = error {
                                    _ = succeed()
                                } else {
                                    fail("got wrong error")
                                }
                                done()
                            }
                        )
                    })
                }
            }

            context("a bad request") {
                it("should return badRequest error") {
                    waitUntil(action: { done in
                        let response = HTTPURLResponse(url: URL(string: "http://anyurl.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
                        let session = URLSessionMock(next: (nil, response, nil))
                        let client = HttpClient(session: session)
                        client.get(
                            request: URLRequest(url: URL(string: "http://google.com")!),
                            completion: { (result: Result<RepositoryList, ApiError>) in
                                if case let .failure(error) = result, case .badRequest = error {
                                    _ = succeed()
                                } else {
                                    fail("got wrong error")
                                }
                                done()
                            }
                        )
                    })
                }
            }

            context("a not authorized request") {
                it("should return unauthorized error") {
                    waitUntil(action: { done in
                        let response = HTTPURLResponse(url: URL(string: "http://anyurl.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)!
                        let session = URLSessionMock(next: (nil, response, nil))
                        let client = HttpClient(session: session)
                        client.get(
                            request: URLRequest(url: URL(string: "http://anyurl.com")!),
                            completion: { (result: Result<RepositoryList, ApiError>) in
                                if case let .failure(error) = result, case .unauthorized = error {
                                    _ = succeed()
                                } else {
                                    fail("got wrong error")
                                }
                                done()
                            }
                        )
                    })
                }
            }
        }
    }
}
