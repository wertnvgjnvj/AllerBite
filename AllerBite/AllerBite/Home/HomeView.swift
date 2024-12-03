//import SwiftUI
//
//struct HomeView: View {
//    @State private var selectedCard: Int? = nil
//    @State private var showProfile = false
//    var userName: String
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
//                VStack(spacing: 0) {
//                    // Header Section
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Hi User! 👋🏻")
//                                .font(.system(size: 28, weight: .bold))
//                                .foregroundColor(.black)
//                                .offset(y:10)
//                            
//                     
//                        }
//                        Spacer()
//                        Button(action: {
//                            showProfile = true  // Set to true to show the ProfileView
//                        }) {
//                            Image("profile")  // Ensure you have an image named "profile" in your assets
//                                .resizable()
//                                .frame(width: 45, height: 43)
//                        }
//                        .sheet(isPresented: $showProfile) {  // Sheet presentation
//                            ProfileView()  // The view to show in the sheet
//                        }
//                        .offset(y:10)
//                    }
//                    
//                    .padding()
//                   // .background(Color.white.opacity(0.8)) // Background for the header
//                 //   .shadow(radius: 5)
//                    
//                    ScrollView {
//                        VStack(spacing: 30) {
//                            // Allergy Card
//                            NavigationLink(destination: AllergyView1(), tag: 1, selection: $selectedCard) {
//                                CardView(title: "Choose Your Allergy",
//                                         subtitle: "Manage Allergies",
//                                         gradientColors: [Color.pink, Color.red],
//                                         cardImage: "allergyIcon")
//                                .overlay(
//                                    SparkleEffect()
//                                        .frame(width: 240, height: 200)
//                                )
//                            }
//                            
//                            // Veg and Non-Veg Card
//                            NavigationLink(destination: VegPreferenceView(), tag: 2, selection: $selectedCard) {
//                                CardView(title: "Veg and Non-Veg",
//                                         subtitle: "Choose your preference",
//                                         gradientColors: [Color.green, Color.yellow],
//                                         cardImage: "vegIcon")
//                                .overlay(
//                                    SparkleEffect()
//                                        .frame(width: 240, height: 200)
//                                )
//                            }
//                            
//                            // AI Recipe Generator Card
//                            NavigationLink(destination: AIRecipieView(), tag: 3, selection: $selectedCard) {
//                                CardView(title: "AI Recipe Generator",
//                                         subtitle: "Get Custom Recipes",
//                                         gradientColors: [Color.blue, Color.purple],
//                                         cardImage: "recipeIcon")
//                                .overlay(
//                                    SparkleEffect()
//                                        .frame(width: 240, height: 200)
//                                )
//                            }
//                            
//                            // Trending Articles Section
//                            Text("Trending Articles")
//                                .font(.system(size: 25))
//                                .foregroundColor(.gray)
//                                .padding(.top, 18)
//                            
//                            ArticleRow() // Add your ArticleRow view
//                        }
//                        .padding()
//                    }
//                }
//            }
//            .navigationBarHidden(true)
//        }
//    }
//}
//// SparkleEffect Component
//struct SparkleEffect: View {
//    @State private var animate = false
//    
//    var body: some View {
//        ZStack {
//            Circle()
//                .stroke(
//                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.9), Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing),
//                    lineWidth: 6
//                )
//                .scaleEffect(animate ? 1.5 : 1)
//                .opacity(animate ? 0.8 : 1)
//                .blur(radius: animate ? 8 : 0)
//            
//            Circle()
//                .stroke(
//                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.6), Color.clear]), startPoint: .bottomTrailing, endPoint: .topLeading),
//                    lineWidth: 4
//                )
//                .scaleEffect(animate ? 1.2 : 0.8)
//                .opacity(animate ? 0.6 : 0.8)
//                .blur(radius: animate ? 6 : 2)
//        }
//        .rotationEffect(.degrees(animate ? 45 : 0))
//        .onAppear {
//            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
////               animate.toggle()
//            }
//        }
//    }
//}
//
//// CardView Component
//struct CardView: View {
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
//                .frame(height: 200)
//                .shadow(radius: 10)
//                .overlay(
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Image(systemName: cardImage)
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                            Spacer()
//                        }
//                        Spacer()
//                        Text(title)
//                            .font(.title)
//                            .bold()
//                            .foregroundColor(.white)
//                        Text(subtitle)
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.7))
//                    }
//                    .padding()
//                )
//        }
//    }
//}
//
//// ArticleRow Component
//struct ArticleRow: View {
//    var body: some View {
//        VStack {
//            Image("article")
//                .resizable()
//                .frame(width: 150, height: 110)
//                .offset(x:-100 , y:10)
//            
//            Text("12 April 2023")
//                .font(.system(size: 14))
//                .foregroundColor(.gray)
//                .offset(x:30 , y:-90)
//            
//            Text("Food authority: Restaurants,\nobey food info rules ")
//                .font(.system(size: 15))
//                .foregroundColor(.black)
//                .offset(x:85 , y:-80)
//            
//            Text("By India Times")
//                .font(.system(size: 15))
//                .foregroundColor(.gray)
//                .offset(x:40 , y:-70)
//            
//            Button(action: {
//                // Action for Browse button
//            }) {
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.green)
//                    .font(.system(size: 14))
//                    .offset(x: 112, y: -85)
//            }
//            
//        }
//        .padding(.vertical, 10)
//    }
//}
//
//
//
//
////// Preview
////#Preview {
////    HomeView(userName: userName)
////}
//
import SwiftUI

