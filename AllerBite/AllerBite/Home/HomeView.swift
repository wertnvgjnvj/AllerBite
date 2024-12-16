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



//struct HomeView: View {
////    @StateObject var userViewModel: UserViewModel
//    @ObservedObject var userViewModel = UserViewModel()
//    @State private var selectedCard: Int? = nil
//    @State private var showProfile = false
//    
//    var body: some View {
//        NavigationView {
//            GeometryReader { geometry in
//                ZStack {
//                    // Enhanced Background Gradient
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.7)]),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                    .edgesIgnoringSafeArea(.all)
//                    
//                    VStack(spacing: 0) {
//                        // Header Section
//                        HStack {
//                            VStack(alignment: .leading) {
//                                if let user = userViewModel.user {
//                                    Text("Hi \(user.username)! 👋🏻") // Access `user.username` directly
//                                        .font(.system(size: geometry.size.width * 0.08))  // Dynamic font size
//                                        .foregroundColor(.black)
//                                        .offset(y: 10)
//                                        .lineLimit(1)
//                                        .minimumScaleFactor(0.5)  // Scale down if text is too long
//                                        .bold()
//                                } else {
//                                    Text("Hi there! 👋🏻") // Fallback text if `user` is nil
//                                        .font(.system(size: geometry.size.width * 0.08))
//                                        .foregroundColor(.black)
//                                        .offset(y: 10)
//                                        .bold()
//                                }
//                            }
//
//                            Spacer()
//                            Button(action: {
//                                showProfile = true
//                            }) {
//                                Image("profile")  // Ensure "profile" image is in assets
//                                    .resizable()
//                                    .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
//                            }
//                            .sheet(isPresented: $showProfile) {
//                                ProfileView()  // Sheet presentation for ProfileView
//                            }
//                            .offset(y: 10)
//                        }
//                        .padding()
//                        
//                        ScrollView {
//                            VStack(spacing: 30) {
////                                 Allergy Card with background image
//                                NavigationLink(destination: AllergyView(), tag: 1, selection: $selectedCard) {
//                                    CardView(title: "Choose Your Allergy",
//                                             subtitle: "Manage Allergies",
//                                             cardImage: "allergyIcon",
//                                             backgroundImage: "bg1")
//                                }
//                                
//                                // Veg and Non-Veg Card with background image
//                                NavigationLink(destination: VegPreferenceView(), tag: 2, selection: $selectedCard) {
//                                    CardView(title: "Veg and Non-Veg",
//                                             subtitle: "Choose your preference",
//                                             cardImage: "vegIcon",
//                                             backgroundImage: "bg2")
//                                }
//                                
//                                // AI Recipe Generator Card with background image
//                                NavigationLink(destination: AIRecipieView(), tag: 3, selection: $selectedCard) {
//                                    CardView(title: "AI Recipe Generator",
//                                             subtitle: "Get Custom Recipes",
//                                             cardImage: "recipeIcon",
//                                             backgroundImage: "bg3")
//                                }
//                                
//                                // Trending Articles Section
//                                Text("Trending Articles")
//                                    .font(.system(size: 25))
//                                    .foregroundColor(.gray)
//                                    .padding(.top, 18)
//                                
//                                // Add your ArticleRow view
//                            }
//                            .padding()
//                        }
//                    }
//                }
//                .navigationBarHidden(true)
//                .onAppear {
//                    DispatchQueue.main.async {
//                        userViewModel.fetchUser()
//                    }
//                    print("userViewModel.user is \(userViewModel.user)")
//                }
//
//            }
//        }
//    }
//}
//
//
//// CardView Component with background image and semi-transparent text background
//struct CardView: View {
//    let title: String
//    let subtitle: String
//    let cardImage: String
//    let backgroundImage: String  // Background image name
//    
//    var body: some View {
//        ZStack {
//            // Background image
//            Image(backgroundImage)
//                .resizable()
//                .scaledToFill()
//                .frame(height: 200)
//                .clipped()
//                .cornerRadius(25)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 25)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
//                                startPoint: .bottomLeading,
//                                endPoint: .topTrailing
//                            )
//                        )
//                )
//            
//            // Content overlay with opacity
//            VStack(alignment: .leading) {
//                HStack {
//                    Image(systemName: cardImage)
//                        .font(.largeTitle)
//                        .foregroundColor(.white)
//                    Spacer()
//                }
//                Spacer()
//                
//                // Text section with semi-transparent background
//                VStack(alignment: .leading) {
//                    Text(title)
//                        .font(.title)
//                        .bold()
//                        .foregroundColor(.white)
//                    Text(subtitle)
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.8))
//                }
//                .padding()
//                .background(Color.black.opacity(0.3)) // Semi-transparent background
//                .cornerRadius(10)
//            }
//            .padding()
//        }
//        .frame(height: 200)
//        .cornerRadius(25)
//        .shadow(radius: 10)
//    }
//}
//
//// ArticleRow Component remains the same
//
//
//
//#Preview {
//    HomeView()
//}



