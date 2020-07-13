//
//  RepositoryCell.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 11/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation
import UIKit

class RepositoryCell: UITableViewCell  {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40 //imageView.frame.width / 2
        return imageView
    }()
    private lazy var repoNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    private lazy var startCountLabels: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.axis = .horizontal
        stack.alignment = .top
        return stack
    }()
    private lazy var subStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()

    private var imageLoadTask: URLSessionTask?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    override func prepareForReuse() {
        avatarImageView.image = nil
        repoNameLabel.text = nil
        startCountLabels.text = nil
        authorNameLabel.text = nil

        imageLoadTask?.cancel()
        imageLoadTask = nil
    }

    func setup(with repository: Repository) {
        loadImage(avatarURLString: repository.owner.avatarURL)
        repoNameLabel.text = repository.name
        startCountLabels.text = "\(repository.starts) Starts"
        authorNameLabel.text = repository.owner.login
    }

    private func loadImage(avatarURLString: String) {
        if let avatarURL = URL(string: avatarURLString) {
            imageLoadTask = URLSession.shared.dataTask(
                with: avatarURL,
                completionHandler: { data, response, error in
                    guard let data = data,
                        let image = UIImage(data: data) else {
                            return // Maybe set default image
                    }

                    DispatchQueue.main.async { [weak self] in
                        self?.avatarImageView.image = image
                    }
                }
            )
            imageLoadTask?.resume()
        }
    }

    private func configureViews() {
        subStackView.addArrangedSubview(repoNameLabel)
        subStackView.addArrangedSubview(authorNameLabel)
        subStackView.addArrangedSubview(startCountLabels)

        mainStackView.addArrangedSubview(avatarImageView)
        mainStackView.addArrangedSubview(subStackView)

        contentView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),

            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}
