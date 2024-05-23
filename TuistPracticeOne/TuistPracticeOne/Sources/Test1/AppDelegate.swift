import UIKit
import TuistPracticeOne

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let viewController = UIViewController()
        viewController.title = "TuistPracticeOne"
        viewController.view.backgroundColor = .green
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: viewController)
        self.window?.makeKeyAndVisible()

        return true
    }
}
