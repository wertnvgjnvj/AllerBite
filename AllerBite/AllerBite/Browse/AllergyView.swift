import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth



// Model for Allergy
struct Allergy: Identifiable, Hashable, Codable {
    @DocumentID var id: String? // Document ID from Firestore
    var symbol: String
    var name: String
}

// View for managing allergies
struct AllergyView: View {
    @StateObject private var firestoreManager = FirestoreManager() // Firestore manager for allergy handling
    @StateObject private var userViewModel = UserViewModel()       // Instance of UserViewModel to get user data

    @State private var searchText = ""
    @State private var navigateToContentView = false
    @State private var selectedAllergies: Set<String> = [] // Stores selected allergies

    var body: some View {
        NavigationView {
            VStack {
                if userViewModel.isLoading {
                    ProgressView("Loading user data...") // Show loading while fetching user data
                } else {
                    List {
                        ForEach(filteredAllergies, id: \.id) { allergy in
                            AllergyRow(
                                allergy: allergy,
                                isSelected: selectedAllergies.contains(allergy.name),
                                selectedAllergies: $selectedAllergies
                            )
                            .padding()
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
                            if let userID = userViewModel.user?.id {
                                firestoreManager.saveUserAllergies(userID: userID, allergies: Array(selectedAllergies))
                                print("Saved allergies: \(selectedAllergies) for user ID: \(userID)")
                            } else {
                                print("Error: User ID not available.")
                            }
                            navigateToContentView = true
                        }
                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                        .disabled(userViewModel.user == nil) // Disable button until user data is loaded
                    }
                }
            }
        }
        .onAppear {
            firestoreManager.fetchAllergies()
            userViewModel.fetchUser()  // Fetch user data
            
            // Load saved allergies for the current user
            if let userID = userViewModel.user?.id {
                firestoreManager.fetchUserAllergies(userID: userID)
            }
        }
        .onChange(of: firestoreManager.userSavedAllergies) { savedAllergies in
            self.selectedAllergies = Set(savedAllergies) // Update selected allergies with saved allergies
        }
    }

    // Filter allergies based on search text
    var filteredAllergies: [Allergy] {
        searchText.isEmpty ? firestoreManager.allergies : firestoreManager.allergies.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}

// AllergyRow view for individual allergy items
struct AllergyRow: View {
    let allergy: Allergy
    let isSelected: Bool
    @Binding var selectedAllergies: Set<String> // Use binding to update selectedAllergies

    var body: some View {
        HStack {
            Text(allergy.symbol)
                .font(.title)
            Text(allergy.name)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
            }
        }
        .padding(.vertical, -5)
        .contentShape(Rectangle()) // Make the entire row tappable
        .onTapGesture {
            if isSelected {
                selectedAllergies.remove(allergy.name)
            } else {
                selectedAllergies.insert(allergy.name)
            }
        }
    }
}

// FirestoreManager for managing Firestore operations
class FirestoreManager: ObservableObject {
    @Published var allergies: [Allergy] = []
    @Published var userSavedAllergies: [String] = [] // New variable to store user's saved allergies

    private var db = Firestore.firestore()

    func fetchAllergies() {
        db.collection("allergy").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching allergies: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No allergy documents found")
                return
            }

            self.allergies = documents.compactMap { document -> Allergy? in
                let allergy = try? document.data(as: Allergy.self)
                print("Fetched allergy:", allergy) // Debugging line
                return allergy
            }
            print("All allergies fetched:", self.allergies)
        }
    }
    
    func saveUserAllergies(userID: String, allergies: [String]) {
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user document: \(error)")
                return
            }

            if let document = document, document.exists {
                // Update the existing document with allergies
                userRef.updateData(["allergies": allergies]) { error in
                    if let error = error {
                        print("Error updating allergies: \(error)")
                    } else {
                        print("Allergies successfully updated!")
                    }
                }
            } else {
                // Document doesn't exist, create it with initial data
                let newUser = User(id: userID, username: "defaultUsername", age: 0, email: "default@example.com", allergies: allergies)
                do {
                    try userRef.setData(from: newUser)
                    print("User and allergies successfully created!")
                } catch let error {
                    print("Error creating user: \(error)")
                }
            }
        }
    }

    // Updated function to fetch saved allergies and store them in userSavedAllergies
    func fetchUserAllergies(userID: String) {
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user allergies: \(error)")
                return
            }
            
            if let document = document, let data = document.data(),
               let allergies = data["allergies"] as? [String] {
                self.userSavedAllergies = allergies // Store fetched allergies in userSavedAllergies
            } else {
                print("User document does not exist or allergies not found.")
                self.userSavedAllergies = [] // Default to an empty list if no allergies are found
            }
        }
    }
}

struct AllergyView_Previews: PreviewProvider {
    static var previews: some View {
        AllergyView()
    }
}



