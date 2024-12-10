//
//  AIRecipeView.swift
//  AllerBite
//
//  Created by Aditya Gaba on 8/12/24.
//

//import SwiftUI
//
//struct AIRecipieView: View {
//    @State private var selectedCard: Int? = nil
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                // Enhanced Background Gradient
//                LinearGradient(
//                    gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.7)]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//                .edgesIgnoringSafeArea(.all)
//                
//                VStack {
//                    // Header Section
//                    Text("AI Recipe Generator")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(.black)
//                        .padding(.top, 0)
//                        
//                    
//                    
//                    // Allergy Free AI Recipe Generator Section
//                    Text("Allergy Free AI Recipe Generator")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.black)
//                        .padding(.top, 30)
//                    
//                    // Cards ScrollView
//                    ScrollView {
//                        VStack(spacing: 70) {
//                            // Meal Image to Recipe Card
//                            NavigationLink(destination: MealImageToRecipeView(), tag: 1, selection: $selectedCard) {
//                                Card1View(title: "🍕 Meal Image to Recipe",
//                                         subtitle: "Convert meal images to recipes",
//                                         gradientColors: [Color.blue, Color.purple],
//                                         cardImage: "photo.on.rectangle.angled")
//                            }
//                            
//                            // Ingredient Image to Meal Card
//                            NavigationLink(destination: IngredientImageToMealView(), tag: 2, selection: $selectedCard) {
//                                Card1View(title: "🥕 Ingredient Image to Meal",
//                                         subtitle: "Identify ingredients and suggest meals",
//                                         gradientColors: [Color.green, Color.yellow],
//                                         cardImage: "leaf")
//                            }
//                        }
//                        .padding()
//                    }
//                }
//                .padding()
//            }
//            .navigationTitle("AI Recipe Generator")
//            .navigationBarHidden(true)
//        }
////        .navigationBarBackButtonHidden()
//    }
//}
//
//struct Card1View: View {
//    let title: String
//    let subtitle: String
//    let gradientColors: [Color]
//    let cardImage: String
//    
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 25)
//                .fill(
//                    LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
//                )
//                .frame(height: 220) // Adjusted height for larger cards
//                .shadow(radius: 10)
//                .overlay(
//                    VStack {
//                        HStack {
//                            Image(systemName: cardImage)
//                                .font(.system(size: 60)) // Larger icon size
//                                .foregroundColor(.white)
//                                .padding(.leading, 20)
//                            Spacer()
//                        }
//                        Spacer()
//                        VStack(alignment: .leading) {
//                            Text(title)
//                                .font(.title2)
//                                .bold()
//                                .foregroundColor(.white)
//                            Text(subtitle)
//                                .font(.subheadline)
//                                .foregroundColor(.white.opacity(0.8))
//                        }
//                        .padding()
//                    }
//                )
//        }
//        .frame(maxWidth: .infinity) // Full width for the card
//    }
//}
//
//#Preview{
//    AIRecipieView()
//}


import SwiftUI

//struct AIRecipeView: View {
//    @State private var selectedCard: Int? = nil
//    
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading){
//                Text("Upload your meal image and generate a recipe.")
//                    .font(.footnote)
//                //                        .fontWeight(.semibold)
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
//                                    .padding(.top,-6)
//                
//                
//                VStack(spacing: 30) {
//                    
//                    // Cards Section (No ScrollView to make it unscrollable)
//                    VStack(spacing: 20) {
//                        NavigationLink(destination: AllergySelectionView(), tag: 1, selection: $selectedCard) {
//                            RecipeCardView(
//                                title: "Meal Image to Recipe",
//                                subtitle: "Convert meal images to recipes",
//                                cardImage: "",
//                                backgroundImage: "AI2"
//                            )
//                        }
//                        
//                        NavigationLink(destination: AllergyChooseView(), tag: 2, selection: $selectedCard) {
//                            RecipeCardView(
//                                title: "Ingredient Image to Meal",
//                                subtitle: "Identify ingredients and suggest meals",
//                                cardImage: "",
//                                backgroundImage: "AI1"
//                            )
//                        }
//                    }
//                    .padding()
//                    Spacer() // Ensures proper vertical spacing
//                }
//                .navigationTitle("AI Recipe Generator")
//                .navigationBarTitleDisplayMode(.large)
//                //            .toolbar {
//                //                ToolbarItem(placement: .principal) {
//                //                    VStack {
//                //                        Text("AI Recipe Generator")
//                //                            .font(.title) // Main navigation title
//                //                        Text("Allergy Free AI Recipe Generator")
//                //                            .font(.subheadline) // Subtitle
//                //                            .foregroundColor(.gray) // System gray color
//                //                    }
//                //                }
//                //            }
//            }
//        }.navigationBarBackButtonHidden(true)
//    }


import SwiftUI

struct AIRecipeView: View {
    @State private var selectedCard: Int? = nil
    @State private var navigateToHomeView = false // State for navigation to HomeView
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Upload your meal image and generate a recipe.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.top, -6)
                
                VStack(spacing: 30) {
                    // Cards Section
                    VStack(spacing: 20) {
                        NavigationLink(destination: AllergySelectionView(), tag: 1, selection: $selectedCard) {
                            RecipeCardView(
                                title: "Meal Image to Recipe",
                                subtitle: "Convert meal images to recipes",
                                cardImage: "",
                                backgroundImage: "AI2"
                            )
                        }
                        
                        NavigationLink(destination: AllergyChooseView(), tag: 2, selection: $selectedCard) {
                            RecipeCardView(
                                title: "Ingredient Image to Meal",
                                subtitle: "Identify ingredients and suggest meals",
                                cardImage: "",
                                backgroundImage: "AI1"
                            )
                        }
                    }
                    .padding()
                    Spacer() // Ensures proper vertical spacing
                }
                .navigationTitle("AI Recipe Generator")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    // Add Back Button in Toolbar
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(
                            destination: HomeView(), // Navigate to HomeView
                            isActive: $navigateToHomeView
                        ) {
                            Button(action: {
                                navigateToHomeView = true // Trigger navigation
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                                    Text("Home")
                                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }




    
    struct RecipeCardView: View {
        let title: String
        let subtitle: String
        let cardImage: String
        let backgroundImage: String  // Background image name
        
        var body: some View {
            ZStack {
                // Background image
                Image(backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                                    startPoint: .bottomLeading,
                                    endPoint: .topTrailing
                                )
                            )
                    )
                
                // Content overlay with opacity
                VStack(alignment: .leading) {
                    HStack {
                        if !cardImage.isEmpty {
                            Image(systemName: cardImage)
                                .font(.title2) // Adjust icon size
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    Spacer()
                    
                    // Text section with semi-transparent background
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.title2) // Smaller title font
                            .bold()
                            .foregroundColor(.white)
                        Text(subtitle)
                            .font(.caption) // Smaller subtitle font
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color.black.opacity(0.3)) // Semi-transparent background
                    .cornerRadius(10)
                }
                .padding()
            }
            .frame(height: 200)
            .cornerRadius(25)
            .shadow(radius: 10)
        }
    }
    
}
