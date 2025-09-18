import UIKit

// Strong delegate (cycle risk)
protocol UserListViewDelegate: AnyObject {
    func didLoad(users: [String])
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchUsers(completion: @escaping ([String]?, Error?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(["Ana", "Ben", "Cara"], nil) // callback on background thread
        }
    }

    func loadUsers(completion: @escaping ([String]?, Error?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            completion(["Ana", "Ben", "Cara"], nil) // duplicate logic + background thread callback
        }
    }
}

final class ProblematicViewController: UIViewController {

    var delegate: UserListViewDelegate?

    private let label = UILabel()
    private var users: [String] = []

    private var timer: Timer?

    private var onUsersChanged: (([String]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        label.textColor = .black
        view.addSubview(label)
        label.frame = CGRect(x: 20, y: 100, width: 300, height: 40)

        // NotificationCenter observer not removed (leak)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tokenDidRefresh(_:)),
                                               name: NSNotification.Name("token_refresh"),
                                               object: nil)

        NetworkManager.shared.fetchUsers { users, error in
            self.label.text = "Count: \(users!.count)" // force unwrap
            self.users = users!
        }

        NetworkManager.shared.loadUsers { users, error in
            self.label.text = "Users: \(users!.joined(separator: ", "))"
            self.users = users!

            // Strong capture of self stored in a property -> retain cycle
            self.onUsersChanged = { list in
                self.label.text = "Latest: \(list.first ?? "-")"
                self.users = list
            }
            self.onUsersChanged?(self.users)
        }

        // ❌ Timer retains self; never invalidated, fires forever
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.reloadCount()
        }

        // ❌ Misuse of unowned self (can crash if self deallocated before async resumes)
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) { [unowned self] in
            self.label.text = "Async done" // may crash
        }
    }

    @objc private func tokenDidRefresh(_ note: Notification) {
        DispatchQueue.global().async {
            self.label.text = "Token refreshed"
        }
    }

    private func reloadCount() {
        DispatchQueue.global().async {
            let count = self.users.count
            self.label.text = "Timer Count: \(count)"
        }
    }

    deinit {
        print("deinit ProblematicViewController")
    }
}
