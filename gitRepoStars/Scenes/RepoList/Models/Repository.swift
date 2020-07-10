//
//  GirRepo.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let starts: Int
    let owner: RepoOwner

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case starts = "stargazers_count"
        case owner = "owner"
    }
}
