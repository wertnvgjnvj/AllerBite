//import SwiftUI
//import Firebase
//import FirebaseAuth
//
//struct ProfileView: View {
//    @State private var showSignOutAlert = false
//
//    var body: some View {
//        List {
//            // Icon at the top of the list
//            HStack {
//                Spacer()
//                Image("profile")
//                Spacer()
//            }
//            .listRowBackground(Color.clear)
//
//            // Health Details Section
//            Section() {
//                NavigationLink(destination: HealthView()) {
//                    Text("Health Details")
//                }
//
//                NavigationLink(destination: HealthView()) {
//                    Text("Medical ID")
//                }
//            }
//
//            // Features Section
//            Section(header: Text("Features")
//                .foregroundColor(.black)
//                .font(.system(size: 20).bold())
//                .textCase(.none)
//                .offset(x: -19)) {
//                NavigationLink(destination: HealthView()) {
//                    Text("Subscriptions")
//                }
//                NavigationLink(destination: HealthView()) {
//                    Text("Notifications")
//                }
//            }
//
//            // Privacy Section
//            Section(header: Text("Privacy")
//                .foregroundColor(.black)
//                .font(.system(size: 20).bold())
//                .textCase(.none)
//                .offset(x: -19)) {
//                NavigationLink(destination: HealthView()) {
//                    Text("Apps and Services")
//                }
//                NavigationLink(destination: HealthView()) {
//                    Text("Research Studies")
//                }
//                NavigationLink(destination: HealthView()) {
//                    Text("Devices")
//                }
//            }
//
//            // Sign Out Button
//            Button(action: {
//                showSignOutAlert = true
//            }) {
//                Text("Sign Out")
//                    .foregroundColor(.red)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//            }
//        }
//        .listStyle(InsetGroupedListStyle())
//        .alert(isPresented: $showSignOutAlert) {
//            Alert(title: Text("Sign Out"),
//                  message: Text("Are you sure you want to sign out?"),
//                  primaryButton: .destructive(Text("Sign Out")) {
//                    signOutUser()
//                  },
//                  secondaryButton: .cancel())
//        }
//    }
//
//    private func signOutUser() {
//        do {
//            try Auth.auth().signOut()
//            // Navigate back to LoginView (can be done through an environment variable or similar)
//            // For example, you can use a dedicated @Environment variable to pop to root or switch to LoginView.
//        } catch {
//            // Handle error
//            print("Error in sign out\(error)")
//        }
//    }
//}
//
//struct HealthView: View {
//    var body: some View {
//        Text("Health Details View")
//            .navigationBarTitle("Health Details")
//    }
//}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ProfileView()
//        }
//    }
//}

