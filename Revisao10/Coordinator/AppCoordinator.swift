//
//  AppCoordinator.swift
//  Revisao10
//
//  Created by ednardo alves on 28/09/25.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let nav: UINavigationController
    private let api = MockAPIClient()
    init(window: UIWindow) {
        self.window = window
        self.nav = UINavigationController()
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    func start() {
        if let _ = AuthService.shared.currentUser {
            showFeed()
        } else {
            showLogin()
        }
    }

    func showLogin() {
        let loginVM = LoginViewModel(api: api)
        let loginVC = LoginViewController(viewModel: loginVM)
        loginVC.onLoginSuccess = { [weak self] in
            self?.showFeed()
        }
        nav.setViewControllers([loginVC], animated: false)
    }

    func showFeed() {
        let feedVM = FeedViewModel(api: api)
        let feedVC = FeedViewController(viewModel: feedVM)
        feedVC.onCreatePost = { [weak self] in
            self?.presentCreatePost()
        }
        feedVC.onLogout = { [weak self] in
            AuthService.shared.logout()
            self?.showLogin()
        }
        nav.setViewControllers([feedVC], animated: true)
    }

    func presentCreatePost() {
        guard let user = AuthService.shared.currentUser, user.role == .teacher else { return }
        let vm = CreatePostViewModel(api: api, currentUser: user)
        let createVC = CreatePostViewController(viewModel: vm)
        createVC.onSaved = { [weak self] in
            self?.showFeed() // simples: recarrega feed
        }
        let navC = UINavigationController(rootViewController: createVC)
        nav.present(navC, animated: true, completion: nil)
    }
}

