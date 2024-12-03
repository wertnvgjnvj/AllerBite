//import SwiftUI
//import FirebaseCore
//import GoogleSignIn
//import FirebaseAuth
//import Firebase
//
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
//}
//
//
//
//@main
//struct AllerBiteApp: App {
//    // Register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//
//    // Initialize Firebase and set user session persistence
////    init() {
////        FirebaseApp.configure()
////        setFirebasePersistence()
////    }
//
//    var body: some Scene {
//        WindowGroup {
//            // Check if the user is already logged in or not
//            if Auth.auth().currentUser != nil {
//                // If logged in, navigate to the main app screen
//                MainView()  // Replace this with your main screen view
//            } else {
//                // If not logged in, show the onboarding/login view
//                onBoardingView()
//            }
//        }
//    }
//
//    // Set Firebase persistence for the user session
////    private func setFirebasePersistence() {
////        do {
////            // Use .local to keep the user logged in across app sessions
////            try Auth.auth().setPersistence(.local)
////        } catch let error {
////            print("Error setting Firebase persistence: \(error.localizedDescription)")
////        }
////    }
//}
//
//import SwiftUI
//import FirebaseCore
//import GoogleSignIn
//import FirebaseAuth
//import Firebase
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
//}
//
////class AppViewModel: ObservableObject {
////    @Published var isLoggedIn: Bool = false
////
////    init() {
////        // Check for an existing Firebase user session
////        self.isLoggedIn = Auth.auth().currentUser != nil
////
////        // Set up a listener for authentication state changes
////        Auth.auth().addStateDidChangeListener { _, user in
////            self.isLoggedIn = (user != nil)
////        }
////    }
////
////    // Function to sign out the user
////    func signOut() {
////        do {
////            try Auth.auth().signOut()
////            self.isLoggedIn = false
////        } catch {
////            print("Error signing out: \(error.localizedDescription)")
////        }
////    }
////}
//
//@main
//struct AllerBiteApp: App {
//    // Register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    
//    // Initialize the AppViewModel
//    @StateObject var appViewModel = AppViewModel()  // This is important
//    
//    
//    var body: some Scene {
//        WindowGroup {
//            
//            // Show the onboarding/login screen if the user is not logged in
//            onBoardingView()
//                .environmentObject(appViewModel)  // Inject appViewModel into the environment
//            
//        }
//    }
//}
//


import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

class AppViewModel1: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        // Check for an existing Firebase user session
        self.isLoggedIn = Auth.auth().currentUser != nil

        // Set up a listener for authentication state changes
        Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = (user != nil)
        }
    }

    // Function to sign out the user
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

@main
struct AllerBiteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var appViewModel = AppViewModel1()

    var body: some Scene {
        WindowGroup {
            if appViewModel.isLoggedIn {
                ContentView() // Show the main content if user is logged in
                    .environmentObject(appViewModel)
            } else {
                onBoardingView() // Show the onboarding/login screen if user is not logged in
                    .environmentObject(appViewModel)
            }
        }
    }
}