//import SwiftUI
//import FirebaseAuth
//
//struct ProfileView: View {
//    @StateObject private var viewModel = UserViewModel()
//    @State private var showSignOutAlert = false
//    @State private var showingCloseAccountView = false
//    @State private var isEditing = false
//    @State private var editedName: String = ""
//    @State private var editedEmail: String = ""
//
//    var body: some View {
//        List {
//            // Profile Image and Name Section
//            if let user = viewModel.user {
//                Section {
//                    HStack {
//                        Spacer()
//                        Image(systemName: "person.crop.circle")
//                            .resizable()
//                            .frame(width: 150, height: 150)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 2)))
//                        Spacer()
//                    }
//                    
//                    // Name Field
//                    HStack {
//                        Text("Name")
//                        Spacer()
//                        if isEditing {
//                            TextField("Name", text: $editedName)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                        } else {
//                            Text(viewModel.user?.username ?? "NA")
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    
//                    // Email Field
//                    HStack {
//                        Text("Email")
//                        Spacer()
//                        if isEditing {
//                            TextField("Email", text: $editedEmail)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                        } else {
//                            Text(viewModel.user?.email ?? "NA")
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    
//                    // Member Since
////                    HStack {
////                        Text("Member Since")
////                        Spacer()
////                        Text("\(user.joined.dateValue().formatted(date: .abbreviated, time: .shortened))")
////                            .foregroundColor(.secondary)
////                    }
//                }
//            } else {
//                Text("Loading...")
//            }
//
//            // Health Details Section
//            Section(header: Text("Health Details")) {
//                NavigationLink(destination: HealthView()) {
//                    Text("Health Details")
//                }
//                NavigationLink(destination: HealthView()) {
//                    Text("Medical ID")
//                }
//            }
//            
//            // Features Section
//            Section(header: Text("Features")
//                .foregroundColor(.black)
//                .font(.system(size: 20).bold())
//                .textCase(.none)
//                .offset(x: -19)) {
//                NavigationLink(destination: HealthView()) {
//                    Text("Subscriptions")
//                }
//                NavigationLink(destination: HealthView()) {
//                    Text("Notifications")
//                }
//            }
//            
//            // Privacy Section
//            Section(header: Text("Privacy")
//                .foregroundColor(.black)
//                .font(.system(size: 20).bold())
//                .textCase(.none)
//                .offset(x: -19)) {
//                NavigationLink(destination: HealthView()) {
//                    Text("Apps and Services")
//                }
//                NavigationLink(destination: HealthView()) {
//                    Text("Research Studies")
//                }
//                NavigationLink(destination: HealthView()) {
//                    Text("Devices")
//                }
//            }
//
//            // Sign Out and Close Account
//            Section {
//                Button("Close Account") {
//                    showingCloseAccountView = true
//                }
//                .foregroundColor(.red)
//                
//                Button("Sign Out") {
//                    showSignOutAlert = true
//                }
//                .foregroundColor(.red)
//            }
//        }
//        .listStyle(InsetGroupedListStyle())
//        .navigationTitle("Profile")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                if let user = viewModel.user {
//                    Button {
////                        if isEditing {
////                            // Save changes to Firebase
////                            viewModel.updateUserDetails(name: editedName, email: editedEmail) { success in
////                                if success {
////                                    print("User details updated successfully.")
////                                } else {
////                                    print("Failed to update user details.")
////                                }
////                            }
////                        } else {
////                            // Pre-fill the fields with current user data for editing
////                            editedName = user.name
////                            editedEmail = user.email
////                        }
////                        isEditing.toggle()
//                    } label: {
//                        Text(isEditing ? "Done" : "Edit")
//                    }
//                }
//            }
//        }
//        .alert(isPresented: $showSignOutAlert) {
//            Alert(title: Text("Sign Out"),
//                  message: Text("Are you sure you want to sign out?"),
//                  primaryButton: .destructive(Text("Sign Out")) {
//                    signOutUser()
//                  },
//                  secondaryButton: .cancel())
//        }
//        .onAppear {
//            viewModel.fetchUser()
//            // Set initial values for editing when user is fetched
////            if let user = viewModel.user {
////                editedName = user.name
////                editedEmail = user.email
////            }
//        }
//    }
//
//    private func signOutUser() {
//        do {
//            try Auth.auth().signOut()
//            // Implement navigation to the login view if needed
//        } catch {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//    }
//}
//
//struct HealthView: View {
//    var body: some View {
//        Text("Health Details View")
//            .navigationBarTitle("Health Details")
//    }
//}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ProfileView()
//        }
//    }
//}
//
//