//import SwiftUI
//
//struct HomeView: View {
//    @ObservedObject var userViewModel = UserViewModel()
//    @State private var selectedCard: Int? = nil
//    @State private var showProfile = false
//    
//    var body: some View {
//        NavigationView {
//            GeometryReader { geometry in
//                ZStack {
//                    // Enhanced Background Gradient
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.7)]),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                    .edgesIgnoringSafeArea(.all)
//                    
//                    VStack(spacing: 0) {
//                        // Header Section
//                        HStack {
//                            VStack(alignment: .leading) {
//                                if let user = userViewModel.user {
//                                    Text("Hi \(user.username)! 👋🏻")
//                                        .font(.system(size: geometry.size.width * 0.08))  // Dynamic font size
//                                        .foregroundColor(.black)
//                                        .offset(y: 10)
//                                        .lineLimit(1)
//                                        .minimumScaleFactor(0.5)  // Scale down if text is too long
//                                        .bold()
//                                } else {
//                                    Text("Hi there! 👋🏻")
//                                        .font(.system(size: geometry.size.width * 0.08))
//                                        .foregroundColor(.black)
//                                        .offset(y: 10)
//                                        .bold()
//                                }
//                            }
//
//                            Spacer()
//
//                            // Replace the image with initials in a circle
//                            Button(action: {
//                                showProfile = true
//                            }) {
//                                if let user = userViewModel.user {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color(.systemGray)) // System gray color
//                                            .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
//                                        Text(getInitials(from: user.username))
//                                            .font(.system(size: geometry.size.width * 0.05))
//                                            .foregroundColor(.white)
//                                            .bold()
//                                    }
//                                } else {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color(.systemGray)) // System gray color
//                                            .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
//                                        Text("NA")
//                                            .font(.system(size: geometry.size.width * 0.05))
//                                            .foregroundColor(.white)
//                                            .bold()
//                                    }
//                                }
//                            }
//                            .sheet(isPresented: $showProfile) {
//                                ProfileView()  // Sheet presentation for ProfileView
//                            }
//                            .offset(y: 10)
//                        }
//                        .padding()
//                        
//                        ScrollView {
//                            VStack(spacing: 30) {
//                                // Allergy Card with background image
//                                NavigationLink(destination: AllergyView(), tag: 1, selection: $selectedCard) {
//                                    CardView(title: "Choose Your Allergy",
//                                             subtitle: "Manage Allergies",
//                                             cardImage: "allergyIcon",
//                                             backgroundImage: "bg1")
//                                }
//                                
//                                // Veg and Non-Veg Card with background image
//                                NavigationLink(destination: VegPreferenceView(), tag: 2, selection: $selectedCard) {
//                                    CardView(title: "Veg and Non-Veg",
//                                             subtitle: "Choose your preference",
//                                             cardImage: "vegIcon",
//                                             backgroundImage: "bg2")
//                                }
//                                
//                                // AI Recipe Generator Card with background image
//                                NavigationLink(destination: AIRecipieView(), tag: 3, selection: $selectedCard) {
//                                    CardView(title: "AI Recipe Generator",
//                                             subtitle: "Get Custom Recipes",
//                                             cardImage: "recipeIcon",
//                                             backgroundImage: "bg3")
//                                }
//                                
//                                // Trending Articles Section
//                                Text("Trending Articles")
//                                    .font(.system(size: 25))
//                                    .foregroundColor(.gray)
//                                    .padding(.top, 18)
//                                
//                                ArticleRow()  // Add your ArticleRow view
//                            }
//                            .padding()
//                        }
//                    }
//                }
//                .navigationBarHidden(true)
//                .onAppear {
//                    DispatchQueue.main.async {
//                        userViewModel.fetchUser()
//                    }
//                    print("userViewModel.user is \(userViewModel.user)")
//                }
//            }
//        }
//    }
//}
//
//// CardView Component with background image and semi-transparent text background
//struct CardView: View {
//    let title: String
//    let subtitle: String
//    let cardImage: String
//    let backgroundImage: String  // Background image name
//    
//    var body: some View {
//        ZStack {
//            // Background image
//            Image(backgroundImage)
//                .resizable()
//                .scaledToFill()
//                .frame(height: 200)
//                .clipped()
//                .cornerRadius(25)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 25)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
//                                startPoint: .bottomLeading,
//                                endPoint: .topTrailing
//                            )
//                        )
//                )
//            
//            // Content overlay with opacity
//            VStack(alignment: .leading) {
//                HStack {
//                    Image(systemName: cardImage)
//                        .font(.largeTitle)
//                        .foregroundColor(.white)
//                    Spacer()
//                }
//                Spacer()
//                
//                // Text section with semi-transparent background
//                VStack(alignment: .leading) {
//                    Text(title)
//                        .font(.title)
//                        .bold()
//                        .foregroundColor(.white)
//                    Text(subtitle)
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.8))
//                }
//                .padding()
//                .background(Color.black.opacity(0.3)) // Semi-transparent background
//                .cornerRadius(10)
//            }
//            .padding()
//        }
//        .frame(height: 200)
//        .cornerRadius(25)
//        .shadow(radius: 10)
//    }
//}
//
//// ArticleRow Component remains the same
//struct ArticleRow: View {
//    var body: some View {
//        VStack {
//            Image("article")
//                .resizable()
//                .frame(width: 150, height: 110)
//                .offset(x: -100, y: 10)
//            
//            Text("12 April 2023")
//                .font(.system(size: 14))
//                .foregroundColor(.gray)
//                .offset(x: 30, y: -90)
//            
//            Text("Food authority: Restaurants,\nobey food info rules ")
//                .font(.system(size: 15))
//                .foregroundColor(.black)
//                .offset(x: 85, y: -80)
//            
//            Text("By India Times")
//                .font(.system(size: 15))
//                .foregroundColor(.gray)
//                .offset(x: 40, y: -70)
//            
//            Button(action: {
//                // Action for Browse button
//            }) {
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.green)
//                    .font(.system(size: 14))
//                    .offset(x: 112, y: -85)
//            }
//        }
//        .padding(.vertical, 10)
//    }
//}
//
//// Helper function to extract initials
//func getInitials(from name: String) -> String {
//    let components = name.split(separator: " ")
//    let initials = components.prefix(2).map { $0.prefix(1) }
//    return initials.joined().uppercased()
//}
//
//#Preview {
//    HomeView()
//}



