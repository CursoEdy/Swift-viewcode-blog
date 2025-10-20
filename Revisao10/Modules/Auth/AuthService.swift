//
//  AuthService.swift
//  Revisao10
//
//  Created by ednardo alves on 16/10/25.
//

import Foundation

final class AuthService {
    static let shared = AuthService(api: MockAPIClient())

    private let api: APIClient
    private(set) var currentUser: User?

    init(api: APIClient) {
        self.api = api
        // Em protótipo: nenhum usuário permanece logado entre execuções.
    }

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        api.login(email: email, password: password) { [weak self] res in
            switch res {
            case .success(let user):
                self?.currentUser = user
                completion(.success(user))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    func register(name: String, email: String, password: String, role: Role, completion: @escaping (Result<User, Error>) -> Void) {
        let user = User(id: UUID(), name: name, email: email, role: role, bio: nil)
        api.register(user: user, password: password) { [weak self] res in
            switch res {
            case .success(let u):
                self?.currentUser = u
                completion(.success(u))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    func logout() {
        currentUser = nil
    }
}

