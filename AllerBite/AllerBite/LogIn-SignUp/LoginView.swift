//import SwiftUI
//import Firebase
//import FirebaseCore
//import FirebaseAuth
//import GoogleSignIn
//import GoogleSignInSwift
//
//struct LoginView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @State private var navigateToScreenView = false
//    @State private var userName: String = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Login here")
//                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                    .font(.system(size: 34))
//                    .bold()
//                
//                Text("Welcome back you’ve")
//                    .font(.title)
//                    .padding(.top)
//                
//                Text("been missed!")
//                    .font(.title)
//                
//                TextField("Email", text: $email)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
//                
//                SecureField("Password", text: $password)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                
//                Text("Forgot your password?")
//                    .font(.system(size: 15))
//                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                    .offset(x:100)
//                
//                NavigationLink(destination: ScreenView(userName: userName), isActive: $navigateToScreenView) {
//                    Button(action: {
//                        loginUser()
//                    }) {
//                        Text("Login")
//                            .foregroundColor(.white)
//                            .padding(EdgeInsets(top: 12, leading: 75, bottom: 12, trailing: 75))
//                            .background(Color(red: 79/255, green: 143/255, blue: 0/255))
//                            .cornerRadius(10)
//                    }
//                    .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
//                    .disabled(email.isEmpty || password.isEmpty)
//                }
//                
//                NavigationLink(destination: RegisterView()) {
//                    Text("Create new Account")
//                        .font(.system(size: 15))
//                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        .padding(EdgeInsets(top: 40, leading: 0, bottom: 30, trailing: 0))
//                }
//                
//                HStack(spacing: 10) {
//                    Button(action: {
//                        signInWithGoogle()
//                    }) {
//                        HStack {
//                            Image(systemName: "g.circle")
//                                .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        }
//                        .padding()
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(100)
//                    }
//                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 50))
//                    
//                    Button(action: {
//                        print("Apple Sign-In not yet implemented")
//                    }) {
//                        HStack {
//                            Image(systemName: "apple.logo")
//                                .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        }
//                        .padding()
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(100)
//                    }
//                    .disabled(true) // Disable button as functionality isn't ready
//                }
//            }
//            .padding()
////            .onAppear{
////                checkIfLoggedIn()
////            }
//        }
//        
//        .navigationBarBackButtonHidden(true)
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
//    }
//    
//    // Firebase login function
//    func loginUser() {
//        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                alertMessage = error.localizedDescription
//                showAlert = true
//            } else {
//                // Navigate to the main screen
//                if let user = authResult?.user {
//                    userName = user.displayName ?? "User"
//                }
//                navigateToScreenView = true
//            }
//        }
//    }
//
//    // Function to check if user is already logged in
//        func checkIfLoggedIn() {
//            if let user = Auth.auth().currentUser {
//                // User is already logged in, navigate to the main screen
//                userName = user.displayName ?? "User"
//                navigateToScreenView = true
//            }
//        }
//    
//    // Google Sign-In function
//    func signInWithGoogle() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { user, error in
//            if let error = error {
//                alertMessage = error.localizedDescription
//                showAlert = true
//                return
//            }
//            
//            guard let user = user?.user else {
//                return
//            }
//            
//            let idToken = user.idToken!.tokenString
//            let accessToken = user.accessToken.tokenString
//            
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//            
//            Auth.auth().signIn(with: credential) { res, error in
//                if let error = error {
//                    alertMessage = error.localizedDescription
//                    showAlert = true
//                    return
//                }
//                
//                guard let user = res?.user else { return }
//                userName = user.displayName ?? "User"
//                navigateToScreenView = true
//            }
//        }
//    }
//    
//    // Helper function to get the root view controller
//    func getRootViewController() -> UIViewController {
//        return UIApplication.shared.windows.first!.rootViewController!
//    }
//}
//
//#Preview {
//    LoginView()
//}
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoginSuccessful = false
    @State private var userName: String = ""
    @State private var isSignedOut = false // State variable to track sign-out

    var body: some View {
        NavigationView {
            VStack {
                Text("Login here")
                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                    .font(.system(size: 34))
                    .bold()

                Text("Welcome back you’ve")
                    .font(.title)
                    .padding(.top)

                Text("been missed!")
                    .font(.title)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                Text("Forgot your password?")
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                    .offset(x: 100)

                // Disable login button until email and password are filled
                Button(action: {
                    loginUser()
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 12, leading: 75, bottom: 12, trailing: 75))
                        .background(Color(red: 79/255, green: 143/255, blue: 0/255))
                        .cornerRadius(10)
                }
                .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
                .disabled(email.isEmpty || password.isEmpty)

                NavigationLink(destination: ScreenView(userName: userName), isActive: $isLoginSuccessful) {
                    EmptyView()
                }

                NavigationLink(destination: RegisterView()) {
                    Text("Create new Account")
                        .font(.system(size: 15))
                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                        .padding(EdgeInsets(top: 40, leading: 0, bottom: 30, trailing: 0))
                }

                HStack(spacing: 10) {
                    Button(action: {
                        signInWithGoogle()
                    }) {
                        HStack {
                            Image(systemName: "g.circle")
                                .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(100)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 50))

                    Button(action: {
                        print("Apple Sign-In not yet implemented")
                    }) {
                        HStack {
                            Image(systemName: "apple.logo")
                                .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(100)
                    }
                    .disabled(true) // Disable button as functionality isn't ready
                }

                // Sign Out Button
                Button(action: {
                    signOutUser() // Call sign-out function
                }) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Sign Out"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }

                // Navigation link for sign-out
                NavigationLink(destination: RegisterView(), isActive: $isSignedOut) {
                    EmptyView()
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    // Firebase login function with validation checks
    func loginUser() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email."
            showAlert = true
            return
        }

        guard !password.isEmpty else {
            alertMessage = "Please enter your password."
            showAlert = true
            return
        }

        // Firebase login attempt
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                if let user = authResult?.user {
                    userName = user.displayName ?? "User"
                }
                isLoginSuccessful = true // Only navigate on successful login
            }
        }
    }

    // Sign-out function
    func signOutUser() {
        do {
            try Auth.auth().signOut() // Sign out from Firebase
            isSignedOut = true // Trigger navigation to RegisterView
        } catch let signOutError as NSError {
            alertMessage = "Error signing out: \(signOutError.localizedDescription)"
            showAlert = true
        }
    }

    // Google Sign-In function
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                return
            }

            guard let user = result?.user else { return }

            let idToken = user.idToken!.tokenString
            let accessToken = user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    alertMessage = error.localizedDescription
                    showAlert = true
                    return
                }

                guard let user = authResult?.user else { return }
                userName = user.displayName ?? "User"
                isLoginSuccessful = true // Navigate on successful login
            }
        }
    }

    // Helper function to get the root view controller
    func getRootViewController() -> UIViewController {
        return UIApplication.shared.windows.first?.rootViewController ?? UIViewController()
    }
}

