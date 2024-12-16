import SwiftUI

struct CardInfoView1: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the view

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top 25% with Background Image
                    ZStack(alignment: .bottomLeading) {
                        Image("bg4") // Replace with your image asset name
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                            .clipped()
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                        
                        // Title and Subtitle aligned to bottom-left
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Always Read Labels")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Check ingredients on every purchase.")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.leading, 16) // Padding from the left
                        .padding(.bottom, 16) // Padding from the bottom
                        
                        // Cross Button at the top-right corner
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(.trailing, 16) // Adjust padding for the button
                                .padding(.top,50)
                            }
                            Spacer()
                        }
                    }
                    .frame(height: geometry.size.height * 0.25) // Set to 25% of the screen height
                    
                    // Bottom 75% with Normal Text
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("1.Identifying Hidden Allergens in Everyday Foods")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        1.Nuts: Found in sauces, baked goods, or granola bars.
                        2.Dairy: May appear in processed snacks, non-dairy creamers, or soups.
                        3.Gluten: Often present in soy sauce, processed meats, and dressings.
                        4.Shellfish: Can be hidden in broths, sauces, or as flavor enhancers.
                        
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                            
                            Text("2.Surprising Foods That May Contain Hidden Allergens")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        Many everyday foods can contain hidden allergens that might not be immediately obvious. For instance, nuts are often found in unexpected items like pesto, salad dressings, and even flavored coffee syrups. Dairy, despite its name, can hide in products like bread, processed meats, and margarine labeled as "non-dairy." Gluten, a common allergen, may be present in imitation crab, soy sauce, or certain candies. 
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                            
                            Text("3.Packaged foods may contain labels")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        Packaged foods often include precautionary labels like "may contain traces of" or "processed in a facility with." These warnings indicate the potential for cross-contamination with allergens during production. For example, chocolate bars, cereals, and snack chips may carry these labels, even if the allergen isn’t an intentional ingredient. 
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                }
                .edgesIgnoringSafeArea(.top) // Ignore safe area for the image
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct CardInfoView2: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top 25% with Background Image
                    ZStack(alignment: .bottomLeading) {
                        Image("bg5") // Replace with your image asset name
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                            .clipped()
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                        
                        // Title and Subtitle aligned to bottom-left
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Keep Emergency Medication Handy")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Be ready for emergencies.")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.leading, 16) // Padding from the left
                        .padding(.bottom, 16) // Padding from the bottom
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(.trailing, 16) // Adjust padding for the button
                                .padding(.top,50)
                            }
                            Spacer()
                        }
                    }
                    .frame(height: geometry.size.height * 0.25) // Set to 25% of the screen height
                    
                    // Bottom 75% with Normal Text
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("1. Step-by-Step Guide for Managing an Allergic Reaction")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        Having a clear, step-by-step plan is crucial when facing an allergic reaction. The first step is to recognize the symptoms, which can range from mild itching or hives to severe swelling or difficulty breathing. If symptoms worsen, administer an epinephrine injection immediately if you have one. After using the epinephrine pen, call 911 or seek emergency medical help, even if symptoms seem to improve. Stay with the person and monitor their condition until help arrives.
                        
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                            
                            Text("2.How to Use an Epinephrine Pen Correctly")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        Knowing how to use an epinephrine pen correctly is essential in an emergency. First, remove the cap and place the tip of the pen against the outer thigh, at a 90-degree angle. Press firmly to inject the medication, holding the pen in place for 3 seconds to ensure the full dose is delivered. After administering the epinephrine, seek immediate medical help. It’s important to have a plan in place for training family members, friends, or coworkers on how to use the pen if necessary.
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                            
                            Text("3. When to Seek Emergency Medical Help")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        Even if you’ve administered an epinephrine injection, it’s critical to seek emergency medical help right away. Epinephrine provides temporary relief, but the effects can wear off, and symptoms may return. Always call 911, even if symptoms improve after the injection. If you’re alone and unable to call, try to get to a hospital or urgent care center as quickly as possible. Do not delay medical care—severe allergic reactions can escalate rapidly, and professional treatment is essential.
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                }
                .edgesIgnoringSafeArea(.top) // Ignore safe area for the image
            }
        }.navigationBarBackButtonHidden(true)
    }
}
struct CardInfoView3: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top 25% with Background Image
                    ZStack(alignment: .bottomLeading) {
                        Image("bg6") // Replace with your image asset name
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                            .clipped()
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                        
                        // Title and Subtitle aligned to bottom-left
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Understand Cross-Contamination")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Prevent accidental exposure.")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.leading, 16) // Padding from the left
                        .padding(.bottom, 16) // Padding from the bottom
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(.trailing, 16) // Adjust padding for the button
                                .padding(.top,50)
                            }
                            Spacer()
                        }
                    }
                    .frame(height: geometry.size.height * 0.25) // Set to 25% of the screen height
                    
                    // Bottom 75% with Normal Text
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("1. Understanding Allergen Labeling Laws and Regulations")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        Food labeling laws require manufacturers to clearly list common allergens, such as nuts, dairy, gluten, and shellfish, on packaging. Look for the "Contains" statement, which typically appears near the ingredients list, highlighting major allergens. In many countries, allergens must be declared even if they are present in trace amounts. Familiarize yourself with these regulations to ensure you’re checking the most important sections of food labels for your safety.
                        
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                            
                            Text("2. Key Phrases to Watch for on Food Labels")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        In addition to the main ingredient list, certain phrases on food labels can indicate hidden allergens. Look for terms like “may contain,” “produced in a facility that processes,” or “processed on shared equipment.” These phrases suggest potential cross-contamination, so it’s important to exercise caution. Also, be aware of ingredients that might sound unfamiliar but contain allergens, like "casein" (dairy) or "gluten-free oats" (may still contain trace gluten).
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                            
                            Text("3. Tips for Identifying Allergen-Free Foods")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        When shopping, look for products that are explicitly labeled as “allergen-free” or “suitable for” specific dietary needs, such as gluten-free, dairy-free, or nut-free. These products are more likely to have undergone testing for allergens and are made in dedicated facilities. Also, consider choosing whole foods like fruits, vegetables, and unprocessed meats, which are less likely to contain hidden allergens. Always read labels carefully, even for products you’ve bought before, as ingredients can change.
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                }
                .edgesIgnoringSafeArea(.top) // Ignore safe area for the image
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct CardInfoView4: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top 25% with Background Image
                    ZStack(alignment: .bottomLeading) {
                        Image("bg7") // Replace with your image asset name
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                            .clipped()
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                        
                        // Title and Subtitle aligned to bottom-left
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Communicate Your Allergies")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Let others know.")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.leading, 16) // Padding from the left
                        .padding(.bottom, 16) // Padding from the bottom
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .bold))
                                      
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(.trailing, 16) // Adjust padding for the button
                                .padding(.top,50)
                            }
                            Spacer()
                        }
                    }
                    .frame(height: geometry.size.height * 0.25) // Set to 25% of the screen height
                    
                    // Bottom 75% with Normal Text
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("1. How to Communicate Your Allergies to Restaurant Staff")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        When dining out, it's crucial to clearly communicate your dietary restrictions to the restaurant staff. Start by informing the host or server about your specific allergies as soon as you arrive. Use simple, direct language like, "I have a severe allergy to nuts, and I need to avoid them in my meal." Consider bringing a “Special Diet” card with you that lists your allergies and any other dietary needs. This ensures that the kitchen staff understands the seriousness of your request and can take extra precautions.
                        
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                            
                            Text("2. Questions to Ask When Ordering to Ensure Safe Meals")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        To ensure your meal is safe, ask the server a few key questions about food preparation. Inquire about how your dish is cooked and whether it shares equipment or surfaces with allergens. For example, ask, "Is this dish prepared in a fryer that also cooks shellfish?" or "Do any ingredients in this dish contain hidden dairy or gluten?" Be proactive and request that your meal be made fresh, if necessary, to avoid cross-contamination.
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                            
                            Text("3. What to Do If You Suspect Cross-Contamination at a Restaurant")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        If you suspect that your food may have been contaminated with an allergen, take immediate action. Politely ask the server to bring the dish back to the kitchen and request a new meal prepared without the allergen. It’s important to stay calm but firm in explaining the situation. If you're unsure about the safety of the food, don't hesitate to leave the restaurant and find another place that can accommodate your needs. Always prioritize your health and safety over convenience when dining out.
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                }
                .edgesIgnoringSafeArea(.top) // Ignore safe area for the image
            }
        }.navigationBarBackButtonHidden(true)
    }
}
struct CardInfoView5: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top 25% with Background Image
                    ZStack(alignment: .bottomLeading) {
                        Image("bg8") // Replace with your image asset name
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.25)
                            .clipped()
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                        
                        // Title and Subtitle aligned to bottom-left
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Wear a Medical Alert Bracelet")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Alert others in emergencies.")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.leading, 16) // Padding from the left
                        .padding(.bottom, 16) // Padding from the bottom
                        VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .bold))
                                        
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(.trailing, 16) // Adjust padding for the button
                                .padding(.top,50)
                            }
                            Spacer()
                        }
                    }
                    .frame(height: geometry.size.height * 0.25) // Set to 25% of the screen height
                    
                    // Bottom 75% with Normal Text
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("1. Benefits of Tracking Allergy Symptoms Over Time")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        Tracking your allergy symptoms consistently can help you identify patterns and triggers, making it easier to manage your allergies. By logging symptoms such as hives, swelling, or difficulty breathing, you can spot trends related to specific foods, environments, or activities. This data can be invaluable when consulting with healthcare providers, as it provides a clear record of how your allergies are affecting you. Over time, symptom tracking can lead to better prevention strategies and more personalized treatment plans.
                        
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                            
                            Text("2. How to Effectively Track Your Allergy Symptoms")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        To track your symptoms effectively, use a dedicated symptom tracker or journal that includes the following details: date, time, food or environmental exposure, severity of symptoms, and any medication taken. Be specific about the symptoms you experience, such as itching, swelling, or breathing issues, and note their intensity. You can also use digital apps that allow you to log symptoms on the go, making it easier to stay consistent and share the information with your doctor when needed.
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                            
                            Text("3. Using Symptom Data to Improve Allergy Management")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text("""
                        The data collected from your symptom tracker can be used to refine your allergy management strategies. For example, if you notice that certain foods consistently trigger reactions, you can eliminate them from your diet. If symptoms worsen in specific environments, like during pollen season or in a certain location, you can take preventive measures, such as adjusting your lifestyle or medication regimen. This proactive approach, informed by your symptom log, helps you stay ahead of potential allergic reactions and reduces the risk of severe episodes.
                        """)
                            .font(.body)
                            .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                }
                .edgesIgnoringSafeArea(.top) // Ignore safe area for the image
            }
        }.navigationBarBackButtonHidden(true)
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardInfoView1()
    }
}