//import SwiftUI
//
//struct HomeView: View {
//    @ObservedObject var userViewModel = UserViewModel()
//    @State private var selectedCard: Int? = nil
//    @State private var showProfile = false
//    
//    
//    var body: some View {
//        NavigationView {
//            GeometryReader { geometry in
//                ZStack {
//                    // Enhanced Background Gradient
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.7)]),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                    .edgesIgnoringSafeArea(.all)
//                    
//                    VStack(spacing: 0) {
//                        // Header Section
//                        HStack {
//                            VStack(alignment: .leading) {
//                                if let user = userViewModel.user {
//                                    Text("Hi \(user.username)! 👋🏻")
//                                        .font(.system(size: geometry.size.width * 0.08))  // Dynamic font size
//                                        .foregroundColor(.black)
//                                        .offset(y: 10)
//                                        .lineLimit(1)
//                                        .minimumScaleFactor(0.5)  // Scale down if text is too long
//                                        .bold()
//                                } else {
//                                    Text("Hi there! 👋🏻")
//                                        .font(.system(size: geometry.size.width * 0.08))
//                                        .foregroundColor(.black)
//                                        .offset(y: 10)
//                                        .bold()
//                                }
//                            }
//
//                            Spacer()
//
//                            // Replace the image with initials in a smaller circle
//                            Button(action: {
//                                showProfile = true
//                            }) {
//                                if let user = userViewModel.user {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color(.lightGray)) // Light gray color
//                                            .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1) // Smaller circle
//                                        Text(getInitials(from: user.username))
//                                            .font(.system(size: geometry.size.width * 0.045)) // Adjust font size for initials
//                                            .foregroundColor(.white)
//                                            .bold()
//                                    }
//                                } else {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color(.lightGray)) // Light gray color
//                                            .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1) // Smaller circle
//                                        Text("NA")
//                                            .font(.system(size: geometry.size.width * 0.045)) // Adjust font size for initials
//                                            .foregroundColor(.white)
//                                            .bold()
//                                    }
//                                }
//                            }
//                            .sheet(isPresented: $showProfile) {
//                                ProfileView()  // Sheet presentation for ProfileView
//                            }
//                            .offset(y: 10)
//                        }
//                        .padding()
//                        
//                        ScrollView {
//                            VStack(spacing: 30) {
//                                // Allergy Card with background image
//                                NavigationLink(destination: AllergyView(), tag: 1, selection: $selectedCard) {
//                                    CardBView(title: "Choose Your Allergy",
//                                             subtitle: "Manage Allergies",
//                                             cardImage: "allergyIcon",
//                                             backgroundImage: "bg1")
//                                }
//                                
//                                // Veg and Non-Veg Card with background image
//                                NavigationLink(destination: VegPreferenceView(), tag: 2, selection: $selectedCard) {
//                                    CardBView(title: "Veg and Non-Veg",
//                                             subtitle: "Choose your preference",
//                                             cardImage: "vegIcon",
//                                             backgroundImage: "bg2")
//                                }
//                                
//                                // AI Recipe Generator Card with background image
//                                NavigationLink(destination: AIRecipeView(), tag: 3, selection: $selectedCard) {
//                                    CardBView(title: "AI Recipe Generator",
//                                             subtitle: "Get Custom Recipes",
//                                             cardImage: "recipeIcon",
//                                             backgroundImage: "bg3")
//                                }
//                                
//                                // Trending 
//                                
//                                 // Add your ArticleRow view
//                            }
//                            .padding()
//                        }
//                    }
//                }
//                .navigationBarHidden(true)
//                .onAppear {
//                    DispatchQueue.main.async {
//                        userViewModel.fetchUser()
//                    }
//                    print("userViewModel.user is \(userViewModel.user)")
//                }
//            }
//            .navigationBarBackButtonHidden(true)
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//// CardView Component with background image and semi-transparent text background
//struct CardBView: View {
//    let title: String
//    let subtitle: String
//    let cardImage: String
//    let backgroundImage: String  // Background image name
//    
//    var body: some View {
//        ZStack {
//            // Background image
//            Image(backgroundImage)
//                .resizable()
//                .scaledToFill()
//                .frame(height: 200)
//                .clipped()
//                .cornerRadius(25)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 25)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
//                                startPoint: .bottomLeading,
//                                endPoint: .topTrailing
//                            )
//                        )
//                )
//            
//            // Content overlay with opacity
//            VStack(alignment: .leading) {
//                HStack {
//                    Image(systemName: cardImage)
//                        .font(.largeTitle)
//                        .foregroundColor(.white)
//                    Spacer()
//                }
//                Spacer()
//                
//                // Text section with semi-transparent background
//                VStack(alignment: .leading) {
//                    Text(title)
//                        .font(.title)
//                        .bold()
//                        .foregroundColor(.white)
//                    Text(subtitle)
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.8))
//                }
//                .padding()
//                .background(Color.black.opacity(0.3)) // Semi-transparent background
//                .cornerRadius(10)
//            }
//            .padding()
//        }
//        .frame(height: 200)
//        .cornerRadius(25)
//        .shadow(radius: 10)
//    }
//}
//
//// ArticleRow Component remains the same
//
//
//// Helper function to extract initials
//func getInitials(from name: String) -> String {
//    let components = name.split(separator: " ")
//    let initials = components.prefix(2).map { $0.prefix(1) }
//    return initials.joined().uppercased()
//}
//
////#Preview {
////    HomeView()
////}
//here
//
//import SwiftUI
//
//struct HomeView: View {
//    @ObservedObject var userViewModel = UserViewModel()
//    @State private var selectedCard: Int? = nil
//    @State private var showProfile = false
//    @State private var carouselIndex = 0
//    @State private var timer: Timer? = nil
//
//    private var carouselCards = [
//        CarouselCard(id: 1, title: "Always Read Labels", subtitle: "Check ingredients on every purchase.", Btitle: "Be Informed", Bsubtitle: "Labels can save lives.", backgroundImage: "bg4"),
//        CarouselCard(id: 2, title: "Keep Emergency Medication Handy", subtitle: "Be ready for emergencies.", Btitle: "Stay Prepared", Bsubtitle: "Carry an epinephrine injector.", backgroundImage: "bg5"),
//        CarouselCard(id: 3, title: "Understand Cross-Contamination", subtitle: "Prevent accidental exposure.", Btitle: "Stay Safe", Bsubtitle: "Use separate utensils.", backgroundImage: "bg6"),
//        CarouselCard(id: 4, title: "Communicate Your Allergies", subtitle: "Let others know.", Btitle: "Advocate", Bsubtitle: "Educate friends and family.", backgroundImage: "bg7"),
//        CarouselCard(id: 5, title: "Wear a Medical Alert Bracelet", subtitle: "Alert others in emergencies.", Btitle: "Stay Identified", Bsubtitle: "It could save your life.", backgroundImage: "bg8")
//            ]
//
//    var body: some View {
//        NavigationView {
//            GeometryReader { geometry in
//                ZStack {
//                    // Enhanced Background Gradient
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.7)]),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                    .edgesIgnoringSafeArea(.all)
//
//                    VStack(spacing: 0) {
//                        // Header Section
//                        HStack {
//                            VStack(alignment: .leading) {
//                                if let user = userViewModel.user {
//                                    Text("Hi \(user.username)! 👋🏻")
//                                        .font(.system(size: geometry.size.width * 0.08))  // Dynamic font size
//                                        .foregroundColor(.black)
//                                        .offset(y: 10)
//                                        .lineLimit(1)
//                                        .minimumScaleFactor(0.5)  // Scale down if text is too long
//                                        .bold()
//                                } else {
//                                    Text("Hi there! 👋🏻")
//                                        .font(.system(size: geometry.size.width * 0.08))
//                                        .foregroundColor(.black)
//                                        .offset(y: 10)
//                                        .bold()
//                                }
//                            }
//
//                            Spacer()
//
//                            // Replace the image with initials in a smaller circle
//                            Button(action: {
//                                showProfile = true
//                            }) {
//                                if let user = userViewModel.user {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color(.lightGray)) // Light gray color
//                                            .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1) // Smaller circle
//                                        Text(getInitials(from: user.username))
//                                            .font(.system(size: geometry.size.width * 0.045)) // Adjust font size for initials
//                                            .foregroundColor(.white)
//                                            .bold()
//                                    }
//                                } else {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color(.lightGray)) // Light gray color
//                                            .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1) // Smaller circle
//                                        Text("NA")
//                                            .font(.system(size: geometry.size.width * 0.045)) // Adjust font size for initials
//                                            .foregroundColor(.white)
//                                            .bold()
//                                    }
//                                }
//                            }
//                            .sheet(isPresented: $showProfile) {
//                                ProfileView()  // Sheet presentation for ProfileView
//                            }
//                            .offset(y: 10)
//                        }
//                        .padding()
//
//                        ScrollView {
//                            VStack(spacing: 20) {
//                                // Carousel Slider at the top
//                                TabView(selection: $carouselIndex) {
//                                    ForEach(carouselCards.indices, id: \.self) { index in
//                                        NavigationLink(destination: Text("View for card ID \(carouselCards[index].id)")) {
//                                            CardView(
//                                                title: carouselCards[index].title,
//                                                subtitle: carouselCards[index].subtitle,
//                                                backgroundImage: carouselCards[index].backgroundImage,
//                                                Btitle: carouselCards[index].Btitle,
//                                                Bsubtitle: carouselCards[index].Bsubtitle)
//                                        }
//                                        .tag(index)
//                                    }
//                                }
//                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
//                                .frame(height: 450)
//                                // Increased height for carousel
////                                .padding()
//                                .onAppear {
//                                    startAutoScroll()
//                                }
//                                .onDisappear {
//                                    stopAutoScroll()
//                                }
//
//                                // Existing cards below the carousel
////                                NavigationLink(destination: AllergyView(), tag: 1, selection: $selectedCard) {
////                                    CardBView(title: "Choose Your Allergy",
////                                              subtitle: "Manage Allergies",
////                                              cardImage: "allergyIcon",
////                                              backgroundImage: "bg1")
////                                }
//
//                                NavigationLink(destination: VegPreferenceView(), tag: 2, selection: $selectedCard) {
//                                    CardBView(title: "Veg and Non-Veg",
//                                              subtitle: "Choose your preference",
//                                              cardImage: "vegIcon",
//                                              backgroundImage: "bg2")
//                                }
//
//                                NavigationLink(destination: AIRecipeView(), tag: 3, selection: $selectedCard) {
//                                    CardBView(title: "AI Recipe Generator",
//                                              subtitle: "Get Custom Recipes",
//                                              cardImage: "recipeIcon",
//                                              backgroundImage: "bg3")
//                                }
//                            }
//                            .padding()
//                        }
//                    }
//                }
//                .navigationBarHidden(true)
//                .onAppear {
//                    DispatchQueue.main.async {
//                        userViewModel.fetchUser()
//                    }
//                }
//            }
//            .navigationBarBackButtonHidden(true)
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//
//    private func startAutoScroll() {
//        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
//            withAnimation {
//                carouselIndex = (carouselIndex + 1) % carouselCards.count
//            }
//        }
//    }
//
//    private func stopAutoScroll() {
//        timer?.invalidate()
//        timer = nil
//    }
//}
//
//// CardView Component with background image and semi-transparent text background
//struct CardBView: View {
//    let title: String
//    let subtitle: String
//    let cardImage: String
//    let backgroundImage: String  // Background image name
//
//    var body: some View {
//        ZStack {
//            // Background image
//            Image(backgroundImage)
//                .resizable()
//                .scaledToFill()
//                .frame(height: 200)
//                .clipped()
//                .cornerRadius(25)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 25)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
//                                startPoint: .bottomLeading,
//                                endPoint: .topTrailing
//                            )
//                        )
//                )
//
//            // Content overlay with opacity
//            VStack(alignment: .leading) {
//                HStack {
//                    Image(systemName: cardImage)
//                        .font(.largeTitle)
//                        .foregroundColor(.white)
//                    Spacer()
//                }
//                Spacer()
//
//                // Text section with semi-transparent background
//                VStack(alignment: .leading) {
//                    Text(title)
//                        .font(.title)
//                        .bold()
//                        .foregroundColor(.white)
//                    Text(subtitle)
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.8))
//                }
//                .padding()
//                .background(Color.black.opacity(0.3)) // Semi-transparent background
//                .cornerRadius(10)
//            }
//            .padding()
//        }
//        .frame(height: 200)
//        .cornerRadius(25)
//        .shadow(radius: 10)
//    }
//}
//struct CardView: View {
//    let title:String
//    let subtitle: String
//   
//    let backgroundImage: String
//    let Btitle:String
//    let Bsubtitle:String
//    // Background image name
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Spacer()
//            
//            // Title
//            Text(title)
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//                .padding(.horizontal)
//            
//            // Subtitle
//            Text(subtitle)
//                .font(.headline)
//                .foregroundColor(.white.opacity(0.8))
//                .padding(.horizontal)
//            
//            HStack {
//                // Game Icon
//                
//                
//                VStack(alignment: .leading) {
//                    Text(Btitle)
//                        .font(.headline)
//                        .foregroundColor(.white)
//                    
//                    Text(Bsubtitle)
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.7))
//                }
//                Spacer()
//                
//                // Price
//                VStack {
//                    Text("View")
//                        .font(.headline)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
//                        .background(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        .clipShape(Capsule())
//                        .shadow(color:Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
//                    
//                    
//                }
//            }
//            .padding()
//            .background(Color.black.opacity(0.5))
//        }
//        .frame(height: 400)
//        .frame(width:360)
//        .background(
//            ZStack {
//                Image(backgroundImage) // Replace with your background image name
//                    .resizable()
//                    .scaledToFill()
//                    // Apply a blur effect
//                
//                // Optional: Add a semi-transparent overlay for better text contrast
//                Color.black.opacity(0.3)
//            }
//        )
//        .cornerRadius(20)
//        .shadow(radius: 10)
//        .padding()
//        .frame(width:400)
//        .frame(height:300)
//    }
//        
//}
//
//// Helper function to extract initials
//func getInitials(from name: String) -> String {
//    let components = name.split(separator: " ")
//    let initials = components.prefix(2).map { $0.prefix(1) }
//    return initials.joined().uppercased()
//}
//
//// Model for CarouselCard
//struct CarouselCard: Identifiable {
//    let id: Int
//    let title:String
//    let subtitle: String
//    let Btitle:String
//    let Bsubtitle:String
//    let backgroundImage: String
//}

