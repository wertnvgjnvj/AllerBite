//
//  AuthViewModel.swift
//  AllerBite
//
//  Created by Sahil Aggarwal on 13/10/24.
//


//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//class UserViewModel: ObservableObject {
//    @Published var user: User?
//    @Published var isLoading = false
//    @Published var errorMessage = ""
//
//    // Save user data to Firestore after registration
//    func saveUser(username: String, age: Int, email: String) {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            self.errorMessage = "User not logged in"
//            return
//        }
//
//        let newUser = User(id: uid, username: username, age: age, email: email)
//        let db = Firestore.firestore()
//
//        do {
//            // Using setData(from:) to save the user
//            try db.collection("users").document(uid).setData(from: newUser) { error in
//                if let error = error {
//                    self.errorMessage = "Failed to save user: \(error.localizedDescription)"
//                } else {
//                    self.user = newUser
//                    print("User saved successfully.")
//                }
//            }
//        } catch let error {
//            self.errorMessage = "Failed to encode user: \(error.localizedDescription)"
//        }
//    }
//
//    // Fetch user data from Firestore based on the current user's UID
//    func fetchUser() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            errorMessage = "User not logged in"
//            return
//        }
//        
//        isLoading = true
//        let db = Firestore.firestore()
//        
//        db.collection("users").document(uid).getDocument { snapshot, error in
//            self.isLoading = false
//            
//            if let error = error {
//                self.errorMessage = "Failed to fetch user: \(error.localizedDescription)"
//                return
//            }
//            
//            guard let data = snapshot?.data() else {
//                self.errorMessage = "User data not found"
//                return
//            }
//            
//            do {
//                // Using JSONDecoder to decode the data into User
//                let userData = try JSONSerialization.data(withJSONObject: data, options: [])
//                self.user = try JSONDecoder().decode(User.self, from: userData)
//            } catch {
//                self.errorMessage = "Error decoding user data: \(error.localizedDescription)"
//            }
//        }
//    }
//}
//



//import SwiftUI
//import Firebase
//import FirebaseAuth
//
//class AuthViewModel: ObservableObject {
//    @Published var userSession: FirebaseAuth.User?
//    @Published var didAuthenticateUser = false
//    @Published var currentUser: User?
//    private var tempUserSession : FirebaseAuth.User?
//    
//    private let service = UserService()
//    
//    init() {
//        self.userSession = Auth.auth().currentUser
//        self.fetchUser()
//    }
//    
//    func login(withEmail email: String, password: String) {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
//                return
//            }
//            guard let user = result?.user else { return }
//            self.userSession = user
//            self.fetchUser()
//            self.didAuthenticateUser = true
//            print("DEBUG: Did log user in.")
//        }
//    }
//    
//    func register(withEmail email: String, password: String, fullname: String, username: String) {
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            if let error = error {
//                print("DEBUG: Failed to register with error \(error.localizedDescription)")
//                return
//            }
//            guard let user = result?.user else { return }
//            
//            self.tempUserSession = user
//            
//            let data = ["email": email, "username": username.lowercased(), "fullname": fullname, "uid": user.uid]
//            
//            Firestore.firestore().collection("users")
//                .document(user.uid)
//                .setData(data) { _ in
//                 
//                    self.didAuthenticateUser = true // Trigger navigation
//                }
//        }
//    }
//    
//    func signOut() {
//        userSession = nil
//        try? Auth.auth().signOut()
//    }
////    func uploadProfileImage(_ image: UIImage){
////        guard let uid = tempUserSession?.uid else{return}
////        
////        ImageUploader.uploadImage(image:image){
////            profileImageUrl in
////            Firestore.firestore().collection("users")
////                .document(uid)
////                .updateData(["profileImageUrl":profileImageUrl]) { _ in
////                    self.userSession = self.tempUserSession
////                    self.fetchUser()
////                }
////        }
////    }
//    func fetchUser(){
//        guard let uid = self.userSession?.uid else {return}
//        
//        service.fetchUser(withUid: uid) { user
//            in
//            self.currentUser=user
//        }
//    }
//}
//
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage = ""
    init() {
        fetchUser()
    }


    // MARK: - Register new user
    func registerUser(username: String, age: Int, email: String, password: String) {
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
                self?.insertUserRecord(id: userId, username: username, age: age, email: email)
            }
        }
    // MARK: - Insert user records
    func insertUserRecord(id: String, username: String, age: Int, email: String) {
        let user = User(id: id, username: username, age: age, email: email, allergies: []) // allergies default to empty array

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

    // MARK: - Create default categories for a new user
    private func createDefaultCategories(for userId: String) {
        let db = Firestore.firestore()
        let categories = ["Fruits", "Vegetables", "Grains"]
        
        for category in categories {
            db.collection("users").document(userId).collection("categories").addDocument(data: [
                "name": category,
                "created_at": Timestamp(date: Date())
            ]) { error in
                if let error = error {
                    print("Error creating category \(category): \(error.localizedDescription)")
                } else {
                    print("Default category \(category) added")
                }
            }
        }
    }
}

// MARK: - User Model Extension
extension User {
    func asDictionary() -> [String: Any] {
        return [
            "id": id,
            "username": username,
            "age": age,
            "email": email
        ]
    }
}


