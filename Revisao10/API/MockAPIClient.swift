//
//  MockAPIClient.swift
//  Revisao10
//
//  Created by ednardo alves on 16/10/25.
//

import Foundation

final class MockAPIClient: APIClient {
    private var users: [User] = []
    private var passwords: [String: String] = [:] // email -> password (mock)
    private var posts: [Post] = []

    init() {
        seed()
    }

    private func seed() {
        // Seed users
        let teacher = User(id: UUID(), name: "Prof. Ana Silva", email: "Ana@escola.com", role: .teacher, bio: "Professora de matemática")
        let student = User(id: UUID(), name: "João Souza", email: "Joao@student.com", role: .student, bio: "Estudante de física")
        users = [teacher, student]
        passwords[teacher.email] = "123456"
        passwords[student.email] = "123456"

        // Seed posts
        posts = [
            Post(id: UUID(), title: "Derivadas — resumo", content: "Resumo prático sobre derivadas...", authorId: teacher.id, authorName: teacher.name, categories: ["Matemática","Cálculo"], createdAt: Date(), updatedAt: nil, isDraft: false),
            Post(id: UUID(), title: "Fórmulas essenciais de física", content: "Lista de fórmulas fundamentais para ENEM...", authorId: teacher.id, authorName: teacher.name, categories: ["Física"], createdAt: Date().addingTimeInterval(-3600*24*3), updatedAt: nil, isDraft: false)
        ]
    }

    // MARK: - Auth
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.5) {
            guard let pw = self.passwords[email], pw == password,
                  let user = self.users.first(where: { $0.email.lowercased() == email.lowercased() }) else {
                completion(.failure(AppError.userNotFound))
                return
            }
            completion(.success(user))
        }
    }

    func register(user: User, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.5) {
            if self.users.contains(where: { $0.email.lowercased() == user.email.lowercased() }) {
                completion(.failure(AppError.unknown))
                return
            }
            self.users.append(user)
            self.passwords[user.email] = password
            completion(.success(user))
        }
    }

    // MARK: - Posts
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.2) {
            let published = self.posts.filter { !$0.isDraft }.sorted { $0.createdAt > $1.createdAt }
            completion(.success(published))
        }
    }

    func createPost(_ post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.2) {
            self.posts.insert(post, at: 0)
            completion(.success(post))
        }
    }

    func updatePost(_ post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.2) {
            if let idx = self.posts.firstIndex(where: { $0.id == post.id }) {
                self.posts[idx] = post
                completion(.success(post))
            } else {
                completion(.failure(AppError.unknown))
            }
        }
    }

    func deletePost(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.2) {
            self.posts.removeAll(where: { $0.id == id })
            completion(.success(()))
        }
    }

    func searchPosts(query: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+0.2) {
            let q = query.lowercased()
            let results = self.posts.filter { post in
                !post.isDraft && (post.title.lowercased().contains(q) || post.content.lowercased().contains(q) || post.categories.contains(where: { $0.lowercased().contains(q) }))
            }
            completion(.success(results.sorted { $0.createdAt > $1.createdAt }))
        }
    }
}
