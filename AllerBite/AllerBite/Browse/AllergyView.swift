//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//
//
//// Model for Allergy
//struct Allergy: Identifiable, Hashable, Codable {
//    @DocumentID var id: String? // Document ID from Firestore
//    var symbol: String
//    var name: String
//}
//
//// View for managing allergies
//struct AllergyView: View {
//    @StateObject private var firestoreManager = FirestoreManager() // Firestore manager for allergy handling
//    @StateObject private var userViewModel = UserViewModel()       // Instance of UserViewModel to get user data
//
//    @State private var searchText = ""
//    @State private var navigateToContentView = false
//    @State private var selectedAllergies: Set<String> = [] // Stores selected allergies
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if userViewModel.isLoading {
//                    ProgressView("Loading user data...") // Show loading while fetching user data
//                } else {
//                    List {
//                        ForEach(filteredAllergies, id: \.id) { allergy in
//                            AllergyRow(
//                                allergy: allergy,
//                                isSelected: selectedAllergies.contains(allergy.name),
//                                selectedAllergies: $selectedAllergies
//                            )
//                            .padding()
//                        }
//                    }
//                }
//            }
//            .searchable(text: $searchText)
//            .navigationTitle("Choose Your Allergy")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(
//                        destination: MainView().navigationBarBackButtonHidden(true),
//                        isActive: $navigateToContentView
//                    ) {
//                        Button("Done") {
//                            if let userID = userViewModel.user?.id {
//                                firestoreManager.saveUserAllergies(userID: userID, allergies: Array(selectedAllergies))
//                                print("Saved allergies: \(selectedAllergies) for user ID: \(userID)")
//                            } else {
//                                print("Error: User ID not available.")
//                            }
//                            navigateToContentView = true
//                        }
//                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        .disabled(userViewModel.user == nil) // Disable button until user data is loaded
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            firestoreManager.fetchAllergies()
//            userViewModel.fetchUser()  // Fetch user data
//            
//            // Load saved allergies for the current user
//            if let userID = userViewModel.user?.id {
//                firestoreManager.fetchUserAllergies(userID: userID)
//            }
//        }
//        .onChange(of: FirestoreManager.userSavedAllergies) { savedAllergies in
//            self.selectedAllergies = Set(savedAllergies) // Update selected allergies with saved allergies
//        }
//    }
//
//    // Filter allergies based on search text
//    var filteredAllergies: [Allergy] {
//        searchText.isEmpty ? firestoreManager.allergies : firestoreManager.allergies.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//    }
//}
//
//// AllergyRow view for individual allergy items
//struct AllergyRow: View {
//    let allergy: Allergy
//    let isSelected: Bool
//    @Binding var selectedAllergies: Set<String> // Use binding to update selectedAllergies
//
//    var body: some View {
//        HStack {
//            Text(allergy.symbol)
//                .font(.title)
//            Text(allergy.name)
//            Spacer()
//            if isSelected {
//                Image(systemName: "checkmark.circle")
//                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//            }
//        }
//        .padding(.vertical, -5)
//        .contentShape(Rectangle()) // Make the entire row tappable
//        .onTapGesture {
//            if isSelected {
//                selectedAllergies.remove(allergy.name)
//            } else {
//                selectedAllergies.insert(allergy.name)
//            }
//        }
//    }
//}
//
//// FirestoreManager for managing Firestore operations
//class FirestoreManager: ObservableObject {
//    @Published var allergies: [Allergy] = []
//    static var userSavedAllergies: [String] = [] // New variable to store user's saved allergies
//
//    private var db = Firestore.firestore()
//
//    func fetchAllergies() {
//        db.collection("allergy").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching allergies: \(error)")
//                return
//            }
//
//            guard let documents = snapshot?.documents else {
//                print("No allergy documents found")
//                return
//            }
//
//            self.allergies = documents.compactMap { document -> Allergy? in
//                let allergy = try? document.data(as: Allergy.self)
//                print("Fetched allergy:", allergy) // Debugging line
//                return allergy
//            }
//            print("All allergies fetched:", self.allergies)
//        }
//    }
//    
//    func saveUserAllergies(userID: String, allergies: [String]) {
//        let userRef = db.collection("users").document(userID)
//        
//        userRef.getDocument { (document, error) in
//            if let error = error {
//                print("Error fetching user document: \(error)")
//                return
//            }
//
//            if let document = document, document.exists {
//                // Update the existing document with allergies
//                userRef.updateData(["allergies": allergies]) { error in
//                    if let error = error {
//                        print("Error updating allergies: \(error)")
//                    } else {
//                        print("Allergies successfully updated!")
//                    }
//                }
//            } else {
//                // Document doesn't exist, create it with initial data
//                let newUser = User(id: userID, username: "defaultUsername", age: 0, email: "default@example.com", allergies: allergies)
//                do {
//                    try userRef.setData(from: newUser)
//                    print("User and allergies successfully created!")
//                } catch let error {
//                    print("Error creating user: \(error)")
//                }
//            }
//        }
//    }
//
//    // Updated function to fetch saved allergies and store them in userSavedAllergies
//    func fetchUserAllergies(userID: String) {
//        let userRef = db.collection("users").document(userID)
//        
//        userRef.getDocument { (document, error) in
//            if let error = error {
//                print("Error fetching user allergies: \(error)")
//                return
//            }
//            
//            if let document = document, let data = document.data(),
//               let allergies = data["allergies"] as? [String] {
//                FirestoreManager.userSavedAllergies = allergies // Store fetched allergies in userSavedAllergies
//            } else {
//                print("User document does not exist or allergies not found.")
//                FirestoreManager.userSavedAllergies = [] // Default to an empty list if no allergies are found
//            }
//        }
//    }
//}

//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//struct Allergy: Identifiable, Hashable, Codable {
//    @DocumentID var id: String?
//    var symbol: String
//    var name: String
//}
//
//struct AllergyView: View {
//    @StateObject private var firestoreManager = FirestoreManager()
//    @StateObject private var userViewModel = UserViewModel()
//
//    @State private var searchText = ""
//    @State private var navigateToContentView = false
//    @State private var selectedAllergies: Set<String> = []
//    @State private var isLoading = false // State to track loading
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if userViewModel.isLoading || isLoading { // Show loading spinner if isLoading is true
//                    ProgressView("Loading...")
//                        .transition(.opacity)
//                } else {
//                    List {
//                        ForEach(filteredAllergies, id: \.id) { allergy in
//                            AllergyRow(
//                                allergy: allergy,
//                                isSelected: selectedAllergies.contains(allergy.name),
//                                selectedAllergies: $selectedAllergies,
//                                isLoading: $isLoading // Pass the loading state to the row
//                            )
//                        }
//                    }
//                }
//            }
//            .searchable(text: $searchText)
//            .navigationTitle("Choose Your Allergy")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(destination: MainView().navigationBarBackButtonHidden(true), isActive: $navigateToContentView) {
//                        Button("Done") {
//                            if let userID = userViewModel.user?.id {
//                                firestoreManager.saveUserAllergies(userID: userID, allergies: Array(selectedAllergies))
//                            }
//                            navigateToContentView = true
//                        }
//                        .disabled(userViewModel.user == nil)
//                    }
//                }
//            }
//        }
//        .onAppear {
//            firestoreManager.fetchAllergies()
//            userViewModel.fetchUser()
//            if let userID = userViewModel.user?.id {
//                firestoreManager.fetchUserAllergies(userID: userID) { savedAllergies in
//                    self.selectedAllergies = Set(savedAllergies)
//                }
//            }
//        }
//    }
//
//    var filteredAllergies: [Allergy] {
//        searchText.isEmpty ? firestoreManager.allergies : firestoreManager.allergies.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//    }
//}
//
//struct AllergyRow: View {
//    let allergy: Allergy
//    let isSelected: Bool
//    @Binding var selectedAllergies: Set<String>
//    @Binding var isLoading: Bool // Bind loading state
//
//    var body: some View {
//        HStack {
//            Text(allergy.symbol).font(.title)
//            Text(allergy.name)
//            Spacer()
//            if isSelected {
//                Image(systemName: "checkmark.circle").foregroundColor(.green)
//            }
//        }
//        .contentShape(Rectangle()) // Ensures the entire row is tappable
//        .onTapGesture {
//            isLoading = true // Set loading to true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Add 1-second delay
//                if isSelected {
//                    selectedAllergies.remove(allergy.name)
//                } else {
//                    selectedAllergies.insert(allergy.name)
//                }
//                isLoading = false // Set loading back to false
//            }
//        }
//    }
//}
//
//class FirestoreManager: ObservableObject {
//    @Published var allergies: [Allergy] = []
//    static var userSavedAllergies: [String] = []
//
//    private var db = Firestore.firestore()
//
//    func fetchAllergies() {
//        db.collection("allergy").getDocuments { snapshot, error in
//            guard error == nil, let documents = snapshot?.documents else { return }
//            self.allergies = documents.compactMap { try? $0.data(as: Allergy.self) }
//        }
//    }
//
//    func saveUserAllergies(userID: String, allergies: [String]) {
//        let userRef = db.collection("users").document(userID)
//        userRef.setData(["allergies": allergies], merge: true)
//    }
//
//    func fetchUserAllergies(userID: String, completion: @escaping ([String]) -> Void) {
//        db.collection("users").document(userID).getDocument { document, _ in
//            if let allergies = document?.get("allergies") as? [String] {
//                FirestoreManager.userSavedAllergies = allergies
//                completion(allergies)
//            } else {
//                completion([])
//            }
//        }
//    }
//}

//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//struct Allergy: Identifiable, Hashable, Codable {
//    @DocumentID var id: String?
//    var symbol: String
//    var name: String
//}
//
//struct AllergyView: View {
//    @StateObject private var firestoreManager = FirestoreManager()
//    @StateObject private var userViewModel = UserViewModel()
//
//    @State private var searchText = ""
//    @State private var navigateToContentView = false
//    @State private var selectedAllergies: Set<String> = []
//    @State private var isLoading = false // State to track the loading indicator
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if isLoading {
//                    ProgressView("Saving allergies...")
//                        .transition(.opacity)
//                } else if userViewModel.isLoading {
//                    ProgressView("Loading user data...")
//                } else {
//                    List {
//                        ForEach(filteredAllergies, id: \.id) { allergy in
//                            AllergyRow(
//                                allergy: allergy,
//                                isSelected: selectedAllergies.contains(allergy.name),
//                                selectedAllergies: $selectedAllergies
//                            )
//                        }
//                    }
//                }
//            }
//            .searchable(text: $searchText)
//            .navigationTitle("Choose Your Allergy")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(
//                        destination: MainView().navigationBarBackButtonHidden(true),
//                        isActive: $navigateToContentView
//                    ) {
//                        Button("Done") {
//                            saveAllergies()
//                            firestoreManager.fetchUserAllergies(userID: <#T##String#>, completion: <#T##([String]) -> Void#>)
//                            
//                        }
//                        .disabled(userViewModel.user == nil || isLoading)
//                    }
//                }
//            }
//        }
//        .onAppear {
//            firestoreManager.fetchAllergies()
//            userViewModel.fetchUser()
//            if let userID = userViewModel.user?.id {
//                firestoreManager.fetchUserAllergies(userID: userID) { savedAllergies in
//                    self.selectedAllergies = Set(savedAllergies)
//                }
//            }
//        }
//    }
//
//    /// Save allergies and show a loading indicator
//    private func saveAllergies() {
//        isLoading = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            if let userID = userViewModel.user?.id {
//                firestoreManager.saveUserAllergies(userID: userID, allergies: Array(selectedAllergies))
//            }
//            isLoading = false
//            navigateToContentView = true
//        }
//    }
//
//    var filteredAllergies: [Allergy] {
//        searchText.isEmpty ? firestoreManager.allergies : firestoreManager.allergies.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//    }
//}
//
//struct AllergyRow: View {
//    let allergy: Allergy
//    let isSelected: Bool
//    @Binding var selectedAllergies: Set<String>
//
//    var body: some View {
//        HStack {
//            Text(allergy.symbol).font(.title)
//            Text(allergy.name)
//            Spacer()
//            if isSelected {
//                Image(systemName: "checkmark.circle").foregroundColor(.green)
//            }
//        }
//        .contentShape(Rectangle()) // Ensures the entire row is tappable
//        .onTapGesture {
//            if isSelected {
//                selectedAllergies.remove(allergy.name)
//            } else {
//                selectedAllergies.insert(allergy.name)
//            }
//        }
//    }
//}
//
//class FirestoreManager: ObservableObject {
//    @Published var allergies: [Allergy] = []
//    static var userSavedAllergies: [String] = []
//
//    private var db = Firestore.firestore()
//
//    func fetchAllergies() {
//        db.collection("allergy").getDocuments { snapshot, error in
//            guard error == nil, let documents = snapshot?.documents else { return }
//            self.allergies = documents.compactMap { try? $0.data(as: Allergy.self) }
//        }
//    }
//
//    func saveUserAllergies(userID: String, allergies: [String]) {
//        let userRef = db.collection("users").document(userID)
//        userRef.setData(["allergies": allergies], merge: true)
//    }
//
//    func fetchUserAllergies(userID: String, completion: @escaping ([String]) -> Void) {
//        db.collection("users").document(userID).getDocument { document, _ in
//            if let allergies = document?.get("allergies") as? [String] {
//                FirestoreManager.userSavedAllergies = allergies
//                completion(allergies)
//            } else {
//                completion([])
//            }
//        }
//    }
//}


import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct Allergy: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var symbol: String
    var name: String
}

struct AllergyView: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @StateObject private var userViewModel = UserViewModel()

    @State private var searchText = ""
    @State private var navigateToContentView = false
    @State private var selectedAllergies: Set<String> = []
    @State private var isLoading = false // State to track the loading indicator

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Saving allergies...")
                        .transition(.opacity)
                } else if userViewModel.isLoading {
                    ProgressView("Loading user data...")
                } else {
                    List {
                        ForEach(filteredAllergies, id: \.id) { allergy in
                            AllergyRow(
                                allergy: allergy,
                                isSelected: selectedAllergies.contains(allergy.name),
                                selectedAllergies: $selectedAllergies
                            )
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Choose Your Allergy")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: MainView().navigationBarBackButtonHidden(true),
                        isActive: $navigateToContentView
                    ) {
                        Button("Done") {
                            saveAllergies()
                        }
                        .disabled(userViewModel.user == nil || isLoading)
                    }
                }
            }
        }
        .onAppear {
            firestoreManager.fetchAllergies()
            userViewModel.fetchUser()
            if let userID = userViewModel.user?.id {
                firestoreManager.fetchUserAllergies(userID: userID) { savedAllergies in
                    self.selectedAllergies = Set(savedAllergies)
                }
            }
        }
    }

    /// Save allergies and fetch updated data
    private func saveAllergies() {
        guard let userID = userViewModel.user?.id else { return }
        isLoading = true

        // Save allergies to Firestore
        firestoreManager.saveUserAllergies(userID: userID, allergies: Array(selectedAllergies))

        // Fetch updated allergies after saving
        firestoreManager.fetchUserAllergies(userID: userID) { updatedAllergies in
            DispatchQueue.main.async {
                self.selectedAllergies = Set(updatedAllergies)
                isLoading = false
                navigateToContentView = true
            }
        }
    }

    var filteredAllergies: [Allergy] {
        searchText.isEmpty ? firestoreManager.allergies : firestoreManager.allergies.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}

