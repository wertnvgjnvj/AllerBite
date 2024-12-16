
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
        .navigationBarBackButtonHidden(true)
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
    @Published var userPreferences: String? = nil
    
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
    func saveUserPreferences(userID: String, veg: String, completion: @escaping (Bool) -> Void) {
        print("Saving preferences for user \(userID): \(veg)")
            let userRef = db.collection("users").document(userID)
            userRef.setData(["veg": veg], merge: true) { error in
                if let error = error {
                    print("Error saving preferences: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Preferences saved successfully!")
                    completion(true)
                }
            }
        }

    func fetchUserPreferences(userID: String, completion: @escaping (String) -> Void) {
        print("Fetching preferences for user \(userID)")
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching preferences: \(error.localizedDescription)")
                completion("")
                return
            }
            let vegPreference = document?.get("veg") as? String ?? ""
            DispatchQueue.main.async {
                self.userPreferences = vegPreference
            }
            completion(vegPreference)
        }
    }
}