#Preview {
    LoginView()
}

//import SwiftUI
//
//struct LoginView: View {
//    @State private var email = ""
//    @State private var password = ""
//    @EnvironmentObject var viewModel : AuthViewModel
//    var body: some View {
//        VStack{
//          AuthHeaderView(title1: "Hello", title2: "Welcome back")
//            
//            VStack(spacing:40){
//                CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
//                CustomInputField(imageName: "lock", placeholderText: "Password",isSecureField: true, text: $password)
//                
//            }
//            .padding(.horizontal,32)
//            .padding(.top, 44)
//            
//            HStack{
//                Spacer()
//                
//                NavigationLink{
//                    Text("Reset password view..")
//                }label:{
//                    Text("Forgot Password?")
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        .padding(.top)
//                        .padding(.trailing,24)
//                }
//            }
//            Button{
//                viewModel.login(withEmail: email, password: password)
//            } label:{
//                Text("Sign In")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(width:340,height:50)
//                    .background(Color(red: 79/255, green: 143/255, blue: 0/255))
//                    .clipShape(Capsule())
//                    .padding()
//            }
//            .shadow(color: .gray.opacity(0.5), radius: 10, x:0, y:0)
//            
//            
//            Spacer()
//            
//            NavigationLink{
//               RegistrationView()
//                    .navigationBarHidden(true)
//            }
//        label:{
//            HStack{
//                Text("Don't have an account?")
//                    .font(.footnote)
//                
//                Text("Sign Up")
//                    .font(.footnote)
//                    .fontWeight(.semibold)
//            }
//        }
//        .padding(.bottom, 32)
//        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//        }
//        .ignoresSafeArea()
//        .navigationBarHidden(true)
//    }
//}
//
//#Preview {
//    LoginView()
//}
