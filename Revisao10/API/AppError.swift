//
//  AppError.swift
//  Revisao10
//
//  Created by ednardo alves on 03/10/25.
//

import Foundation

enum AppError: Error {
    case userNotFound
    case unauthorized
    case unknown
}

protocol APIClient {
    //Aut
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func register(user: User, password: String, completion: @escaping (Result<User, Error>) -> Void)
    // Posts
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void)
    func createPost(_ post: Post, completion: @escaping (Result<Post, Error>) -> Void)
    func updatePost(_ post: Post, completion: @escaping (Result<Post, Error>) -> Void)
    func deletePost(id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func searchPosts(query: String, completion: @escaping (Result<[Post], Error>) -> Void)
}
