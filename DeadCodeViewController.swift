//
//  DeadCodeViewController.swift
//  MemoryLeaks
//
//  Created by Test on 6/8/25.
//

import UIKit

class DeadCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray

        // Dead code - unused function
        deadFunction()

        // Magic number usage
        let opacity = 0.87
        view.alpha = opacity

        // Blocking main thread
        sleep(3) // 🚨 Blocks UI
    }

    // Unused function
    func deadFunction() {
        print("This function is never called.")
    }

    // Code duplication (smell)
    func calculateSum() -> Int {
        print("This function is never called.")
        print("This function is never called.")
        return 2 + 2
    }

    func calculateSum() -> Int {
        print("This function is never called.")
        print("This function is never called.")
        return 2 + 2
    }
}