//
//import SwiftUI
//
//struct HomeView: View {
//    @ObservedObject var userViewModel = UserViewModel()
//    @State private var selectedCard: Int? = nil
//    @State private var showProfile = false
//    @State private var carouselIndex = 0
//    @State private var timer: Timer? = nil
//
//    private var carouselCards = [
//        CarouselCard(id: 1, title: "Always Read Labels", subtitle: "Check ingredients on every purchase.", Btitle: "Be Informed", Bsubtitle: "Labels can save lives.", backgroundImage: "bg4"),
//        CarouselCard(id: 2, title: "Keep Emergency Medication Handy", subtitle: "Be ready for emergencies.", Btitle: "Stay Prepared", Bsubtitle: "Carry an epinephrine injector.", backgroundImage: "bg5"),
//        CarouselCard(id: 3, title: "Understand Cross-Contamination", subtitle: "Prevent accidental exposure.", Btitle: "Stay Safe", Bsubtitle: "Use separate utensils.", backgroundImage: "bg6"),
//        CarouselCard(id: 4, title: "Communicate Your Allergies", subtitle: "Let others know.", Btitle: "Advocate", Bsubtitle: "Educate friends and family.", backgroundImage: "bg7"),
//        CarouselCard(id: 5, title: "Wear a Medical Alert Bracelet", subtitle: "Alert others in emergencies.", Btitle: "Stay Identified", Bsubtitle: "It could save your life.", backgroundImage: "bg8")
//    ]
//
//    var body: some View {
//        NavigationView {
//            GeometryReader { geometry in
//                ZStack {
//                    LinearGradient(
//                        gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.7)]),
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                    .edgesIgnoringSafeArea(.all)
//
//                    VStack(spacing: 0) {
//                        HStack {
//                            VStack(alignment: .leading) {
//                                if let user = userViewModel.user {
//                                    Text("Hi \(user.username)! 👋🏻")
//                                        .font(.system(size: geometry.size.width * 0.08))
//                                        .foregroundColor(.black)
//                                        .offset(y: 10)
//                                        .lineLimit(1)
//                                        .minimumScaleFactor(0.5)
//                                        .bold()
//                                } else {
//                                    Text("Hi there! 👋🏻")
//                                        .font(.system(size: geometry.size.width * 0.08))
//                                        .foregroundColor(.black)
//                                        .offset(y: 10)
//                                        .bold()
//                                }
//                            }
//
//                            Spacer()
//
//                            Button(action: {
//                                showProfile = true
//                            }) {
//                                if let user = userViewModel.user {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color(.lightGray))
//                                            .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
//                                        Text(getInitials(from: user.username))
//                                            .font(.system(size: geometry.size.width * 0.045))
//                                            .foregroundColor(.white)
//                                            .bold()
//                                    }
//                                } else {
//                                    ZStack {
//                                        Circle()
//                                            .fill(Color(.lightGray))
//                                            .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
//                                        Text("NA")
//                                            .font(.system(size: geometry.size.width * 0.045))
//                                            .foregroundColor(.white)
//                                            .bold()
//                                    }
//                                }
//                            }
//                            .sheet(isPresented: $showProfile) {
//                                ProfileView()
//                            }
//                            .offset(y: 10)
//                        }
//                        .padding()
//
//                        ScrollView {
//                            VStack(spacing: 20) {
//                                TabView(selection: $carouselIndex) {
//                                    ForEach(carouselCards.indices, id: \.self) { index in
//                                        NavigationLink(destination: CardInfoView()) {
//                                            CardView(
//                                                title: carouselCards[index].title,
//                                                subtitle: carouselCards[index].subtitle,
//                                                backgroundImage: carouselCards[index].backgroundImage,
//                                                Btitle: carouselCards[index].Btitle,
//                                                Bsubtitle: carouselCards[index].Bsubtitle
//                                            )
//                                        }
//                                        .tag(index)
//                                    }
//                                }
//                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
//                                .frame(height: 450)
//                                .onAppear {
//                                    startAutoScroll()
//                                }
//                                .onDisappear {
//                                    stopAutoScroll()
//                                }
//
//                                NavigationLink(destination: VegPreferenceView(), tag: 2, selection: $selectedCard) {
//                                    CardBView(title: "Veg and Non-Veg",
//                                              subtitle: "Choose your preference",
//                                              cardImage: "vegIcon",
//                                              backgroundImage: "bg2")
//                                }
//
//                                NavigationLink(destination: AIRecipeView(), tag: 3, selection: $selectedCard) {
//                                    CardBView(title: "AI Recipe Generator",
//                                              subtitle: "Get Custom Recipes",
//                                              cardImage: "recipeIcon",
//                                              backgroundImage: "bg3")
//                                }
//                            }
//                            .padding()
//                        }
//                    }
//                }
//                .navigationBarHidden(true)
//                .onAppear {
//                    DispatchQueue.main.async {
//                        userViewModel.fetchUser()
//                    }
//                }
//            }
//            .navigationBarBackButtonHidden(true)
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//
//    private func startAutoScroll() {
//        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
//            withAnimation {
//                carouselIndex = (carouselIndex + 1) % carouselCards.count
//            }
//        }
//    }
//
//    private func stopAutoScroll() {
//        timer?.invalidate()
//        timer = nil
//    }
//}
//
//struct CardView: View {
//    let title: String
//    let subtitle: String
//    let backgroundImage: String
//    let Btitle: String
//    let Bsubtitle: String
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Spacer()
//
//            Text(title)
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//                .padding(.horizontal)
//
//            Text(subtitle)
//                .font(.headline)
//                .foregroundColor(.white.opacity(0.8))
//                .padding(.horizontal)
//
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(Btitle)
//                        .font(.headline)
//                        .foregroundColor(.white)
//
//                    Text(Bsubtitle)
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.7))
//                }
//                Spacer()
//
//                NavigationLink(destination: CardInfoView()) {
//                   
//                    Text("View")
//                        .font(.headline)
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
//                        .background(Color(red: 79 / 255, green: 143 / 255, blue: 0 / 255))
//                        .clipShape(Capsule())
//                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
//                }
//            }
//            .padding()
//            .background(Color.black.opacity(0.5))
//        }
//        .frame(height: 400)
//        .frame(width: 360)
//        .background(
//            ZStack {
//                Image(backgroundImage)
//                    .resizable()
//                    .scaledToFill()
//                Color.black.opacity(0.3)
//            }
//        )
//        .cornerRadius(20)
//        .shadow(radius: 10)
//        .padding()
//    }
//}
//
//struct CardInfoView: View {
//    var body: some View {
//        Text("Card Info View")
//            .font(.largeTitle)
//            .foregroundColor(.blue)
//    }
//}
//
//struct CarouselCard: Identifiable {
//    let id: Int
//    let title: String
//    let subtitle: String
//    let Btitle: String
//    let Bsubtitle: String
//    let backgroundImage: String
//}
//
//func getInitials(from name: String) -> String {
//    let components = name.split(separator: " ")
//    let initials = components.prefix(2).map { $0.prefix(1) }
//    return initials.joined().uppercased()
//}
//struct CardBView: View {
//    let title: String
//    let subtitle: String
//    let cardImage: String
//    let backgroundImage: String  // Background image name
//
//    var body: some View {
//        ZStack {
//            // Background image
//            Image(backgroundImage)
//                .resizable()
//                .scaledToFill()
//                .frame(height: 200)
//                .clipped()
//                .cornerRadius(25)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 25)
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
//                                startPoint: .bottomLeading,
//                                endPoint: .topTrailing
//                            )
//                        )
//                )
//
//            // Content overlay with opacity
//            VStack(alignment: .leading) {
//                HStack {
//                    Image(systemName: cardImage)
//                        .font(.largeTitle)
//                        .foregroundColor(.white)
//                    Spacer()
//                }
//                Spacer()
//
//                // Text section with semi-transparent background
//                VStack(alignment: .leading) {
//                    Text(title)
//                        .font(.title)
//                        .bold()
//                        .foregroundColor(.white)
//                    Text(subtitle)
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.8))
//                }
//                .padding()
//                .background(Color.black.opacity(0.3)) // Semi-transparent background
//                .cornerRadius(10)
//            }
//            .padding()
//        }
//        .frame(height: 200)
//        .cornerRadius(25)
//        .shadow(radius: 10)
//    }
//}

