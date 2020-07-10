//
//  RepoOwner.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation

struct RepoOwner: Decodable {
    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey{
        case login = "login"
        case avatarURL = "avatar_url"
    }
}