//previous code
//import SwiftUI
//
//struct AllergyView: View {
//    private var listOfAllergies = allergyData
//    @State private var searchText = ""
//    @State private var navigateToContentView = false
//    @State private var navigateToMainView = false
//    @State private var selectedAllergies: Set<String> = []
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(allergies, id: \.self) { allergy in
//                    AllergyRow(allergy: allergy, isSelected: selectedAllergies.contains(allergy.name), selectedAllergies: $selectedAllergies)
//                        .padding()
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
//                            // Handle Done action
//                            navigateToContentView = true
//                        }
//                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                    }
//                }
//            }
//        }
//        .onAppear(perform: loadSavedAllergies)
//
//    }
//
//
//    private func loadSavedAllergies() {
//        if let savedAllergies = UserDefaults.standard.array(forKey: "savedAllergies") as? [String] {
//            print("Loaded saved allergies:", savedAllergies)
//            self.selectedAllergies = Set(savedAllergies)
//        }
//    }
//
//    // Filter allergies
//    var allergies: [Allergy] {
//        // Make allergies lowercased
//        let lcAllergies = listOfAllergies.map { Allergy(symbol: $0.symbol.lowercased(), name: $0.name.lowercased()) }
//
//        return searchText.isEmpty ? lcAllergies : lcAllergies.filter { $0.name.contains(searchText.lowercased()) }
//    }
//}
//
//struct Allergy: Identifiable, Hashable {
//    let id = UUID() // Use UUID for unique identifiers
//    var symbol: String
//    var name: String
//}
//
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
//            saveSelectedAllergies() // Call the saveSelectedAllergies function
//        }
//    }
//
//    private func saveSelectedAllergies() {
//        UserDefaults.standard.set(Array(selectedAllergies), forKey: "savedAllergies")
//    }
//}
//
//// Sample allergy data (replace with your actual data)
//let allergyData = [
//    Allergy(symbol: "🥜", name: "Peanut"),
//    Allergy(symbol: "🥚", name: "Egg"),
//    Allergy(symbol: "🥛", name: "Milk"),
//    Allergy(symbol: "🫘", name: "Kidney Beans"),
//    Allergy(symbol: "🐟", name: "Fish and Shelfish"),
//    Allergy(symbol: "🌴", name: "Palm Oil"),
//    Allergy(symbol: "🥑", name: "Avocado"),
//    Allergy(symbol: "🌾", name: "Wheat"),
//    Allergy(symbol: "🦀", name: "Crustaceans")
//]
//
//struct AllergyView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllergyView()
//    }
//}
//









//import SwiftUI
//
//struct AllergyView: View {
//    private var listOfAllergies = allergyData
//    @State private var searchText = ""
//    @State private var navigateToContentView = false
//    @State private var selectedAllergies: Set<String> = []
//
//    // Define columns for the grid
//    let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 13) {
//                    ForEach(allergies, id: \.self) { allergy in
//                        AllergyGridItem(allergy: allergy, isSelected: selectedAllergies.contains(allergy.name), selectedAllergies: $selectedAllergies)
//                            .frame(height: 180) // Increased the height for bigger boxes
//                    }
//                }
//                .padding(.horizontal)
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
//                            navigateToContentView = true
//                        }
//                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255)) // Custom green color
//                    }
//                }
//            }
//        }
//        .onAppear(perform: loadSavedAllergies)
//    }
//
//    private func loadSavedAllergies() {
//        if let savedAllergies = UserDefaults.standard.array(forKey: "savedAllergies") as? [String] {
//            self.selectedAllergies = Set(savedAllergies)
//        }
//    }
//
//    var allergies: [Allergy] {
//        let lcAllergies = listOfAllergies.map { Allergy(symbol: $0.symbol.lowercased(), name: $0.name.lowercased()) }
//        return searchText.isEmpty ? lcAllergies : lcAllergies.filter { $0.name.contains(searchText.lowercased()) }
//    }
//}
//
//struct Allergy: Identifiable, Hashable {
//    let id = UUID()
//    var symbol: String
//    var name: String
//}
//
//struct AllergyGridItem: View {
//    let allergy: Allergy
//    let isSelected: Bool
//    @Binding var selectedAllergies: Set<String>
//
//    var body: some View {
//        VStack {
//            ZStack {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(isSelected ? Color(red: 79/255, green: 143/255, blue: 0/255) : Color.white) // Custom green background color when selected, white when not
//                    .shadow(radius: 5)
//
//                VStack {
//                    Text(allergy.symbol)
//                        .font(.largeTitle)
//                    Text(allergy.name.capitalized)
//                        .font(.headline)
//                        .foregroundColor(isSelected ? Color.white : Color(red: 79/255, green: 143/255, blue: 0/255)) // Custom green text color when not selected, white when selected
//                }
//            }
//            .onTapGesture {
//                if isSelected {
//                    selectedAllergies.remove(allergy.name)
//                } else {
//                    selectedAllergies.insert(allergy.name)
//                }
//                saveSelectedAllergies()
//            }
//        }
//        .padding()
//    }
//
//    private func saveSelectedAllergies() {
//        UserDefaults.standard.set(Array(selectedAllergies), forKey: "savedAllergies")
//    }
//}
//
//// Sample allergy data
//let allergyData = [
//    Allergy(symbol: "🥜", name: "Peanut"),
//    Allergy(symbol: "🥚", name: "Egg"),
//    Allergy(symbol: "🥛", name: "Milk"),
//    Allergy(symbol: "🫘", name: "Kidney Beans"),
//    Allergy(symbol: "🐟", name: "Fish and Shelfish"),
//    Allergy(symbol: "🌴", name: "Palm Oil"),
//    Allergy(symbol: "🥑", name: "Avocado"),
//    Allergy(symbol: "🌾", name: "Wheat"),
//    Allergy(symbol: "🦀", name: "Crustaceans")
//]
//
//struct AllergyView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllergyView()
//    }
//}
//
