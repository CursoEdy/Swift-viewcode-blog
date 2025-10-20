//
//  FeedViewController.swift
//  Revisao10
//
//  Created by ednardo alves on 16/10/25.
//

import UIKit

final class FeedViewController: UIViewController, UISearchBarDelegate {
    private let viewModel: FeedViewModel
    var onCreatePost: (() -> Void)?
    var onLogout: (() -> Void)?

    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let refresh = UIRefreshControl()
    private let createButton = UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Feed"
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNav()
        setupTable()
        bind()
        viewModel.loadPosts()
    }

    private func setupNav() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        navigationItem.rightBarButtonItem = createButton
        createButton.target = self
        createButton.action = #selector(didTapCreate)
        let logout = UIBarButtonItem(title: "Sair", style: .plain, target: self, action: #selector(didTapLogout))
        navigationItem.leftBarButtonItem = logout

        // só professores veem create
        if AuthService.shared.currentUser?.role != .teacher {
            navigationItem.rightBarButtonItem = nil
        }
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(didPullRefresh), for: .valueChanged)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func bind() {
        viewModel.onPostsUpdated = { [weak self] in
            self?.refresh.endRefreshing()
            self?.tableView.reloadData()
        }
    }

    @objc private func didPullRefresh() { viewModel.loadPosts() }
    @objc private func didTapCreate() { onCreatePost?() }
    @objc private func didTapLogout() { onLogout?() }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.posts.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = viewModel.posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseId, for: indexPath) as! PostCell
        cell.configure(with: post)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = viewModel.posts[indexPath.row]
        let detail = PostDetailViewController(post: post, api: viewModel)
        navigationController?.pushViewController(detail, animated: true)
    }
}