//struct HomeView: View {
//    @EnvironmentObject var userViewModel: UserViewModel
//    @State private var selectedCard: Int? = nil
//    @State private var showProfile = false
//    var userName: String
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
//                VStack(spacing: 0) {
//                    // Header Section
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Hi \(userViewModel.userName)! 👋🏻")
//                                .font(.system(size: 28, weight: .bold))
//                                .foregroundColor(.black)
//                                .offset(y: 10)
//                        }
//                        Spacer()
//                        Button(action: {
//                            showProfile = true  // Set to true to show the ProfileView
//                        }) {
//                            Image("profile")  // Ensure you have an image named "profile" in your assets
//                                .resizable()
//                                .frame(width: 45, height: 43)
//                        }
//                        .sheet(isPresented: $showProfile) {  // Sheet presentation
//                            ProfileView()  // The view to show in the sheet
//                        }
//                        .offset(y: 10)
//                    }
//                    .padding()
//                    
//                    ScrollView {
//                        VStack(spacing: 30) {
//                            // Allergy Card with background image
//                            NavigationLink(destination: AllergyView1(), tag: 1, selection: $selectedCard) {
//                                CardView(title: "Choose Your Allergy",
//                                         subtitle: "Manage Allergies",
//                                         cardImage: "allergyIcon",
//                                         backgroundImage: "bg1")
//                            }
//                            
//                            // Veg and Non-Veg Card with background image
//                            NavigationLink(destination: VegPreferenceView(), tag: 2, selection: $selectedCard) {
//                                CardView(title: "Veg and Non-Veg",
//                                         subtitle: "Choose your preference",
//                                         cardImage: "vegIcon",
//                                         backgroundImage: "bg2")
//                            }
//                            
//                            // AI Recipe Generator Card with background image
//                            NavigationLink(destination: AIRecipieView(), tag: 3, selection: $selectedCard) {
//                                CardView(title: "AI Recipe Generator",
//                                         subtitle: "Get Custom Recipes",
//                                         cardImage: "recipeIcon",
//                                         backgroundImage: "bg3")
//                            }
//                            
//                            // Trending Articles Section
//                            Text("Trending Articles")
//                                .font(.system(size: 25))
//                                .foregroundColor(.gray)
//                                .padding(.top, 18)
//                            
//                            ArticleRow() // Add your ArticleRow view
//                        }
//                        .padding()
//                    }
//                }
//            }
//            .navigationBarHidden(true)
//        }
//    }
//}
struct HomeView: View {
//    @StateObject var userViewModel: UserViewModel
    @ObservedObject var userViewModel = UserViewModel()
    @State private var selectedCard: Int? = nil
    @State private var showProfile = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Enhanced Background Gradient
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        // Header Section
                        HStack {
                            VStack(alignment: .leading) {
                                if let user = userViewModel.user {
                                    Text("Hi \(user.username)! 👋🏻") // Access `user.username` directly
                                        .font(.system(size: geometry.size.width * 0.08))  // Dynamic font size
                                        .foregroundColor(.black)
                                        .offset(y: 10)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)  // Scale down if text is too long
                                        .bold()
                                } else {
                                    Text("Hi there! 👋🏻") // Fallback text if `user` is nil
                                        .font(.system(size: geometry.size.width * 0.08))
                                        .foregroundColor(.black)
                                        .offset(y: 10)
                                        .bold()
                                }
                            }

