//
//  MemoryLeakViewController.swift
//  MemoryLeaks
//
//  Created by Test on 6/8/25.
//

import UIKit

class MemoryLeakViewController: UIViewController {
    var closure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Memory Leak: self is captured strongly
        closure = {
            print(self.view.description)
        }
        
        // Hardcoded password (security hotspot)
        let password = "SuperSecret123!"
        print("Password is: \(password)") // Sensitive data exposure

        // Force unwrap (can cause crash)
        let label: UILabel! = UILabel()
        label.text = "Leaky View Controller"
        self.view.addSubview(label)

        // UI operation on background thread (UI thread violation)
        DispatchQueue.global().async {
            label.text = "Updated from background thread"
        }
        
        // Long method (code smell)
        longFunction()

        // Hardcoded API key (security issue)
        let apiKey = "AIzaSyD-FakeKeyForTestingSonarQube"
        print("API Key: \(apiKey)")
    }
    
    func longFunction() {
        for _ in 0..<100 {
            print("Doing unnecessary work") // Code smell: useless loop
        }
    }
    
    deinit {
        print("MemoryLeakViewController deinitialized") // Will never be called due to leak
    }
}
