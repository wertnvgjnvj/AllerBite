
//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//class UserViewModel: ObservableObject {
//    @Published var user: User?
//    @Published var isLoading = false
//    @Published var errorMessage = ""
//    @Published var isEmailVerificationSent = false
//    init() {
//        fetchUser()
//    }
//
//
//    // MARK: - Register new user
////    func registerUser(username: String, age: Int, email: String, password: String) {
////            isLoading = true
////            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
////                self?.isLoading = false
////                if let error = error {
////                    self?.errorMessage = "Error creating user: \(error.localizedDescription)"
////                    print("Error creating user: \(error.localizedDescription)")
////                    return
////                }
////                
////                guard let userId = result?.user.uid else {
////                    self?.errorMessage = "Error: User ID is nil after registration."
////                    print("Error: User ID is nil after registration.")
////                    return
////                }
////
////                print("User created with uid: \(userId)")
////                self?.insertUserRecord(id: userId, username: username, age: age, email: email)
////            }
////        }
//    
//   
//    func registerAndSendVerification(username: String, email: String, password: String) {
//            isLoading = true
//            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
//                self?.isLoading = false
//                if let error = error {
//                    self?.errorMessage = "Error creating user: \(error.localizedDescription)"
//                    print("Error creating user: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let userId = result?.user.uid else {
//                    self?.errorMessage = "Error: User ID is nil after registration."
//                    print("Error: User ID is nil after registration.")
//                    return
//                }
//
//                print("User created with uid: \(userId)")
//                self?.insertUserRecord(id: userId, username: username, email: email)
//
//                // Send Email Verification
//                self?.sendEmailVerification(to: result?.user)
//            }
//        }
//
//
//        // MARK: - Send email verification
//    private func sendEmailVerification(to user: FirebaseAuth.User?) {
//           guard let user = user else {
//               print("Error: User object is nil for email verification.")
//               return
//           }
//
//           user.sendEmailVerification { [weak self] error in
//               if let error = error {
//                   self?.errorMessage = "Error sending email verification: \(error.localizedDescription)"
//                   print("Error sending email verification: \(error.localizedDescription)")
//               } else {
//                   print("Verification email sent successfully.")
//                   DispatchQueue.main.async {
//                       self?.isEmailVerificationSent = true
//                   }
//               }
//           }
//       }
//   }
//    // MARK: - Insert user records
//    func insertUserRecord(id: String, username: String, age: Int, email: String) {
//        let user = User(id: id, username: username, age: age, email: email, allergies: [], veg: "") // allergies default to empty array
//
//        // Convert the User object to a dictionary to save in Firestore
//        do {
//            let userData = try Firestore.Encoder().encode(user)
//            Firestore.firestore().collection("users").document(id).setData(userData) { error in
//                if let error = error {
//                    print("Error saving user to Firestore: \(error.localizedDescription)")
//                } else {
//                    print("User successfully saved to Firestore with default allergies.")
//                }
//            }
//        } catch {
//            print("Error encoding user data: \(error.localizedDescription)")
//        }
//    }
//
//
//
//
//    // MARK: - Fetch user data from Firestore
//    func fetchUser() {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            self.errorMessage = "User not logged in"
//            print("Error: User not logged in.")
//            return
//        }
//
//        isLoading = true
//        let db = Firestore.firestore()
//        
//        db.collection("users").document(userId).getDocument { [weak self] document, error in
//            self?.isLoading = false
//            
//            if let error = error {
//                self?.errorMessage = "Failed to fetch user: \(error.localizedDescription)"
//                print("Failed to fetch user: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let documentData = document?.data() else {
//                self?.errorMessage = "User data not found"
//                print("User data not found in Firestore.")
//                return
//            }
//            
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
//                let fetchedUser = try JSONDecoder().decode(User.self, from: jsonData)
//                self?.user = fetchedUser
//                print("User data fetched successfully: \(fetchedUser)")
//            } catch {
//                self?.errorMessage = "Error decoding user data: \(error.localizedDescription)"
//                print("Error decoding user data: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    // MARK: - Create default categories for a new user
//    private func createDefaultCategories(for userId: String) {
//        let db = Firestore.firestore()
//        let categories = ["Fruits", "Vegetables", "Grains"]
//        
//        for category in categories {
//            db.collection("users").document(userId).collection("categories").addDocument(data: [
//                "name": category,
//                "created_at": Timestamp(date: Date())
//            ]) { error in
//                if let error = error {
//                    print("Error creating category \(category): \(error.localizedDescription)")
//                } else {
//                    print("Default category \(category) added")
//                }
//            }
//        }
//    }
//
//
//// MARK: - User Model Extension
//extension User {
//    func asDictionary() -> [String: Any] {
//        return [
//            "id": id,
//            "username": username,
//            "age": age,
//            "email": email
//        ]
//    }
//}
//
//