import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel = UserViewModel()
    @State private var selectedCard: Int? = nil
    @State private var showProfile = false
    @State private var carouselIndex = 0
    @State private var timer: Timer? = nil

    private var carouselCards = [
        CarouselCard(id: 1, title: "Always Read Labels", subtitle: "Check ingredients on every purchase.", Btitle: "Be Informed", Bsubtitle: "Labels can save lives.", backgroundImage: "bg4"),
        CarouselCard(id: 2, title: "Keep Emergency Medication Handy", subtitle: "Be ready for emergencies.", Btitle: "Stay Prepared", Bsubtitle: "Carry an epinephrine injector.", backgroundImage: "bg5"),
        CarouselCard(id: 3, title: "Understand Cross-Contamination", subtitle: "Prevent accidental exposure.", Btitle: "Stay Safe", Bsubtitle: "Use separate utensils.", backgroundImage: "bg6"),
        CarouselCard(id: 4, title: "Communicate Your Allergies", subtitle: "Let others know.", Btitle: "Advocate", Bsubtitle: "Educate friends and family.", backgroundImage: "bg7"),
        CarouselCard(id: 5, title: "Wear a Medical Alert Bracelet", subtitle: "Alert others in emergencies.", Btitle: "Stay Identified", Bsubtitle: "It could save your life.", backgroundImage: "bg8")
    ]

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                if let user = userViewModel.user {
                                    Text("Hi \(user.username)! 👋🏻")
                                        .font(.system(size: geometry.size.width * 0.08))
                                        .foregroundColor(.black)
                                        .offset(y: 10)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .bold()
                                } else {
                                    Text("Hi there! 👋🏻")
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
                                if let user = userViewModel.user {
                                    ZStack {
                                        Circle()
                                            .fill(Color(.lightGray))
                                            .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                                        Text(getInitials(from: user.username))
                                            .font(.system(size: geometry.size.width * 0.045))
                                            .foregroundColor(.white)
                                            .bold()
                                    }
                                } else {
                                    ZStack {
                                        Circle()
                                            .fill(Color(.lightGray))
                                            .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                                        Text("NA")
                                            .font(.system(size: geometry.size.width * 0.045))
                                            .foregroundColor(.white)
                                            .bold()
                                    }
                                }
                            }
                            .sheet(isPresented: $showProfile) {
                                ProfileView()
                            }
                            .offset(y: 10)
                        }
                        .padding()

                        ScrollView {
                            VStack(spacing: 20) {
                                TabView(selection: $carouselIndex) {
                                    ForEach(carouselCards.indices, id: \.self) { index in
                                        NavigationLink(destination: getCardInfoView(for: index)) {
                                            CardView(
                                                title: carouselCards[index].title,
                                                subtitle: carouselCards[index].subtitle,
                                                backgroundImage: carouselCards[index].backgroundImage,
                                                Btitle: carouselCards[index].Btitle,
                                                Bsubtitle: carouselCards[index].Bsubtitle,
                                                cardIndex:carouselCards[index].id
                                            )
                                        }
                                        .tag(index)
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                                .frame(height: 450)
                                .onAppear {
                                    startAutoScroll()
                                }
                                .onDisappear {
                                    stopAutoScroll()
                                }

                                NavigationLink(destination: VegPreferenceView(), tag: 2, selection: $selectedCard) {
                                    CardBView(title: "Veg and Non-Veg",
                                              subtitle: "Choose your preference",
                                              cardImage: "vegIcon",
                                              backgroundImage: "bg2")
                                }

                                NavigationLink(destination: AIRecipeView(), tag: 3, selection: $selectedCard) {
                                    CardBView(title: "AI Recipe Generator",
                                              subtitle: "Get Custom Recipes",
                                              cardImage: "recipeIcon",
                                              backgroundImage: "bg3")
                                }
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
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarBackButtonHidden(true)
    }

    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation {
                carouselIndex = (carouselIndex + 1) % carouselCards.count
            }
        }
    }

    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }

    // This function will return the appropriate CardInfoView based on the index
   func getCardInfoView(for index: Int) -> some View {
        switch index {
        case 0:
            return AnyView(CardInfoView1())
        case 1:
            return AnyView(CardInfoView2())
        case 2:
            return AnyView(CardInfoView3())
        case 3:
            return AnyView(CardInfoView4())
        case 4:
            return AnyView(CardInfoView5())
        default:
            return AnyView(Text("Unknown Card"))
        }
    }
}

