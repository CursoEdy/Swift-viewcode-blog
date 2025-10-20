//
//  Post.swift
//  Revisao10
//
//  Created by ednardo alves on 30/09/25.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: UUID
    var title: String
    var content: String
    var authorId: UUID
    var authorName: String
    var categories: [String]
    var createdAt: Date
    var updatedAt: Date?
    var isDraft: Bool
}
