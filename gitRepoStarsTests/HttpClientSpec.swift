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
            context("when system has a custom error") {
                it("should return unknow error") {
                    let session = URLSessionMock(next: (nil, nil, NSError(domain: "error", code: 1, userInfo: nil)))
                    let client = HttpClient(session: session)
                    client.get(
                        request: URLRequest(url: URL(string: "http://google.com")!),
                        completion: { (result: Result<GitRepoList, ApiError>) in
                            if case let .failure(error) = result, case .unknow = error {
                                _ = succeed()
                            } else {
                                fail("got wrong error")
                            }
                        }
                    )
                }
            }

            context("an inproper http request") {
                it("should return unknow error") {
                    let session = URLSessionMock(next: (nil, nil, nil))
                    let client = HttpClient(session: session)
                    client.get(
                        request: URLRequest(url: URL(string: "http://google.com")!),
                        completion: { (result: Result<GitRepoList, ApiError>) in
                            if case let .failure(error) = result, case .unknow = error {
                                _ = succeed()
                            } else {
                                fail("got wrong error")
                            }
                        }
                    )
                }
            }

            context("a bad request") {
                it("should return badRequest error") {
                    let response = HTTPURLResponse(url: URL(string: "http://google.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
                    let session = URLSessionMock(next: (nil, response, nil))
                    let client = HttpClient(session: session)
                    client.get(
                        request: URLRequest(url: URL(string: "http://google.com")!),
                        completion: { (result: Result<GitRepoList, ApiError>) in
                            if case let .failure(error) = result, case .badRequest = error {
                                _ = succeed()
                            } else {
                                fail("got wrong error")
                            }
                        }
                    )
                }
            }

            context("a not authorized request") {
                it("should return unauthorized error") {
                    let response = HTTPURLResponse(url: URL(string: "http://google.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)!
                    let session = URLSessionMock(next: (nil, response, nil))
                    let client = HttpClient(session: session)
                    client.get(
                        request: URLRequest(url: URL(string: "http://google.com")!),
                        completion: { (result: Result<GitRepoList, ApiError>) in
                            if case let .failure(error) = result, case .unauthorized = error {
                                _ = succeed()
                            } else {
                                fail("got wrong error")
                            }
                        }
                    )
                }
            }
        }
    }
}