                            Spacer()
                            Button(action: {
                                showProfile = true
                            }) {
                                Image("profile")  // Ensure "profile" image is in assets
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
                            }
                            .sheet(isPresented: $showProfile) {
                                ProfileView()  // Sheet presentation for ProfileView
                            }
                            .offset(y: 10)
                        }
                        .padding()
                        
                        ScrollView {
                            VStack(spacing: 30) {
//                                 Allergy Card with background image
                                NavigationLink(destination: AllergyView(), tag: 1, selection: $selectedCard) {
                                    CardView(title: "Choose Your Allergy",
                                             subtitle: "Manage Allergies",
                                             cardImage: "allergyIcon",
                                             backgroundImage: "bg1")
                                }
                                
                                // Veg and Non-Veg Card with background image
                                NavigationLink(destination: VegPreferenceView(), tag: 2, selection: $selectedCard) {
                                    CardView(title: "Veg and Non-Veg",
                                             subtitle: "Choose your preference",
                                             cardImage: "vegIcon",
                                             backgroundImage: "bg2")
                                }
                                
                                // AI Recipe Generator Card with background image
                                NavigationLink(destination: AIRecipieView(), tag: 3, selection: $selectedCard) {
                                    CardView(title: "AI Recipe Generator",
                                             subtitle: "Get Custom Recipes",
                                             cardImage: "recipeIcon",
                                             backgroundImage: "bg3")
                                }
                                
                                // Trending Articles Section
                                Text("Trending Articles")
                                    .font(.system(size: 25))
                                    .foregroundColor(.gray)
                                    .padding(.top, 18)
                                
                                ArticleRow()  // Add your ArticleRow view
                            }
                            .padding()
                        }
                    }
                }
                .navigationBarHidden(true)
                .onAppear {
                    DispatchQueue.main.async {
                        userViewModel.fetchUser()
                    }
                    print("userViewModel.user is \(userViewModel.user)")
                }

            }
        }
    }
}


// CardView Component with background image and semi-transparent text background
struct CardView: View {
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
                    Image(systemName: cardImage)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
                
                // Text section with semi-transparent background
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.subheadline)
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

// ArticleRow Component remains the same
struct ArticleRow: View {
    var body: some View {
        VStack {
            Image("article")
                .resizable()
                .frame(width: 150, height: 110)
                .offset(x: -100, y: 10)
            
            Text("12 April 2023")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .offset(x: 30, y: -90)
            
            Text("Food authority: Restaurants,\nobey food info rules ")
                .font(.system(size: 15))
                .foregroundColor(.black)
                .offset(x: 85, y: -80)
            
            Text("By India Times")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .offset(x: 40, y: -70)
            
            Button(action: {
                // Action for Browse button
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.green)
                    .font(.system(size: 14))
                    .offset(x: 112, y: -85)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    HomeView()
}
