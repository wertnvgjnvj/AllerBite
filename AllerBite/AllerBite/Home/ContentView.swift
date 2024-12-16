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
//
//#Preview{
//    ContentView()
//}
//import SwiftUI
//
//struct ContentView: View {
//    @State private var selection = 0
//    @State private var isSheetVisible = false
//    @State private var userName: String = ""
//    @EnvironmentObject var viewModel: AuthViewModel // Receive the view model
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                ScrollView {
//                    VStack {
//                        ArtWork() // Custom Artwork or main content
//                        Spacer(minLength: 100) // Provide space to push the TabView at the bottom
//                    }
//                }
//                
//                // Bottom Tab Bar with glass-morphism effect
//                VStack {
//                    Spacer() // Push the TabView down
//
//                    ZStack {
//                        // Blur and transparency for glass-morphism effect
////                        BlurView(style: .systemMaterial)
////                            .opacity(0.5)
//                        
//                        Rectangle()
//                            .fill(LinearGradient(
//                                gradient: Gradient(colors: [Color.white.opacity(0.3), Color.clear]),
//                                startPoint: .top, endPoint: .bottom
//                            ))
//                            .frame(height: 120) // Adjust height for the bar
//                    }
//                    .frame(height: 80)
//                    .offset(y: 40) // Adjust offset if needed for glass-morphism
//                    
//                    // TabView
//                    TabView(selection: $selection) {
//                        HomeView(userName: "Aditya Gaba")
//                            .tabItem {
//                                CustomTabItem(imageName: "house.fill", text: "Home")
//                            }
//                            .tag(0)
//                        
//                        BarcodeTextScannerView()
//                            .tabItem {
//                                CustomTabItem(imageName: "barcode.viewfinder", text: "Scanner")
//                            }
//                            .tag(1)
//                        
//                        HealthPlannerContentView()
//                            .tabItem {
//                                CustomTabItem(imageName: "square.grid.2x2.fill", text: "Browse")
//                            }
//                            .tag(2)
//                    }
//                    .accentColor(Color(red: 79/255, green: 143/255, blue: 0/255)) // Customize tab color
//                }
//            }
//            .navigationBarBackButtonHidden(true) // Hide the back button if it's a root view
//            .edgesIgnoringSafeArea([.bottom]) // Ensure that the TabView extends to the screen edges
//        }
//    }
//}
//
//// Preview setup
//#Preview {
//    ContentView()
//        .environmentObject(AuthViewModel()) // Add this for preview to work
//}
import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var selection = 0
    @State private var isSettingViewActive = false
    @State private var isMainViewActive = false
    @State var isActive: Bool = false
    @GestureState private var dragOffset: CGSize = .zero
//    @State private var selectedTab = 0
    @State private var isSheetVisible = false
    @State private var userName: String = ""
    @StateObject var tabManager = TabSelectionManager.shared
    
    
    @StateObject var viewModel = UserViewModel() // Access the shared AuthViewModel
    
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                NavigationView {
                    ZStack {
                        ScrollView {
                            VStack {
                                ArtWork() // Assuming you have an ArtWork view
                            }
                            Spacer() // Push the TabView to the bottom of the screen
                        }
                        
                        // Bottom View with Buttons
                        VStack {
                            // Bottom Bar with Glass Morphism Effect
                            ZStack {
                                // Background color with opacity
                                Color.clear // Use clear color to make it invisible
                                
                                // Blur effect
                                VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                                    .opacity(0.5) // Adjust opacity of the blur effect
                                
                                // Bottom bar content
                                Rectangle()
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.0)]), startPoint: .top, endPoint: .bottom))
                                    .frame(height: 120)
                            }
                            .frame(height: 80)
                            .offset(y: 40)
                        }
                        
                        TabView(selection: $tabManager.selectedTab) {
                            // Home Tab
                            HomeView()
                                .offset(y: 0)
                                .tabItem {
                                    CustomTabItem(imageName: "house.fill", text: "Home")
                                }
                                .tag(0)
                            
                            // Scanner Tab
                            BarcodeTextScannerView()
                                .tabItem {
                                    CustomTabItem(imageName: "barcode.viewfinder", text: "Scanner")
                                }
                                .tag(1)
                            
                            // Browse Tab
//                            AIRecipeView()
//                                .tabItem {
//                                    CustomTabItem(imageName: "fork.knife", text: "Recipe")
//                                }
//                                .tag(2)
                        }
                        .onChange(of: tabManager.selectedTab) { newValue in
                                    if newValue != 1 {
                                        tabManager.resetScanner() // Reset scanner when leaving the scanner tab
                                    }
                                }
                        .accentColor(Color(red: 79 / 255, green: 143 / 255, blue: 0 / 255))
                    }
                }
                //            .navigationBarBackButtonHidden(true)
            }
        }.navigationBarBackButtonHidden(true)
    }
}




class TabSelectionManager: ObservableObject {
    static let shared = TabSelectionManager()
    @Published var selectedTab: Int = 0
    @Published var resetScannerFlag: Bool = false
    func resetScanner() {
            resetScannerFlag = true
        }
}
