//
//  PostCell.swift
//  Revisao10
//
//  Created by ednardo alves on 16/10/25.
//

import UIKit

final class PostCell: UITableViewCell {
    static let reuseId = "PostCell"
    private let titleLabel = UILabel()
    private let metaLabel = UILabel()
    private let excerptLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        metaLabel.font = .systemFont(ofSize: 12)
        metaLabel.textColor = .secondaryLabel
        excerptLabel.font = .systemFont(ofSize: 14)
        excerptLabel.numberOfLines = 2
        [titleLabel, metaLabel, excerptLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            metaLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            metaLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            metaLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            excerptLabel.topAnchor.constraint(equalTo: metaLabel.bottomAnchor, constant: 6),
            excerptLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            excerptLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            excerptLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with post: Post) {
        titleLabel.text = post.title
        metaLabel.text = "\(post.authorName) • \(post.categories.joined(separator: ", "))"
        excerptLabel.text = String(post.content.prefix(200))
    }
}

