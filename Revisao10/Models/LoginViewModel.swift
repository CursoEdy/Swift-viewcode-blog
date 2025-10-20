//
//  LoginViewModel.swift
//  Revisao10
//
//  Created by ednardo alves on 16/10/25.
//

import Foundation

final class LoginViewModel {
    private let api: APIClient
    init(api: APIClient) { self.api = api }

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        AuthService.shared.login(email: email, password: password, completion: completion)
    }

    func register(name: String, email: String, password: String, role: Role, completion: @escaping (Result<User, Error>) -> Void) {
        AuthService.shared.register(name: name, email: email, password: password, role: role, completion: completion)
    }
}

