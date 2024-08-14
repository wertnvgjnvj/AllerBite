//import SwiftUI
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
//    @State private var userName: String = ""
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
//                TextField("Email", text: $email)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(.bottom, 20)
//                SecureField("Password", text: $password)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(.bottom, 20)
//                SecureField("Confirm Password", text: $confirmPassword)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(10)
//                    .padding(.bottom, 20)
//
//                NavigationLink(destination: ScreenView(userName: userName), isActive: $navigateToScreenView) {
//                    Button(action: registerUser) {
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
//                NavigationLink(destination: LoginView()) {
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
//        }
//        .navigationBarBackButtonHidden()
//    }
//
//    private func registerUser() {
//        if password != confirmPassword {
//            alertMessage = "Passwords don't match!"
//            showAlert = true
//        } else {
//            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//                if let error = error {
//                    alertMessage = error.localizedDescription
//                    showAlert = true
//                } else {
//                    navigateToScreenView = true
//                }
//            }
//        }
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
//
//#Preview {
//    RegisterView()
//}
import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(
                    destination: ScreenView(),
                    isActive: $viewModel.didAuthenticateUser,
                    label: { EmptyView() }
                )
                
                AuthHeaderView(title1: "Get started", title2: "Create your account")
                
                VStack(spacing: 40) {
                    CustomInputField(imageName: "envelope", placeholderText: "Email", text: $email)
                    CustomInputField(imageName: "person", placeholderText: "Username", text: $username)
                    CustomInputField(imageName: "person", placeholderText: "Full name", text: $fullname)
                    CustomInputField(imageName: "lock", placeholderText: "Password", isSecureField: true, text: $password)
                }
                .padding(32)
                
                Button {
                    viewModel.register(withEmail: email, password: password, fullname: fullname, username: username)
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                        .padding()
                }
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
                
                Spacer()
                
                Button {
                    viewModel.didAuthenticateUser = false
                } label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.footnote)
                        
                        Text("Sign In")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 32)
            }
            .ignoresSafeArea()
        }
    }
}
