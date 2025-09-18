//
//  InsecureLoginViewController.swift
//  MemoryLeaks
//
//  Created by Test on 6/8/25.
//

import UIKit

class InsecureLoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Hardcoded credentials (security issue)
        let username = "admin"
        let password = "password123" // 🚨 Sensitive info

        // Fake login simulation
        if login(user: username, pass: password) {
            print("Logged in as \(username)")
        } else {
            fatalError("Login failed!") // 🚨 Crash
        }

        // Save password to UserDefaults (security issue)
        UserDefaults.standard.set(password, forKey: "savedPassword")
    }

    func login(user: String, pass: String) -> Bool {
        return user == "admin" && pass == "password123"
    }
}
