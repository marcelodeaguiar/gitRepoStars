//
//  GitRepoList.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation

struct GitRepoList: Decodable {
    let items: [GitRepo]
}