//import SwiftUI
//import FirebaseAuth
//
//struct ProfileView: View {
//    @StateObject private var viewModel = UserViewModel()
//    @State private var showSignOutAlert = false
//    @State private var showingCloseAccountView = false
//    @State private var isEditing = false
//    @State private var editedName: String = ""
//    @State private var editedEmail: String = ""
//
//    var body: some View {
//        List {
//            // Profile Name Initials Section
//            if let user = viewModel.user {
//                Section {
//                    HStack {
//                        Spacer()
//                        ZStack {
//                            Circle()
//                                .fill(Color.blue)
//                                .frame(width: 150, height: 150)
//                            Text(getInitials(from: user.username))
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                                .bold()
//                        }
//                        Spacer()
//                    }
//                    .padding(.bottom, 20)
//                    
//                    // Name Field
//                    HStack {
//                        Text("Name")
//                        Spacer()
//                        if isEditing {
//                            TextField("Name", text: $editedName)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                        } else {
//                            Text(user.username)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                    
//                    // Email Field
//                    HStack {
//                        Text("Email")
//                        Spacer()
//                        if isEditing {
//                            TextField("Email", text: $editedEmail)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                        } else {
//                            Text(user.email)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                }
//            } else {
//                Text("Loading...")
//            }
//
//            // Sign Out and Close Account
//            Section {
//                Button("Close Account") {
//                    showingCloseAccountView = true
//                }
//                .foregroundColor(.red)
//                
//                Button("Sign Out") {
//                    showSignOutAlert = true
//                }
//                .foregroundColor(.red)
//            }
//        }
//        .listStyle(InsetGroupedListStyle())
//        .navigationTitle("Profile")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                if viewModel.user != nil {
//                    Button {
//                        if isEditing {
//                            // Save changes logic here if required
//                        } else {
//                            editedName = viewModel.user?.username ?? ""
//                            editedEmail = viewModel.user?.email ?? ""
//                        }
//                        isEditing.toggle()
//                    } label: {
//                        Text(isEditing ? "Done" : "Edit")
//                    }
//                }
//            }
//        }
//        .alert(isPresented: $showSignOutAlert) {
//            Alert(title: Text("Sign Out"),
//                  message: Text("Are you sure you want to sign out?"),
//                  primaryButton: .destructive(Text("Sign Out")) {
//                    signOutUser()
//                  },
//                  secondaryButton: .cancel())
//        }
//        .onAppear {
//            viewModel.fetchUser()
//        }
//    }
//
//    private func getInitials(from name: String) -> String {
//        let components = name.split(separator: " ")
//        let initials = components.prefix(2).map { $0.first.map(String.init) ?? "" }.joined()
//        return initials.uppercased()
//    }
//
//    private func signOutUser() {
//        do {
//            try Auth.auth().signOut()
//            // Implement navigation to the login view if needed
//        } catch {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//    }
//}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ProfileView()
//        }
//    }
//}



import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var showSignOutAlert = false
    @State private var showingCloseAccountView = false
    @State private var isEditing = false
    @State private var editedName: String = ""
    @State private var editedEmail: String = ""

    var body: some View {
        List {
            // Profile Name Initials Section
            if let user = viewModel.user {
                Section {
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 150, height: 150)
                            Text(getInitials(from: user.username))
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                                .bold()
                        }
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    // Name Field
                    HStack {
                        Text("Name")
                        Spacer()
                        if isEditing {
                            TextField("Name", text: $editedName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(user.username)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Email Field
                    HStack {
                        Text("Email")
                        Spacer()
                        if isEditing {
                            TextField("Email", text: $editedEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(user.email)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } else {
                Text("Loading...")
            }

            // Privacy Section
            Section(header: Text("Privacy")
                .foregroundColor(.black)
                .font(.system(size: 20).bold())
                .textCase(.none)
                .offset(x: -19)) {
                
                // Apps and Services
                Button(action: {
                    openURL("https://allerbite-website.vercel.app/#About")
                }) {
                    Text("About App")
                }

                // Research Studies
                Button(action: {
                    openURL("https://allerbite-website.vercel.app/#Team")
                }) {
                    Text("About Us")
                }

                // Devices
                Button(action: {
                    openURL("https://allerbite-website.vercel.app/privacy")
                }) {
                    Text("Privacy")
                }
            }


            // Sign Out and Close Account
            Section {
                Button("Close Account") {
                    showingCloseAccountView = true
                }
                .foregroundColor(.red)
                
                Button("Sign Out") {
                    showSignOutAlert = true
                }
                .foregroundColor(.red)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.user != nil {
                    Button {
                        if isEditing {
                            // Save changes logic here if required
                        } else {
                            editedName = viewModel.user?.username ?? ""
                            editedEmail = viewModel.user?.email ?? ""
                        }
                        isEditing.toggle()
                    } label: {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
        }
        .alert(isPresented: $showSignOutAlert) {
            Alert(title: Text("Sign Out"),
                  message: Text("Are you sure you want to sign out?"),
                  primaryButton: .destructive(Text("Sign Out")) {
                    signOutUser()
                  },
                  secondaryButton: .cancel())
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }

    private func getInitials(from name: String) -> String {
        let components = name.split(separator: " ")
        let initials = components.prefix(2).map { $0.first.map(String.init) ?? "" }.joined()
        return initials.uppercased()
    }
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Invalid URL: \(urlString)")
        }
    }


    private func signOutUser() {
        do {
            try Auth.auth().signOut()
            // Implement navigation to the login view if needed
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

struct HealthView: View {
    var body: some View {
        Text("Privacy View")
            .navigationBarTitle("Privacy")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
        }
    }
}