//import SwiftUI
//import Firebase
//import FirebaseAuth
//
//class UserViewModel: ObservableObject {
//    @Published var user: User?
//    @Published var isLoading = false
//    @Published var errorMessage = ""
//    @Published var isEmailVerificationSent = false // Tracks if verification email was sent
//    @Published var isEmailVerified = false // Tracks if the email is verified
//
//    init() {
//        fetchUser()
//    }
//
//    // MARK: - Register new user
//    func registerUser(username: String, email: String, password: String) {
//        isLoading = true
//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
//            self?.isLoading = false
//            if let error = error {
//                self?.errorMessage = "Error creating user: \(error.localizedDescription)"
//                print("Error creating user: \(error.localizedDescription)")
//                return
//            }
//
//            guard let userId = result?.user.uid else {
//                self?.errorMessage = "Error: User ID is nil after registration."
//                print("Error: User ID is nil after registration.")
//                return
//            }
//
//            print("User created with uid: \(userId)")
//            self?.insertUserRecord(id: userId, username: username, email: email)
//
//            // Send Email Verification
//            self?.sendEmailVerification(to: result?.user)
//        }
//    }
//
//    // MARK: - Send email verification
//    private func sendEmailVerification(to user: FirebaseAuth.User?) {
//        guard let user = user else {
//            print("Error: User object is nil for email verification.")
//            return
//        }
//
//        user.sendEmailVerification { [weak self] error in
//            if let error = error {
//                self?.errorMessage = "Error sending email verification: \(error.localizedDescription)"
//                print("Error sending email verification: \(error.localizedDescription)")
//            } else {
//                print("Verification email sent successfully.")
//                DispatchQueue.main.async {
//                    self?.isEmailVerificationSent = true
//                }
//                self?.checkEmailVerification(user: user)
//            }
//        }
//    }
//
//    // MARK: - Check if email is verified
//    private func checkEmailVerification(user: FirebaseAuth.User) {
//        // Repeatedly check if email is verified
//        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
//            user.reload { [weak self] error in
//                if let error = error {
//                    self?.errorMessage = "Error checking email verification: \(error.localizedDescription)"
//                    print("Error checking email verification: \(error.localizedDescription)")
//                    return
//                }
//
//                if user.isEmailVerified {
//                    DispatchQueue.main.async {
//                        self?.isEmailVerified = true
//                    }
//                    timer.invalidate() // Stop checking once verified
//                }
//            }
//        }
//    }
//
//    // MARK: - Insert user records
//    func insertUserRecord(id: String, username: String, email: String) {
//        let user = User(id: id, username: username, email: email, allergies: [], veg: "", isVerified: false) // isVerified default to false
//
//        // Convert the User object to a dictionary to save in Firestore
//        do {
//            let userData = try Firestore.Encoder().encode(user)
//            Firestore.firestore().collection("users").document(id).setData(userData) { error in
//                if let error = error {
//                    print("Error saving user to Firestore: \(error.localizedDescription)")
//                } else {
//                    print("User successfully saved to Firestore.")
//                }
//            }
//        } catch {
//            print("Error encoding user data: \(error.localizedDescription)")
//        }
//
//        // Create default categories for the new user
//        createDefaultCategories(for: id)
//    }
//
//    // MARK: - Fetch user data from Firestore
//    func fetchUser() {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            self.errorMessage = "User not logged in"
//            print("Error: User not logged in.")
//            return
//        }
//
//        isLoading = true
//        let db = Firestore.firestore()
//
//        db.collection("users").document(userId).getDocument { [weak self] document, error in
//            self?.isLoading = false
//
//            if let error = error {
//                self?.errorMessage = "Failed to fetch user: \(error.localizedDescription)"
//                print("Failed to fetch user: \(error.localizedDescription)")
//                return
//            }
//
//            guard let documentData = document?.data() else {
//                self?.errorMessage = "User data not found"
//                print("User data not found in Firestore.")
//                return
//            }
//
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
//                let fetchedUser = try JSONDecoder().decode(User.self, from: jsonData)
//                self?.user = fetchedUser
//
//                if fetchedUser.isVerified {
//                    self?.isEmailVerified = true // Track email verification status
//                    print("User is verified: \(fetchedUser)")
//                } else {
//                    self?.isEmailVerified = false
//                    print("User is not verified.")
//                }
//            } catch {
//                self?.errorMessage = "Error decoding user data: \(error.localizedDescription)"
//                print("Error decoding user data: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    // MARK: - Create default categories for a new user
//    private func createDefaultCategories(for userId: String) {
//        let db = Firestore.firestore()
//        let categories = ["Fruits", "Vegetables", "Grains"]
//
//        for category in categories {
//            db.collection("users").document(userId).collection("categories").addDocument(data: [
//                "name": category,
//                "created_at": Timestamp(date: Date())
//            ]) { error in
//                if let error = error {
//                    print("Error creating category \(category): \(error.localizedDescription)")
//                } else {
//                    print("Default category \(category) added")
//                }
//            }
//        }
//    }
//
//    // MARK: - Login user
//    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
//            if let error = error {
//                self?.errorMessage = "Error logging in: \(error.localizedDescription)"
//                completion(false)
//                return
//            }
//
//            guard let userId = result?.user.uid else {
//                self?.errorMessage = "Error: User ID is nil after login."
//                completion(false)
//                return
//            }
//
//            self?.fetchUser() // Fetch user data from Firestore
//
//            if self?.isEmailVerified == true {
//                completion(true)
//            } else {
//                self?.errorMessage = "Please verify your email before logging in."
//                completion(false)
//            }
//        }
//    }
//}

