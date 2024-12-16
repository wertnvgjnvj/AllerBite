


//import SwiftUI
//import FirebaseCore
//import Firebase
//import FirebaseAuth
//import GoogleSignIn
//import GoogleSignInSwift
//
//struct RegisterView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var confirmPassword: String = ""
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @State private var navigateToScreenView = false
//    @State private var navigateToLoginView = false
//    @State private var userName: String = ""
//    @StateObject var viewModel = UserViewModel()
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Register here")
//                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                    .font(.system(size: 34))
//                    .bold()
//                Text("Create an account making")
//                    .font(.title)
//                    .padding(.top)
//                Text("safer food choices!")
//                    .font(.title)
//                
//                TextField("Username", text: $userName)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(.bottom, 20)
//                
//                TextField("Email", text: $email)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(.bottom, 20)
//                    
//                
//                SecureField("Password", text: $password)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(.bottom, 20)
//                
//                SecureField("Confirm Password", text: $confirmPassword)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(.bottom, 20)
//
//                NavigationLink(destination: ScreenView(userName: userName), isActive: $navigateToScreenView) {
//                    Button(action: handleRegister) {
//                        Text("Register")
//                            .foregroundColor(.white)
//                            .padding(.vertical, 12)
//                            .padding(.horizontal, 75)
//                            .background(Color(red: 79/255, green: 143/255, blue: 0/255))
//                            .cornerRadius(10)
//                    }
//                }
//                .padding(.top, 30)
//                .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
//
//                NavigationLink(destination: LoginView(), isActive: $navigateToLoginView) {
//                    Text("Already have an account?")
//                        .font(.system(size: 15))
//                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        .padding(.top, 40)
//                }
//
//                // Social Sign-In buttons
//                HStack(spacing: 10) {
//                    SocialSignInButton(systemName: "g.circle", action: signInWithGoogle)
//                    SocialSignInButton(systemName: "apple.logo", action: {
//                        print("Apple Sign-In not yet implemented")
//                    })
//                }
//            }
//            .padding()
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
//            .onReceive(viewModel.$user) { user in
//                // Navigate to the next screen if registration is successful
//                if user != nil {
//                    navigateToScreenView = true
//                }
//            }
//            .onReceive(viewModel.$errorMessage) { errorMessage in
//                // Show alert if there's an error message
//                if !errorMessage.isEmpty {
//                    alertMessage = errorMessage
//                    showAlert = true
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//    }
//
//    // Function to handle the registration button action
//    private func handleRegister() {
//        guard password == confirmPassword else {
//            alertMessage = "Passwords do not match"
//            showAlert = true
//            return
//        }
//        
//        viewModel.registerUser(username: userName, age: 0, email: email, password: password)
//    }
//
//    private func signInWithGoogle() {
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
//struct SocialSignInButton: View {
//    let systemName: String
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Image(systemName: systemName)
//                .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                .padding()
//                .background(Color.gray.opacity(0.2))
//                .cornerRadius(100)
//        }
//    }
//}



import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct RegisterView: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var username = ""
    @State private var age = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToHome = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Register Here")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                    .padding(.bottom, 20)

                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
                    .keyboardType(.default)
                    .autocapitalization(.none)

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
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))

                Button(action: handleRegister) {
                    Text("Register")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(red: 79/255, green: 143/255, blue: 0/255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .frame(width: 280)

                NavigationLink(destination: HomeView(), isActive: $navigateToHome) {
                    EmptyView()
                }

                Button(action: signInWithGoogle) {
                    HStack {
                        Image("google") // Replace with the Google logo asset name
                            .resizable()
                            .frame(width: 24, height: 24)

                        Text("Sign in with Google")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .frame(width: 240)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.top, 5)

                Spacer()
                NavigationLink(destination: LoginView()) {
                    Text("Already have account? Sign in")
                        .font(.system(size: 15))
                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                        .padding(EdgeInsets(top: 40, leading: 0, bottom: 30, trailing: 0))
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }.navigationBarBackButtonHidden(true)
    }

    private func handleRegister() {
        guard !username.isEmpty else {
            alertMessage = "Username cannot be empty."
            showAlert = true
            return
        }

        guard !email.isEmpty, email.contains("@") else {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return
        }

       

        guard password.count >= 8 else {
            alertMessage = "Password must be at least 8 characters long."
            showAlert = true
            return
        }

        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }

        userViewModel.registerUser(username: username, email: email, password: password)
    }

    private func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { user, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
                return
            }

            guard let user = user?.user else {
                return
            }

            let idToken = user.idToken!.tokenString
            let accessToken = user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { res, error in
                if let error = error {
                    alertMessage = error.localizedDescription
                    showAlert = true
                    return
                }

                navigateToHome = true
            }
        }
    }

    func getRootViewController() -> UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}