struct CardView: View {
    let title: String
    let subtitle: String
    let backgroundImage: String
    let Btitle: String
    let Bsubtitle: String
    let cardIndex: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()

            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal)

            Text(subtitle)
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal)

            HStack {
                VStack(alignment: .leading) {
                    Text(Btitle)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(Bsubtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()

                NavigationLink(destination: destinationView(for: cardIndex)) {
                    Text("View")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(red: 79 / 255, green: 143 / 255, blue: 0 / 255))
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
        }
        .frame(height: 400)
        .frame(width: 360)
        .background(
            ZStack {
                Image(backgroundImage)
                    .resizable()
                    .scaledToFill()
                Color.black.opacity(0.3)
            }
        )
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }

    private func destinationView(for index: Int) -> some View {
        switch index {
        case 1:
            return AnyView(CardInfoView1())
        case 2:
            return AnyView(CardInfoView2())
        case 3:
            return AnyView(CardInfoView3())
        case 4:
            return AnyView(CardInfoView4())
        case 5:
            return AnyView(CardInfoView5())
        default:
            return AnyView(Text("Unknown Card"))
        }
    }
}



struct CarouselCard: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let Btitle: String
    let Bsubtitle: String
    let backgroundImage: String
}

func getInitials(from name: String) -> String {
    let components = name.split(separator: " ")
    let initials = components.prefix(2).map { $0.prefix(1) }
    return initials.joined().uppercased()
}


    struct CardBView: View {
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