//here


import SwiftUI
import Firebase
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isEmailVerificationSent = false // Tracks if verification email was sent
    @Published var isEmailVerified = false // Tracks if the email is verified

    init() {
        fetchUser()
    }

    // MARK: - Register new user
    func registerUser(username: String, email: String, password: String) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = "Error creating user: \(error.localizedDescription)"
                print("Error creating user: \(error.localizedDescription)")
                return
            }

            guard let userId = result?.user.uid else {
                self?.errorMessage = "Error: User ID is nil after registration."
                print("Error: User ID is nil after registration.")
                return
            }

            print("User created with uid: \(userId)")
            self?.insertUserRecord(id: userId, username: username, email: email)

            // Send Email Verification
            self?.sendEmailVerification(to: result?.user)
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        }
    }

    // MARK: - Send email verification
    private func sendEmailVerification(to user: FirebaseAuth.User?) {
        guard let user = user else {
            print("Error: User object is nil for email verification.")
            return
        }

        user.sendEmailVerification { [weak self] error in
            if let error = error {
                self?.errorMessage = "Error sending email verification: \(error.localizedDescription)"
                print("Error sending email verification: \(error.localizedDescription)")
            } else {
                print("Verification email sent successfully.")
                DispatchQueue.main.async {
                    self?.isEmailVerificationSent = true
                }
                self?.checkEmailVerification(user: user)
            }
        }
    }

    // MARK: - Check if email is verified
    private func checkEmailVerification(user: FirebaseAuth.User) {
        // Repeatedly check if email is verified
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            user.reload { [weak self] error in
                if let error = error {
                    self?.errorMessage = "Error checking email verification: \(error.localizedDescription)"
                    print("Error checking email verification: \(error.localizedDescription)")
                    return
                }

                if user.isEmailVerified {
                    DispatchQueue.main.async {
                        self?.isEmailVerified = true
                    }
                    timer.invalidate() // Stop checking once verified
                }
            }
        }
    }

    // MARK: - Insert user records
    func insertUserRecord(id: String, username: String, email: String) {
        let user = User(id: id, username: username, email: email, allergies: [], veg: "", isVerified: false) // Default to false for isVerified

        // Convert the User object to a dictionary to save in Firestore
        do {
            let userData = try Firestore.Encoder().encode(user)
            Firestore.firestore().collection("users").document(id).setData(userData) { error in
                if let error = error {
                    print("Error saving user to Firestore: \(error.localizedDescription)")
                } else {
                    print("User successfully saved to Firestore with default allergies.")
                }
            }
        } catch {
            print("Error encoding user data: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch user data from Firestore
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.errorMessage = "User not logged in"
            print("Error: User not logged in.")
            return
        }

        isLoading = true
        let db = Firestore.firestore()

        db.collection("users").document(userId).getDocument { [weak self] document, error in
            self?.isLoading = false

            if let error = error {
                self?.errorMessage = "Failed to fetch user: \(error.localizedDescription)"
                print("Failed to fetch user: \(error.localizedDescription)")
                return
            }

            guard let documentData = document?.data() else {
                self?.errorMessage = "User data not found"
                print("User data not found in Firestore.")
                return
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
                let fetchedUser = try JSONDecoder().decode(User.self, from: jsonData)
                self?.user = fetchedUser
                print("User data fetched successfully: \(fetchedUser)")
            } catch {
                self?.errorMessage = "Error decoding user data: \(error.localizedDescription)"
                print("Error decoding user data: \(error.localizedDescription)")
            }
        }
    }
}

