//
//  BindableType.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 11/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation

protocol BindableType {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get }

    func bind(to viewModel: ViewModelType)
}
