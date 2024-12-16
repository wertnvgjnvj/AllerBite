//
//  helloView.swift
//  AllerBite
//
//  Created by Sahil Aggarwal on 01/12/24.
//


import SwiftUI
import GoogleGenerativeAI
import Vision

struct helloView: View {
    @Binding var responseText: String
    @Binding var selectedAllergies: Set<String>
//    @Binding var tabSelection: Int
    @State private var navigateToAllergyView = false // State to trigger navigation

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Product Analysis")
                .font(.headline)

            Text("Response from Gemini:")
                .font(.subheadline)
                .padding(.top)

            ScrollView {
                Text(responseText)
                    .font(.body)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            }

            Text("Allergies:")
                .font(.subheadline)
                .padding(.top)

            if FirestoreManager.userSavedAllergies.isEmpty {
                Text("No allergies selected.")
                    .italic()
                    .foregroundColor(.gray)
            } else {
                Text(FirestoreManager.userSavedAllergies.joined(separator: " or "))
                    .font(.body)
            }

            Spacer()


            NavigationLink(
                destination: AllergyView(), // Replace with your AllergyView
                isActive: $navigateToAllergyView
            ) {
                EmptyView()
            }
        }
        .padding()
        .navigationTitle("Product Analysis")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    navigateToAllergyView = true // Trigger navigation
//                    tabSelection = 0
                    TabSelectionManager.shared.selectedTab = 0
                    
                    
                }
            }
        }
    }
}
