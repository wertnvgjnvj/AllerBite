////
////  VegPreferenceView.swift
////  AllerBite
////
////  Created by Aditya Gaba on 8/12/24.
////
//
//import SwiftUI
//
//struct VegPreferenceView: View {
//    @StateObject private var firestoreManager = FirestoreManager()
//    @StateObject private var userViewModel = UserViewModel()
//    @State private var isVegetarian: Bool = false
//    @State private var isNonVegetarian: Bool = false
//
//    var body: some View {
//        VStack {
//            Text("🥦 Dietary Preferences")
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(.top, 20)
//
//            Text("Select your dietary preference")
//                .font(.headline)
//                .foregroundColor(.gray)
//                .padding(.bottom, 20)
//
//            Toggle(isOn: $isVegetarian) {
//                Text("Vegetarian")
//                    .font(.title2)
//            }
//            .padding()
//
//            Toggle(isOn: $isNonVegetarian) {
//                Text("Non-Vegetarian")
//                    .font(.title2)
//            }
//            .padding()
//
//            Spacer()
//
//            Button(action: savePreferences) {
//                Text("Save Preferences")
//                    .frame(maxWidth: .infinity)
//                    .bold()
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Color.green)
//                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
//            }
//            .padding(.horizontal)
//            .offset(y:-20)
//        }
//        .padding(.horizontal)
//    }
//
//    func savePreferences() {
//        // Save preferences logic here
//        guard let userID = userViewModel.user?.id else { return }
//        firestoreManager.saveUserAllergies(userID: userID, veg:)
//
//        // Fetch updated allergies after saving
//        firestoreManager.fetchUserAllergies(userID: userID) { updatedAllergies in
//            DispatchQueue.main.async {
//                self.selectedAllergies = Set(updatedAllergies)
//                isLoading = false
//                navigateToContentView = true
//            }
//        }
//        print("Vegetarian: \(isVegetarian), Non-Vegetarian: \(isNonVegetarian)")
//    }
//}
//
//struct VegPreferenceView_Previews: PreviewProvider {
//    static var previews: some View {
//        VegPreferenceView()
//    }
//}





///your code this -
//import SwiftUI
//
//struct VegPreferenceView: View {
//    @StateObject private var firestoreManager = FirestoreManager()
//    @StateObject private var userViewModel = UserViewModel()
//    @State private var isVegetarian: Bool = false
//    @State private var isNonVegetarian: Bool = false
//    @State private var isLoading: Bool = false
//    @State private var navigateToContentView: Bool = false
//
//    var body: some View {
//        VStack {
//            Text("🥦 Dietary Preferences")
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(.top, 20)
//
//            Text("Select your dietary preference")
//                .font(.headline)
//                .foregroundColor(.gray)
//                .padding(.bottom, 20)
//
//            Toggle(isOn: $isVegetarian) {
//                Text("Vegetarian")
//                    .font(.title2)
//            }
//            .onChange(of: isVegetarian) { newValue in
//                if newValue { isNonVegetarian = false }
//            }
//            .padding()
//
//            Toggle(isOn: $isNonVegetarian) {
//                Text("Non-Vegetarian")
//                    .font(.title2)
//            }
//            .onChange(of: isNonVegetarian) { newValue in
//                if newValue { isVegetarian = false }
//            }
//            .padding()
//
//            Spacer()
//
//            if isLoading {
//                ProgressView()
//                    .padding()
//            } else {
//                Button(action: savePreferences) {
//                    Text("Save Preferences")
//                        .frame(maxWidth: .infinity)
//                        .bold()
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.green)
//                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                }
//                .padding(.horizontal)
//                .offset(y: -20)
//            }
//        }
//        .padding(.horizontal)
//        .navigationTitle("Diet Preferences")
//        .navigationBarTitleDisplayMode(.inline)
//        .background(
//            NavigationLink(destination: HomeView(), isActive: $navigateToContentView) {
//                EmptyView()
//            }
//            .hidden()
//        )
//        .onAppear {
//            loadUserPreferences()
//        }
//    }
//
//    func savePreferences() {
//        guard let userID = userViewModel.user?.id else { return }
//        isLoading = true
//
//        // Determine veg preference
//        let vegPreference: String
//        if isVegetarian {
//            vegPreference = "Vegetarian"
//        } else if isNonVegetarian {
//            vegPreference = "Non-Vegetarian"
//        } else {
//            vegPreference = ""
//        }
//
//        firestoreManager.saveUserPreferences(userID: userID, veg: vegPreference) { success in
//            DispatchQueue.main.async {
//                isLoading = false
//                if success {
//                    print("Preferences saved successfully!")
//                    navigateToContentView = true
//                } else {
//                    print("Failed to save preferences.")
//                }
//            }
//        }
//    }
//
//    func loadUserPreferences() {
//        guard let userID = userViewModel.user?.id else { return }
//        isLoading = true
//
//        firestoreManager.fetchUserPreferences(userID: userID) { vegPreference in
//            DispatchQueue.main.async {
//                isLoading = false
//                if vegPreference.isEmpty{
//                    print("No Preferences found")
//                } else{
//                    switch vegPreference {
//                    case "Vegetarian":
//                        isVegetarian = true
//                        isNonVegetarian = false
//                    case "Non-Vegetarian":
//                        isVegetarian = false
//                        isNonVegetarian = true
//                    default:
//                        isVegetarian = false
//                        isNonVegetarian = false
//                    }
//                }
//            }
//        }
//    }
//}
//


