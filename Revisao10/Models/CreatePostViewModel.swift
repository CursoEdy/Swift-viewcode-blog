//
//  CreatePostViewModel.swift
//  Revisao10
//
//  Created by ednardo alves on 16/10/25.
//

import Foundation

final class CreatePostViewModel {
    private let api: APIClient
    private let currentUser: User

    init(api: APIClient, currentUser: User) {
        self.api = api
        self.currentUser = currentUser
    }

    func createPost(title: String, content: String, categories: [String], isDraft: Bool, completion: @escaping (Result<Post, Error>) -> Void) {
        let post = Post(id: UUID(), title: title, content: content, authorId: currentUser.id, authorName: currentUser.name, categories: categories, createdAt: Date(), updatedAt: nil, isDraft: isDraft)
        api.createPost(post) { res in
            DispatchQueue.main.async { completion(res) }
        }
    }
}
