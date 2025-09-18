//
//  UserModel.swift
//  MemoryLeaks
//
//  Created by Test on 6/8/25.
//

import Foundation

class UserModel {
    var username: String
    var email: String
    static var currentUser: UserModel? // 🚨 Static mutable state (singleton misuse)

    // Business logic in model (bad separation of concerns)
    func isEmailValid() -> Bool {
        return email.contains("@") && email.contains(".")
    }

    init(username: String, email: String) {
        self.username = username
        self.email = email
    }

    // Hardcoded dummy data
    static func dummyUser() -> UserModel {
        return UserModel(username: "testUser", email: "test@example.com")
    }
}