import SwiftUI

struct VegPreferenceView: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @StateObject private var userViewModel = UserViewModel()
    @State private var isVegetarian: Bool = false
    @State private var isNonVegetarian: Bool = false
    @State private var isLoading: Bool = false
    @State private var navigateToContentView: Bool = false

    var body: some View {
        VStack {
            Text("🥦 Dietary Preferences")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)

            Text("Select your dietary preference")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            Toggle(isOn: $isVegetarian) {
                Text("Vegetarian")
                    .font(.title2)
            }
            .onChange(of: isVegetarian) { newValue in
                if newValue { isNonVegetarian = false }
            }
            .padding()

            Toggle(isOn: $isNonVegetarian) {
                Text("Non-Vegetarian")
                    .font(.title2)
            }
            .onChange(of: isNonVegetarian) { newValue in
                if newValue { isVegetarian = false }
            }
            .padding()

            Spacer()

            if isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: savePreferences) {
                    Text("Save Preferences")
                        .frame(maxWidth: .infinity)
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                }
                .padding(.horizontal)
                .offset(y: -20)
            }
        }
        .padding(.horizontal)
        .navigationTitle("Diet Preferences")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let _ = userViewModel.user {
                loadUserPreferences()
            }
        }
        .onChange(of: userViewModel.user) { newUser in
            if let _ = newUser {
                loadUserPreferences()
            }
        }
    }

    func savePreferences() {
        guard let userID = userViewModel.user?.id else { return }
        isLoading = true

        let vegPreference: String
        if isVegetarian {
            vegPreference = "Vegetarian"
        } else if isNonVegetarian {
            vegPreference = "Non-Vegetarian"
        } else {
            vegPreference = ""
        }

        firestoreManager.saveUserPreferences(userID: userID, veg: vegPreference) { success in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    print("Preferences saved successfully!")
                    navigateToContentView = true
                } else {
                    print("Failed to save preferences.")
                }
            }
        }
    }

    func loadUserPreferences() {
        print("Loading user preferences...")
        guard let userID = userViewModel.user?.id else {
            print("User not available for preferences loading.")
            return
        }
        isLoading = true

        firestoreManager.fetchUserPreferences(userID: userID) { vegPreference in
            DispatchQueue.main.async {
                print("Preferences fetched: \(vegPreference)")
                isLoading = false
                switch vegPreference {
                case "Vegetarian":
                    isVegetarian = true
                    isNonVegetarian = false
                case "Non-Vegetarian":
                    isVegetarian = false
                    isNonVegetarian = true
                default:
                    isVegetarian = false
                    isNonVegetarian = false
                }
                print("isVegetarian: \(isVegetarian), isNonVegetarian: \(isNonVegetarian)")
            }
        }
    }
}

