//
//  FeedViewModel.swift
//  Revisao10
//
//  Created by ednardo alves on 16/10/25.
//

import Foundation

final class FeedViewModel {
    private let api: APIClient
    private(set) var posts: [Post] = []
    var onPostsUpdated: (() -> Void)?

    init(api: APIClient) {
        self.api = api
    }

    func loadPosts() {
        api.fetchPosts { [weak self] res in
            DispatchQueue.main.async {
                switch res {
                case .success(let ps):
                    self?.posts = ps
                    self?.onPostsUpdated?()
                case .failure:
                    self?.posts = []
                    self?.onPostsUpdated?()
                }
            }
        }
    }

    func search(query: String, completion: @escaping ([Post]) -> Void) {
        api.searchPosts(query: query) { res in
            switch res {
            case .success(let ps): completion(ps)
            case .failure: completion([])
            }
        }
    }
}