struct AllergyRow: View {
    let allergy: Allergy
    let isSelected: Bool
    @Binding var selectedAllergies: Set<String>

    var body: some View {
        HStack {
            Text(allergy.symbol).font(.title)
            Text(allergy.name)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle").foregroundColor(.green)
            }
        }
        .contentShape(Rectangle()) // Ensures the entire row is tappable
        .onTapGesture {
            if isSelected {
                selectedAllergies.remove(allergy.name)
            } else {
                selectedAllergies.insert(allergy.name)
            }
        }
    }
}

class FirestoreManager: ObservableObject {
    @Published var allergies: [Allergy] = []
    static var userSavedAllergies: [String] = []

    private var db = Firestore.firestore()

    func fetchAllergies() {
        db.collection("allergy").getDocuments { snapshot, error in
            guard error == nil, let documents = snapshot?.documents else { return }
            self.allergies = documents.compactMap { try? $0.data(as: Allergy.self) }
        }
    }

    func saveUserAllergies(userID: String, allergies: [String]) {
        let userRef = db.collection("users").document(userID)
        userRef.setData(["allergies": allergies], merge: true)
    }

    func fetchUserAllergies(userID: String, completion: @escaping ([String]) -> Void) {
        db.collection("users").document(userID).getDocument { document, _ in
            if let allergies = document?.get("allergies") as? [String] {
                FirestoreManager.userSavedAllergies = allergies
                completion(allergies)
            } else {
                completion([])
            }
        }
    }
}
