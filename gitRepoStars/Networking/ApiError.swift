//
//  ApiError.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case badRequest
    case unauthorized
    case serialization(String)
    case invalidPath
    case unknow(String)
}
