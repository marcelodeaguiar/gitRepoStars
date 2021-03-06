//
//  GirRepo.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation

struct Repository: Decodable, Equatable {
    let name: String
    let starts: Int
    let owner: RepositoryOwner

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case starts = "stargazers_count"
        case owner = "owner"
    }
}
