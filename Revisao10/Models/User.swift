//
//  User.swift
//  Revisao10
//
//  Created by ednardo alves on 30/09/25.
//

import Foundation

enum Role: String, Codable {
    case student
    case teacher
}

struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var role: Role
    var bio: String?
}
