//
//  PostDetailViewController.swift
//  Revisao10
//
//  Created by ednardo alves on 16/10/25.
//

import UIKit

final class PostDetailViewController: UIViewController {
    private let post: Post
    private let apiClient: Any // placeholder if needed

    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let contentTextView = UITextView()

    init(post: Post, api: Any? = nil) {
        self.post = post
        self.apiClient = api as Any
        super.init(nibName: nil, bundle: nil)
        title = "Material"
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        populate()
    }

    private func setupViews() {
        [titleLabel, authorLabel, contentTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textColor = .secondaryLabel
        contentTextView.isEditable = false
        contentTextView.font = .systemFont(ofSize: 16)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            contentTextView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
            contentTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ])
    }

    private func populate() {
        titleLabel.text = post.title
        authorLabel.text = "Por \(post.authorName) • \(post.categories.joined(separator: ", "))"
        contentTextView.text = post.content
    }
}

