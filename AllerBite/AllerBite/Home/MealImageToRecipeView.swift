////
////  MealImageToRecipeView.swift
////  AllerBite
////
////  Created by Aditya Gaba on 8/12/24.
////
//import SwiftUI
//import PhotosUI
//import GoogleGenerativeAI
//import UIKit
//
//struct MealImageToRecipeView: View {
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var selectedImage: Image?
//    @State private var analyzedResult: String?
//    @State private var isAnalyzing: Bool = false
//    @State private var isShowingCamera = false
//    @State private var allergies: [String] = []
//    @State private var showResultView = false
//    
//    let allergyOptions = ["Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]
//
//    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
//
//    var body: some View {
//        NavigationView{
//            VStack {
//                Text("🍕 Meal Image to Recipe")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding(.top, 20)
//                
//                Text("Powered by Gemini AI :")
//                    .font(.headline)
//                    .foregroundColor(.gray)
//                    .padding(.bottom, 10)
//                
//                Text("Upload an image of a meal to get a recipe on how to cook it.")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.bottom, 20)
//                
//                if let selectedImage {
//                    selectedImage
//                        .resizable()
//                        .scaledToFit()
//                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                        .overlay {
//                            if isAnalyzing {
//                                RoundedRectangle(cornerRadius: 20.0)
//                                    .fill(Color.black.opacity(0.5))
//                                ProgressView()
//                                    .tint(.white)
//                            }
//                        }
//                        .padding(.horizontal)
//                } else {
//                    Image(systemName: "photo")
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundColor(.gray)
//                        .frame(maxWidth: .infinity, maxHeight: 150)
//                        .background(Color(.systemGray6))
//                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                        .padding(.horizontal)
//                }
//                
//                ScrollView {
//                    Text(analyzedResult ?? (isAnalyzing ? "Analyzing..." : "Select or capture a photo to get started"))
//                        .font(.system(.title2, design: .rounded))
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color(.systemGray6))
//                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                        .padding(.horizontal)
//                }
//                
//                Spacer()
//                
//                HStack {
//                    PhotosPicker(selection: $selectedItem, matching: .images) {
//                        Label("Select Photo", systemImage: "photo")
//                            .frame(maxWidth: .infinity)
//                            .bold()
//                            .padding()
//                            .foregroundColor(.white)
//                            .background(Color.indigo)
//                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                    }
//                    
//                    Button(action: {
//                        isShowingCamera = true
//                    }) {
//                        Label("Capture Photo", systemImage: "camera")
//                            .frame(maxWidth: .infinity)
//                            .bold()
//                            .padding()
//                            .foregroundColor(.white)
//                            .background(Color.blue)
//                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                    }
//                    .sheet(isPresented: $isShowingCamera) {
//                        ImagePicker(sourceType: .camera) { image in
//                            if let image = image {
//                                selectedImage = Image(uiImage: image)
//                                analyze(uiImage: image)
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal)
//                
//                VStack {
//                    Text("Select Allergies")
//                        .font(.headline)
//                        .padding(.top)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack {
//                            ForEach(allergyOptions, id: \.self) { allergy in
//                                Button(action: {
//                                    if allergies.contains(allergy) {
//                                        allergies.removeAll { $0 == allergy }
//                                    } else {
//                                        allergies.append(allergy)
//                                    }
//                                }) {
//                                    Text(allergy)
//                                        .padding()
//                                        .background(allergies.contains(allergy) ? Color.blue : Color.gray)
//                                        .foregroundColor(.white)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
//                                }
//                            }
//                        }
//                        .padding()
//                    }
//                    .background(Color(.systemGray6))
//                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                    .padding(.horizontal)
//                }
//            }
//            .padding(.horizontal)
//            .onChange(of: selectedItem) { oldItem, newItem in
//                Task {
//                    if let image = try? await newItem?.loadTransferable(type: Image.self) {
//                        selectedImage = image
//                        if let uiImage = image.asUIImage() {
//                            analyze(uiImage: uiImage)
//                        }
//                    }
//                }
//            }
//            .sheet(isPresented: $showResultView) {
//                if let result = analyzedResult, let image = selectedImage {
//                    ResultView(result: result, image: image)
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//    }
//    
//
//    @MainActor func analyze(uiImage: UIImage) {
//        self.analyzedResult = nil
//        self.isAnalyzing.toggle()
//
////        let prompt = """
////        From the given image, perform the following tasks:
////        1. Identify the ingredient(s) in the image.
////        2. Suggest one popular meal based on the image.
////        3. List other ingredients typically associated with this meal.
////        4. Provide a recipe containing the identified ingredients and step-by-step cooking instructions.
////        5. If the image doesn't clearly represent food or ingredients, respond with "I don't know."
////        6. Consider the following allergies: \(allergies.joined(separator: ", ")).
////        7. If any of the ingredients in the image match an allergy, respond with a warning that the meal contains allergens.
////        8. If the meal appears to be the same as one of the specified allergies, suggest alternatives or modifications to avoid the allergen.
////"""
//
////        let prompt = """
////        From the given image, perform the following tasks:
////        1. Identify the main ingredient from the image.
////        2. If the following allergies are specified: \(allergies.isEmpty ? "None" : allergies.joined(separator: ", ")), check if the identified main ingredient matches any of them.
////           a. If the main ingredient matches an allergy, return only a warning: "Warning: The main ingredient in this dish contains [allergen]. It is unsafe based on your specified allergies."
////        3. If no allergies are specified or the main ingredient does not match any of the allergies, proceed with the following:
////           a. Suggest a popular meal based on the image.
////           b. List other ingredients typically associated with the meal.
////           c. Provide a recipe containing the identified ingredients with step-by-step cooking instructions.
////
////"""
//        let prompt = """
//        Analyze the provided image and complete the following tasks:
//        1. Identify the ingredient(s) shown in the image.
//        2. Check if any of the identified ingredients match the following allergies: \(allergies.joined(separator: ", ")).
//        3. If any ingredient matches an allergy, automatically suggest suitable substitutions and provide an allergy-free recipe.
//        4. If no allergens are detected, provide a regular recipe with step-by-step instructions.
//        5. If the image is unclear or does not show food or ingredients, respond with "The image is not clear. Please provide a clearer image."
//        6. Ensure the final recipe is completely safe for individuals with the specified allergies.
//        """
//
//
//
//        Task {
//            do {
//                let response = try await model.generateContent(prompt, uiImage)
//
//                if let text = response.text {
//                    print("Response: \(text)")
//                    self.analyzedResult = text
//                    self.isAnalyzing.toggle()
//                    self.showResultView = true
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//}

/// this main
///
///
//import SwiftUI
//import PhotosUI
//import GoogleGenerativeAI
//import UIKit
//
//
//
//
//struct MealImageToRecipeView: View {
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var selectedImage: Image?
//    @State private var analyzedResult: String?
//    @State private var isAnalyzing: Bool = false
//    @State private var isShowingCamera = false
//    @State private var allergies: [String] = []
//    @State private var showResultView = false
//    @State private var isActionSheetPresented = false
////    @Binding var selectedAllergies: Set<String>
//    
//    let allergyOptions = ["Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]
//
//    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                Image("meal1") // Add your static image asset name here
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(height: 260)
//                                        
//                                        .padding(.horizontal)
//                                        .padding(.top, 0)
//                                        .shadow(radius: 3)
//                                        
//                Text("Meal to Recipe")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
//                    .padding(.top, 20)
//                
//                
//                
//                
//                Text("Upload a meal image to generate a recipe tailored to your preferences.")
//                    .font(.body)
//                    .foregroundColor(.gray)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)



//                Image("static_meal_image") // Add your static image asset name here
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(height: 200)
//                                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                                        .padding(.horizontal)
                
//                ZStack {
//                    RoundedRectangle(cornerRadius: 15)
//                        .fill(Color(.systemGray6))
//                        .frame(height: 200)
//                    
//                    if let selectedImage {
//                        selectedImage
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxWidth: .infinity, maxHeight: 200)
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                            .overlay {
//                                if isAnalyzing {
//                                    RoundedRectangle(cornerRadius: 15)
//                                        .fill(Color.black.opacity(0.5))
//                                    ProgressView()
//                                        .tint(.white)
//                                }
//                            }
//                            .padding(.horizontal)
//                    } else {
//                        VStack {
//                            Image(systemName: "photo.on.rectangle")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 60, height: 60)
//                                .foregroundColor(.gray)
//                            Text("No Image Selected")
//                                .foregroundColor(.gray)
//                                .font(.body)
//                        }
//                    }
//                }
                
//                ScrollView {
//                    Text(analyzedResult ?? (isAnalyzing ? "Analyzing..." : "Your recipe details will appear here."))
//                        .font(.callout)
//                        .foregroundColor(.primary)
//                        .padding()
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color(.systemGray6))
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                        .padding(.horizontal)
//                }
                
//                NavigationLink(destination: AllergyView()){
//                    Label("Choose Image", systemImage: "square.and.arrow.up")
//                        .frame(maxWidth: 200, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
                

//this
//                NavigationLink(destination: AllergyView()) {
//                                Label("Choose Image", systemImage: "square.and.arrow.up")
//                                    .frame(maxWidth: 200, minHeight: 44)
//                                    .foregroundColor(.white)
//                                    .background(Color(red: 79 / 255, green: 143 / 255, blue: 0 / 255))
//                                    .clipShape(RoundedRectangle(cornerRadius: 15))
//                            }
//                            .onTapGesture {
//                                isActionSheetPresented = true
//                            }
//                            .sheet(isPresented: $isActionSheetPresented) {
//                                ActionSheetContent(isShowingCamera: $isShowingCamera, selectedItem: $selectedItem, selectedImage: $selectedImage)
//                            }
//                        }





                
//                HStack {
//                    PhotosPicker(selection: $selectedItem, matching: .images) {
//                        Label("Select Photo", systemImage: "photo")
//                            .frame(maxWidth: .infinity, minHeight: 44)
//                            .foregroundColor(.white)
//                            .background(Color.indigo)
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                    }
//                    
//                    Button(action: {
//                        isShowingCamera = true
//                    }) {
//                        Label("Capture Photo", systemImage: "camera")
//                            .frame(maxWidth: .infinity, minHeight: 44)
//                            .foregroundColor(.white)
//                            .background(Color.blue)
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                    }
//                    .sheet(isPresented: $isShowingCamera) {
//                        ImagePicker(sourceType: .camera) { image in
//                            if let image = image {
//                                selectedImage = Image(uiImage: image)
//                                analyze(uiImage: image)
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top,40)
                
//                VStack {
//                    Text("Select Allergies")
//                        .font(.headline)
//                        .padding(.vertical, 10)
//                    
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack {
//                            ForEach(allergyOptions, id: \.self) { allergy in
//                                Button(action: {
//                                    if allergies.contains(allergy) {
//                                        allergies.removeAll { $0 == allergy }
//                                    } else {
//                                        allergies.append(allergy)
//                                    }
//                                }) {
//                                    Text(allergy)
//                                        .padding(.horizontal, 10)
//                                        .padding(.vertical, 8)
//                                        .background(allergies.contains(allergy) ? Color.blue : Color.gray)
//                                        .foregroundColor(.white)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                }
//                            }
//                        }
//                        .padding()
//                    }
//                    .background(Color(.systemGray6))
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//                    .padding(.horizontal)
//


///this main till end}
//            }
//            .padding()
//            .onChange(of: selectedItem) { oldItem, newItem in
//                Task {
//                    if let image = try? await newItem?.loadTransferable(type: Image.self) {
//                        selectedImage = image
//                        if let uiImage = image.asUIImage() {
//                            analyze(uiImage: uiImage)
//                        }
//                    }
//                }
//            }
//            .sheet(isPresented: $showResultView) {
//                if let result = analyzedResult, let image = selectedImage {
//                    ResultView(result: result, image: image)
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//    }
//
//    @MainActor func analyze(uiImage: UIImage) {
//        self.analyzedResult = nil
//        self.isAnalyzing.toggle()
//
//        let prompt = """
//        Analyze the provided image and complete the following tasks:
//        1. Identify the ingredient(s) shown in the image.
//        2. Check if any of the identified ingredients match the following allergies: \(allergies.joined(separator: ", ")).
//        3. If any ingredient matches an allergy, automatically suggest suitable substitutions and provide an allergy-free recipe.
//        4. If no allergens are detected, provide a regular recipe with step-by-step instructions.
//        5. If the image is unclear or does not show food or ingredients, respond with "The image is not clear. Please provide a clearer image."
//        6. Ensure the final recipe is completely safe for individuals with the specified allergies.
//        """
//
//        Task {
//            do {
//                let response = try await model.generateContent(prompt, uiImage)
//
//                if let text = response.text {
//                    self.analyzedResult = text
//                    self.isAnalyzing.toggle()
//                    self.showResultView = true
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
//
////#Preview {
////    MealImageToRecipeView()
////}
//
//
//struct ResultView: View {
//    let result: String
//    let image: Image
//
//    var body: some View {
//        VStack {
//            image
//                .resizable()
//                .scaledToFit()
//                .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                .padding()
//
//            ScrollView {
//                Text(result)
//                    .padding()
//            }
//            .navigationTitle("Generated Recipe")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//struct ImagePicker: UIViewControllerRepresentable {
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    var completion: (UIImage?) -> Void
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            picker.dismiss(animated: true)
//            parent.completion(info[.originalImage] as? UIImage)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//            parent.completion(nil)
//        }
//    }
//}
//struct ActionSheetContent: View {
//    @Binding var isShowingCamera: Bool
//    @Binding var selectedItem: PhotosPickerItem?
//    @Binding var selectedImage: Image?
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            HStack(spacing: 20) {
//                PhotosPicker(selection: $selectedItem, matching: .images) {
//                    Label("Select Photo", systemImage: "photo")
//                        .frame(maxWidth: .infinity, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color.indigo)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//                
//                Button(action: {
//                    isShowingCamera = true
//                }) {
//                    Label("Capture Photo", systemImage: "camera")
//                        .frame(maxWidth: .infinity, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//                .sheet(isPresented: $isShowingCamera) {
//                    ImagePicker(sourceType: .camera) { image in
//                        if let image = image {
//                            selectedImage = Image(uiImage: image)
//                        }
//                    }
//                }
//            }
//            
//            // Optionally display the selected image
//            if let selectedImage = selectedImage {
//                selectedImage
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 200)
//                    .padding()
//            }
//            
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//extension Image {
//    func asUIImage() -> UIImage? {
//        let controller = UIHostingController(rootView: self)
//        let view = controller.view
//
//        let targetSize = controller.view.intrinsicContentSize
//        view?.bounds = CGRect(origin: .zero, size: targetSize)
//        view?.backgroundColor = .clear
//
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        return renderer.image { _ in
//            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//}
//

//import PhotosUI
//import SwiftUI
//import GoogleGenerativeAI
//import UIKit
//
//struct MealImageToRecipeView: View {
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var selectedImage: Image?
//    @State private var analyzedResult: String?
//    @State private var isAnalyzing: Bool = false
//    @State private var isShowingCamera = false
//    @State private var allergies: [String] = []
//    @State private var showResultView = false
//    @State private var isActionSheetPresented = false
//
//    let allergyOptions = ["Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]
//
//    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                Image("meal1") // Add your static image asset name here
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 260)
//                    .padding(.horizontal)
//                    .padding(.top, 0)
//                    .shadow(radius: 3)
//
//                Text("Meal to Recipe")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
//                    .padding(.top, 20)
//
//                Text("Upload a meal image to generate a recipe tailored to your preferences.")
//                    .font(.body)
//                    .foregroundColor(.gray)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//
//                Button(action: {
//                    isActionSheetPresented = true
//                }) {
//                    Label("Choose Image", systemImage: "square.and.arrow.up")
//                        .frame(maxWidth: 200, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color(red: 79 / 255, green: 143 / 255, blue: 0 / 255))
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//                .fullScreenCover(isPresented: $isActionSheetPresented) {
//                    ActionSheetContent(isShowingCamera: $isShowingCamera, selectedItem: $selectedItem, selectedImage: $selectedImage)
//                }
//
//                Spacer()
//            }
//            .padding()
//            .onChange(of: selectedItem) { oldItem, newItem in
//                Task {
//                    if let image = try? await newItem?.loadTransferable(type: Image.self) {
//                        selectedImage = image
//                        if let uiImage = image.asUIImage() {
//                            analyze(uiImage: uiImage)
//                        }
//                    }
//                }
//            }
//            .sheet(isPresented: $showResultView) {
//                if let result = analyzedResult, let image = selectedImage {
//                    ResultView(result: result, image: image)
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//    }
//
//    @MainActor func analyze(uiImage: UIImage) {
//        self.analyzedResult = nil
//        self.isAnalyzing.toggle()
//
//        let prompt = """
//        Analyze the provided image and complete the following tasks:
//        1. Identify the ingredient(s) shown in the image.
//        2. Check if any of the identified ingredients match the following allergies: \(allergies.joined(separator: ", ")).
//        3. If any ingredient matches an allergy, automatically suggest suitable substitutions and provide an allergy-free recipe.
//        4. If no allergens are detected, provide a regular recipe with step-by-step instructions.
//        5. If the image is unclear or does not show food or ingredients, respond with "The image is not clear. Please provide a clearer image."
//        6. Ensure the final recipe is completely safe for individuals with the specified allergies.
//        """
//
//        Task {
//            do {
//                let response = try await model.generateContent(prompt, uiImage)
//
//                if let text = response.text {
//                    self.analyzedResult = text
//                    self.isAnalyzing.toggle()
//                    self.showResultView = true
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
//
//struct ResultView: View {
//    let result: String
//    let image: Image
//
//    var body: some View {
//        VStack {
//            image
//                .resizable()
//                .scaledToFit()
//                .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                .padding()
//
//            ScrollView {
//                Text(result)
//                    .padding()
//            }
//            .navigationTitle("Generated Recipe")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//struct ImagePicker: UIViewControllerRepresentable {
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    var completion: (UIImage?) -> Void
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            picker.dismiss(animated: true)
//            parent.completion(info[.originalImage] as? UIImage)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//            parent.completion(nil)
//        }
//    }
//}
//
//struct ActionSheetContent: View {
//    @Binding var isShowingCamera: Bool
//    @Binding var selectedItem: PhotosPickerItem?
//    @Binding var selectedImage: Image?
//
//    var body: some View {
//        VStack(spacing: 20) {
//            HStack(spacing: 20) {
//                PhotosPicker(selection: $selectedItem, matching: .images) {
//                    Label("Select Photo", systemImage: "photo")
//                        .frame(maxWidth: .infinity, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color.indigo)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//
//                Button(action: {
//                    isShowingCamera = true
//                }) {
//                    Label("Capture Photo", systemImage: "camera")
//                        .frame(maxWidth: .infinity, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//                .sheet(isPresented: $isShowingCamera) {
//                    ImagePicker(sourceType: .camera) { image in
//                        if let image = image {
//                            selectedImage = Image(uiImage: image)
//                        }
//                    }
//                }
//            }
//
//            // Optionally display the selected image
//            if let selectedImage = selectedImage {
//                selectedImage
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 200)
//                    .padding()
//            }
//
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//extension Image {
//    func asUIImage() -> UIImage? {
//        let controller = UIHostingController(rootView: self)
//        let view = controller.view
//
//        let targetSize = controller.view.intrinsicContentSize
//        view?.bounds = CGRect(origin: .zero, size: targetSize)
//        view?.backgroundColor = .clear
//
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        return renderer.image { _ in
//            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//}





//import PhotosUI
//import SwiftUI
//import GoogleGenerativeAI
//import UIKit
//
//struct MealImageToRecipeView: View {
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var selectedImage: UIImage?
//    @State private var analyzedResult: String?
//    @State private var isAnalyzing: Bool = false
//    @State private var isShowingCamera = false
//    @State private var allergies: [String] = []
//    @State private var showResultView = false
//    @State private var isActionSheetPresented = false
//    @StateObject var viewModel = FirestoreManager()
//    @StateObject var userviewModel = UserViewModel()
//        
//
//    let allergyOptions = ["Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]
//
//    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                if let selectedImage = selectedImage {
//                    Image(uiImage: selectedImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 260)
//                        .padding(.horizontal)
//                        .shadow(radius: 3)
//                } else {
//                    Image("meal1") // Add your static image asset name here
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 260)
//                        .padding(.horizontal)
//                        .shadow(radius: 3)
//                }
//
//                Text("Meal to Recipe")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
//                    .padding(.top, 20)
//
//                Text("Upload a meal image to generate a recipe tailored to your preferences.")
//                    .font(.body)
//                    .foregroundColor(.gray)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//
//                Button(action: {
//                    isActionSheetPresented = true
//                }) {
//                    Label("Choose Image", systemImage: "square.and.arrow.up")
//                        .frame(maxWidth: 200, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color.green)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//
//                Spacer()
//            }
//            .padding()
//            .onChange(of: selectedImage) { _ in
//                if let uiImage = selectedImage {
//                    analyze(uiImage: uiImage)
//                }
//            }
//            .onChange(of: selectedItem) { _ in
//                Task {
//                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
//                       let uiImage = UIImage(data: data) {
//                        selectedImage = uiImage
//                        analyze(uiImage: uiImage)
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $isActionSheetPresented) {
//                ActionSheetContent(
//                    isShowingCamera: $isShowingCamera,
//                    selectedItem: $selectedItem,
//                    selectedImage: $selectedImage
//                )
//            }
//            .sheet(isPresented: $showResultView) {
//                if let result = analyzedResult, let image = selectedImage {
//                    ResultView(result: result, image: Image(uiImage: image))
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            userviewModel.fetchUser()
//            if let userID = userviewModel.user?.id {
//                viewModel.fetchUserAllergies(userID: userID)
//            } else {
//                print("User ID is nil, okok")
//            }
//        }
//
//    }
//    
//
//    @MainActor func analyze(uiImage: UIImage) {
//        analyzedResult = nil
//        isAnalyzing = true
//
//        let prompt = """
//        Analyze the provided image and complete the following tasks:
//        1. Identify the ingredient(s) shown in the image.
//        2. Check if any of the identified ingredients match the following allergies: \(FirestoreManager.userSavedAllergies.joined(separator: ", ")).
//        3. If any ingredient matches an allergy, automatically suggest suitable substitutions and provide an allergy-free recipe.
//        4. If no allergens are detected, provide a regular recipe with step-by-step instructions.
//        5. If the image is unclear or does not show food or ingredients, respond with "The image is not clear. Please provide a clearer image."
//        6. Ensure the final recipe is completely safe for individuals with the specified allergies.
//        """
//
//        Task {
//            do {
//                let response = try await model.generateContent(prompt, uiImage)
//                print(prompt)
//                if let text = response.text {
//                    analyzedResult = text
//                    isAnalyzing = false
//                    showResultView = true
//                }
//            } catch {
//                print("Error analyzing image: \(error)")
//                isAnalyzing = false
//            }
//        }
//    }
//        
//}
//
//struct ResultView: View {
//    let result: String
//    let image: Image
//
//    var body: some View {
//        VStack {
//            image
//                .resizable()
//                .scaledToFit()
//                .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                .padding()
//
//            ScrollView {
//                Text(result)
//                    .padding()
//            }
//            .navigationTitle("Generated Recipe")
//            .navigationBarTitleDisplayMode(.inline)
//        
//        }
//    }
//}
//
//
//
//struct ActionSheetContent: View {
//    @Binding var isShowingCamera: Bool
//    @Binding var selectedItem: PhotosPickerItem?
//    @Binding var selectedImage: UIImage?
//    @State private var showErrorAlert: Bool = false
//    @State private var errorMessage: String = ""
//
//    var body: some View {
//        VStack(spacing: 20) {
//            HStack(spacing: 20) {
//                // Photo Library Picker
//                PhotosPicker(selection: $selectedItem, matching: .images) {
//                    Label("Select Photo", systemImage: "photo")
//                        .frame(maxWidth: .infinity, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color.indigo)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//                .onChange(of: selectedItem) { _ in
//                    handlePhotoLibrarySelection()
//                }
//
//                // Camera Picker
//                Button(action: {
//                    isShowingCamera = true
//                }) {
//                    Label("Capture Photo", systemImage: "camera")
//                        .frame(maxWidth: .infinity, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//                .sheet(isPresented: $isShowingCamera) {
//                    ImagePicker(sourceType: .camera) { image in
//                        if let image = image {
//                            selectedImage = image
//                        } else {
//                            showError(message: "Failed to capture photo.")
//                        }
//                    }
//                }
//            }
//
//            Spacer()
//        }
//        .padding()
//        .alert(isPresented: $showErrorAlert) {
//            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
//        }
//    }
//
//    private func handlePhotoLibrarySelection() {
//        Task {
//            do {
//                if let selectedItem = selectedItem,
//                   let data = try await selectedItem.loadTransferable(type: Data.self),
//                   let uiImage = UIImage(data: data) {
//                    selectedImage = uiImage
//                } else {
//                    showError(message: "Failed to load the selected image.")
//                }
//            } catch {
//                showError(message: "Error loading image: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    private func showError(message: String) {
//        errorMessage = message
//        showErrorAlert = true
//    }
//}
//
//
//
//struct ImagePicker: UIViewControllerRepresentable {
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    var completion: (UIImage?) -> Void
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            picker.dismiss(animated: true)
//            parent.completion(info[.originalImage] as? UIImage)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//            parent.completion(nil)
//        }
//    }
//}
//
//extension Image {
//    func asUIImage() -> UIImage? {
//        let controller = UIHostingController(rootView: self)
//        let view = controller.view
//        
//        let targetSize = controller.view.intrinsicContentSize
//        view?.bounds = CGRect(origin: .zero, size: targetSize)
//        view?.backgroundColor = .clear
//        
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        return renderer.image { _ in
//            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
    
//import PhotosUI
//import SwiftUI
//import GoogleGenerativeAI
//import UIKit
//
//struct MealImageToRecipeView: View {
//    @State private var selectedItem: PhotosPickerItem?
//    @State private var selectedImage: UIImage?
//    @State private var analyzedResult: String?
//    @State private var isAnalyzing: Bool = false
//    @State private var isShowingCamera = false
//    @State private var allergies: [String] = []
//    @State private var showResultView = false
//    @State private var isActionSheetPresented = false
//    @StateObject var viewModel = FirestoreManager()
//    @StateObject var userviewModel = UserViewModel()
//    @State private var isAllergiesFetched = false // New state to track allergies fetch status
//
//
//    let allergyOptions = ["Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]
//
//    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                if let selectedImage = selectedImage {
//                    Image(uiImage: selectedImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 260)
//                        .padding(.horizontal)
//                        .shadow(radius: 3)
//                } else {
//                    Image("meal1") // Add your static image asset name here
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 260)
//                        .padding(.horizontal)
//                        .shadow(radius: 3)
//                }
//
//                Text("Meal to Recipe")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
//                    .padding(.top, 20)
//
//                Text("Upload a meal image to generate a recipe tailored to your preferences.")
//                    .font(.body)
//                    .foregroundColor(.gray)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//
//                Button(action: {
//                    isActionSheetPresented = true
//                }) {
//                    Label("Choose Image", systemImage: "square.and.arrow.up")
//                        .frame(maxWidth: 200, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color.green)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//
//                Spacer()
//            }
//            .padding()
//            .onChange(of: selectedImage) { _ in
//                if let uiImage = selectedImage {
//                    analyze(uiImage: uiImage)
//                }
//            }
//            .onChange(of: selectedItem) { _ in
//                Task {
//                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
//                       let uiImage = UIImage(data: data) {
//                        selectedImage = uiImage
//                        analyze(uiImage: uiImage)
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $isActionSheetPresented) {
//                ActionSheetContent(
//                    isShowingCamera: $isShowingCamera,
//                    selectedItem: $selectedItem,
//                    selectedImage: $selectedImage,
//                    isActionSheetPresented: $isActionSheetPresented // Binding for dismissing the action sheet
//                )
//            }
//            .sheet(isPresented: $showResultView) {
//                if let result = analyzedResult, let image = selectedImage {
//                    ResultView(result: result, image: Image(uiImage: image))
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            userviewModel.fetchUser()
//            if let userID = userviewModel.user?.id {
//                viewModel.fetchUserAllergies(userID: userID)
//            } else {
//                print("User ID is nil, okok")
//            }
//        }
//    }
//    
//
//    @MainActor func analyze(uiImage: UIImage) {
//        analyzedResult = nil
//        isAnalyzing = true
//
//        let prompt = """
//        Analyze the provided image and complete the following tasks:
//        1. Identify the ingredient(s) shown in the image.
//        2. Check if any of the identified ingredients match the following allergies: \(FirestoreManager.userSavedAllergies.joined(separator: ", ")).
//        3. If any ingredient matches an allergy, automatically suggest suitable substitutions and provide an allergy-free recipe.
//        4. If no allergens are detected, provide a regular recipe with step-by-step instructions.
//        5. If the image is unclear or does not show food or ingredients, respond with "The image is not clear. Please provide a clearer image."
//        6. Ensure the final recipe is completely safe for individuals with the specified allergies.
//        """
//
//        Task {
//            do {
//                let response = try await model.generateContent(prompt, uiImage)
//                print(prompt)
//                if let text = response.text {
//                    analyzedResult = text
//                    isAnalyzing = false
//                    showResultView = true
//                }
//            } catch {
//                print("Error analyzing image: \(error)")
//                isAnalyzing = false
//            }
//        }
//    }
//        
//}
//
//struct ResultView: View {
//    let result: String
//    let image: Image
//
//    var body: some View {
//        VStack {
//            image
//                .resizable()
//                .scaledToFit()
//                .clipShape(RoundedRectangle(cornerRadius: 20.0))
//                .padding()
//
//            ScrollView {
//                Text(result)
//                    .padding()
//            }
//            .navigationTitle("Generated Recipe")
//            .navigationBarTitleDisplayMode(.inline)
//        
//        }
//    }
//}
//
//
//
//struct ActionSheetContent: View {
//    @Binding var isShowingCamera: Bool
//    @Binding var selectedItem: PhotosPickerItem?
//    @Binding var selectedImage: UIImage?
//    @Binding var isActionSheetPresented: Bool // New binding to control the dismissal of the action sheet
//    @State private var showErrorAlert: Bool = false
//    @State private var errorMessage: String = ""
//
//    var body: some View {
//        VStack(spacing: 20) {
//            HStack(spacing: 20) {
//                // Photo Library Picker
//                PhotosPicker(selection: $selectedItem, matching: .images) {
//                    Label("Select Photo", systemImage: "photo")
//                        .frame(maxWidth: .infinity, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color.indigo)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//                .onChange(of: selectedItem) { _ in
//                    handlePhotoLibrarySelection()
//                }
//
//                // Camera Picker
//                Button(action: {
//                    isShowingCamera = true
//                }) {
//                    Label("Capture Photo", systemImage: "camera")
//                        .frame(maxWidth: .infinity, minHeight: 44)
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//                .sheet(isPresented: $isShowingCamera) {
//                    ImagePicker(sourceType: .camera) { image in
//                        if let image = image {
//                            selectedImage = image
//                            isActionSheetPresented = false // Dismiss the action sheet when a photo is captured
//                        } else {
//                            showError(message: "Failed to capture photo.")
//                        }
//                    }
//                }
//            }
//
//            Spacer()
//        }
//        .padding()
//        .alert(isPresented: $showErrorAlert) {
//            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
//        }
//    }
//
//    private func handlePhotoLibrarySelection() {
//        Task {
//            do {
//                if let selectedItem = selectedItem,
//                   let data = try await selectedItem.loadTransferable(type: Data.self),
//                   let uiImage = UIImage(data: data) {
//                    selectedImage = uiImage
//                    isActionSheetPresented = false // Dismiss the action sheet after selecting the image
//                } else {
//                    showError(message: "Failed to load the selected image.")
//                }
//            } catch {
//                showError(message: "Error loading image: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    private func showError(message: String) {
//        errorMessage = message
//        showErrorAlert = true
//    }
//}
//
//
//
//struct ImagePicker: UIViewControllerRepresentable {
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    var completion: (UIImage?) -> Void
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            picker.dismiss(animated: true)
//            parent.completion(info[.originalImage] as? UIImage)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//            parent.completion(nil)
//        }
//    }
//}
//
//extension Image {
//    func asUIImage() -> UIImage? {
//        let controller = UIHostingController(rootView: self)
//        let view = controller.view
//        
//        let targetSize = controller.view.intrinsicContentSize
//        view?.bounds = CGRect(origin: .zero, size: targetSize)
//        view?.backgroundColor = .clear
//        
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        return renderer.image { _ in
//            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//}



//import SwiftUI
//import PhotosUI
//import GoogleGenerativeAI
//import UIKit
//
//struct AllergySelectionView: View {
//    @State private var selectedAllergies: [String] = []
//    @State private var proceed = false
//
//    let allergyOptions = ["Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]
//
//    var body: some View {
//        VStack {
//            Text("Select Allergies")
//                .font(.largeTitle)
//                .padding(.top, 20)
//
//            ScrollView {
//                LazyVGrid(columns: [
//                    GridItem(.fixed(150), spacing: 20),  // Fixed width for each item
//                    GridItem(.fixed(150), spacing: 20)   // Fixed width for each item
//                ], spacing: 20) {
//                    ForEach(allergyOptions, id: \.self) { allergy in
//                        Button(action: {
//                            if selectedAllergies.contains(allergy) {
//                                selectedAllergies.removeAll { $0 == allergy }
//                            } else {
//                                selectedAllergies.append(allergy)
//                            }
//                        }) {
//                            Text(allergy)
//                                .padding()
//                                .frame(maxWidth: .infinity, maxHeight: 200)  // Adjusted height
//                                .background(selectedAllergies.contains(allergy) ? Color.blue : Color.gray)
//                                .foregroundColor(.white)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                        }
//                    }
//                }
//                .padding()
//            }
//
//            Button(action: {
//                proceed = true
//            }) {
//                Text("Next")
//                    .bold()
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.indigo)
//                    .foregroundColor(.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//            }
//            .padding()
//            .fullScreenCover(isPresented: $proceed) {
//                MealImageToRecipeView(allergies: selectedAllergies)
//            }
//        }
//        .padding()
//    }
//}
//
//
//struct MealImageToRecipeView: View {
//    @State private var selectedImage: Image?
//    @State private var analyzedResult: String?
//    @State private var isAnalyzing = false
//    @State private var showImagePicker = false
//    @State private var showCameraPicker = false
//
//    @State private var showActionSheet = false
//    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
//    let allergies: [String]
//
//    var body: some View {
//        NavigationView { // Added NavigationView
//            VStack {
//                Text("Upload a Meal Image")
//                    .font(.largeTitle)
//                    .padding()
//
//                if let selectedImage {
//                    selectedImage
//                        .resizable()
//                        .scaledToFit()
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                        .padding()
//
//                    if isAnalyzing {
//                        ProgressView("Analyzing...")
//                            .padding()
//                    }
//                } else {
//                    Button(action: {
//                        showActionSheet = true
//                    }) {
//                        Text("Get Started")
//                            .bold()
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.indigo)
//                            .foregroundColor(.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                    }
//                    .padding()
//                }
//
//                if let analyzedResult {
//                    NavigationLink(destination: ResultView(result: analyzedResult, image: selectedImage)) {
//                        Text("View Recipe")
//                            .bold()
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                    }
//                    .padding()
//                }
//            }
//            .padding()
//            .actionSheet(isPresented: $showActionSheet) {
//                ActionSheet(title: Text("Select Image"), buttons: [
//                    .default(Text("Photo Library")) {
//                        showImagePicker = true
//                    },
//                    .default(Text("Capture Photo")) {
//                        showCameraPicker = true
//                    },
//                    .cancel()
//                ])
//            }
//            .sheet(isPresented: $showImagePicker) {
//                ImagePicker(sourceType: .photoLibrary) { image in
//                    if let image = image {
//                        selectedImage = Image(uiImage: image)
//                        analyze(uiImage: image)
//                    }
//                }
//            }
//            .sheet(isPresented: $showCameraPicker) {
//                ImagePicker(sourceType: .camera) { image in
//                    if let image = image {
//                        selectedImage = Image(uiImage: image)
//                        analyze(uiImage: image)
//                    }
//                }
//            }
//        }
//    }
//
//    @MainActor private func analyze(uiImage: UIImage) {
//        analyzedResult = nil
//        isAnalyzing = true
//
//        let prompt = """
//        Analyze the provided image and complete the following tasks:
//        1. Identify the ingredient(s) shown in the image.
//        2. Check if any of the identified ingredients match the following allergies: \(allergies.joined(separator: ", ")).
//        3. If any ingredient matches an allergy, automatically suggest suitable substitutions and provide an allergy-free recipe.
//        4. If no allergens are detected, provide a regular recipe with step-by-step instructions.
//        5. If the image is unclear or does not show food or ingredients, respond with \"The image is not clear. Please provide a clearer image.\"
//        6. Ensure the final recipe is completely safe for individuals with the specified allergies.
//        """
//
//        Task {
//            do {
//                let response = try await model.generateContent(prompt, uiImage)
//                print(prompt)
//                if let text = response.text {
//                    analyzedResult = text
//                    isAnalyzing = false
//                }
//            } catch {
//                print("Error analyzing image: \(error)")
//                isAnalyzing = false
//            }
//        }
//    }
//}
//
//
//struct ResultView: View {
//    let result: String
//    let image: Image?
//
//    var body: some View {
//        VStack {
//            if let image {
//                image
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    .padding()
//            }
//
//            ScrollView {
//                Text(result)
//                    .padding()
//            }
//        }
//        .navigationTitle("Generated Recipe")
//    }
//}
//
//struct ImagePicker: UIViewControllerRepresentable {
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    var completion: (UIImage?) -> Void
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            picker.dismiss(animated: true)
//            parent.completion(info[.originalImage] as? UIImage)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//            parent.completion(nil)
//        }
//    }
//}
//import SwiftUI
//import PhotosUI
//import GoogleGenerativeAI
//import UIKit
//
//struct AllergySelectionView: View {
//    @State private var selectedAllergies: Set<String> = [] // Stores selected allergies
//    @State private var proceed = false
//    @State private var searchText = ""  // For search functionality
//
//    let allergyOptions = [" Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]
//
//    var filteredAllergies: [String] {
//        if searchText.isEmpty {
//            return allergyOptions
//        } else {
//            return allergyOptions.filter { $0.lowercased().contains(searchText.lowercased()) }
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    ForEach(filteredAllergies, id: \.self) { allergy in
//                        AllergySelectionRow(allergy: allergy, isSelected: selectedAllergies.contains(allergy), selectedAllergies: $selectedAllergies)
//                            .padding()
//                    }
//                }
//                .searchable(text: $searchText) // Add search bar
//
//                Button(action: {
//                    proceed = true
//                }) {
//                    Text("Next")
//                        .bold()
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.indigo)
//                        .foregroundColor(.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                }
//                .padding()
//                .fullScreenCover(isPresented: $proceed) {
//                    MealImageToRecipeView(allergies: Array(selectedAllergies))
//                }
//            }
//            .navigationTitle("Choose Your Allergies")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(
//                        destination: MainView(), // Replace with your target view
//                        isActive: $proceed
//                    ) {
//                        Button("Done") {
//                            proceed = true
//                        }
//                        .foregroundColor(Color.green)
//                        .disabled(selectedAllergies.isEmpty) // Disable button if no allergies are selected
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct AllergySelectionRow: View {
//    let allergy: String
//    var isSelected: Bool
//    @Binding var selectedAllergies: Set<String> // Binding to the set of selected allergies
//
//    var body: some View {
//        Button(action: {
//            if isSelected {
//                selectedAllergies.remove(allergy)
//            } else {
//                selectedAllergies.insert(allergy)
//            }
//        }) {
//            HStack {
//                Text(allergy)
//                    .padding()
//                Spacer()
//                if isSelected {
//                    Image(systemName: "checkmark.circle.fill")
//                        .foregroundColor(.green)
//                } else {
//                    Image(systemName: "circle")
//                        .foregroundColor(.gray)
//                }
//            }
////            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//            .padding([.top, .bottom], 5)
//        }
//    }
//}
//
//struct MealImageToRecipeView: View {
//    @State private var selectedImage: Image?
//    @State private var analyzedResult: String?
//    @State private var isAnalyzing = false
//    @State private var showImagePicker = false
//    @State private var showCameraPicker = false
//    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
//    let allergies: [String]
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Upload a Meal Image")
//                    .font(.largeTitle)
//                    .padding()
//
//                if let selectedImage {
//                    selectedImage
//                        .resizable()
//                        .scaledToFit()
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                        .padding()
//
//                    if isAnalyzing {
//                        ProgressView("Analyzing...")
//                            .padding()
//                    }
//                } else {
//                    Button(action: {
//                        showImagePicker = true
//                    }) {
//                        Text("Get Started")
//                            .bold()
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.indigo)
//                            .foregroundColor(.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                    }
//                    .padding()
//                }
//
//                if let analyzedResult {
//                    NavigationLink(destination: ResultView(result: analyzedResult, image: selectedImage)) {
//                        Text("View Recipe")
//                            .bold()
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.green)
//                            .foregroundColor(.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                    }
//                    .padding()
//                }
//            }
//            .padding()
//            .sheet(isPresented: $showImagePicker) {
//                ImagePicker(sourceType: .photoLibrary) { image in
//                    if let image = image {
//                        selectedImage = Image(uiImage: image)
//                        analyze(uiImage: image)
//                    }
//                }
//            }
//            .sheet(isPresented: $showCameraPicker) {
//                ImagePicker(sourceType: .camera) { image in
//                    if let image = image {
//                        selectedImage = Image(uiImage: image)
//                        analyze(uiImage: image)
//                    }
//                }
//            }
//        }
//    }
//
//    @MainActor private func analyze(uiImage: UIImage) {
//        analyzedResult = nil
//        isAnalyzing = true
//
//        let prompt = """
//        Analyze the provided image and complete the following tasks:
//        1. Identify the ingredient(s) shown in the image.
//        2. Check if any of the identified ingredients match the following allergies: \(allergies.joined(separator: ", ")).
//        3. If any ingredient matches an allergy, automatically suggest suitable substitutions and provide an allergy-free recipe.
//        4. If no allergens are detected, provide a regular recipe with step-by-step instructions.
//        5. If the image is unclear or does not show food or ingredients, respond with "The image is not clear. Please provide a clearer image."
//        6. Ensure the final recipe is completely safe for individuals with the specified allergies.
//        """
//
//        Task {
//            do {
//                let response = try await model.generateContent(prompt, uiImage)
//                print(prompt)
//                if let text = response.text {
//                    analyzedResult = text
//                    isAnalyzing = false
//                }
//            } catch {
//                print("Error analyzing image: \(error)")
//                isAnalyzing = false
//            }
//        }
//    }
//}
//
//struct ResultView: View {
//    let result: String
//    let image: Image?
//
//    var body: some View {
//        VStack {
//            if let image {
//                image
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    .padding()
//            }
//
//            ScrollView {
//                Text(result)
//                    .padding()
//            }
//        }
//        .navigationTitle("Generated Recipe")
//    }
//}
//
//struct ImagePicker: UIViewControllerRepresentable {
//    var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    var completion: (UIImage?) -> Void
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            picker.dismiss(animated: true)
//            parent.completion(info[.originalImage] as? UIImage)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//            parent.completion(nil)
//        }
//    }
//}
//
//extension Image {
//    func asUIImage() -> UIImage? {
//        let controller = UIHostingController(rootView: self)
//        let view = controller.view
//
//        let targetSize = controller.view.intrinsicContentSize
//        view?.bounds = CGRect(origin: .zero, size: targetSize)
//        view?.backgroundColor = .clear
//
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        return renderer.image { _ in
//            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//}

//@main
//struct MyApp: App {
//    var body: some Scene {
//        WindowGroup {
//            AllergySelectionView()
//        }
//    }
//}


import SwiftUI
import PhotosUI
import GoogleGenerativeAI
import UIKit

//struct AllergySelectionView: View {
//    
//    @State private var selectedAllergies: Set<String> = [] // Stores selected allergies
//    @State private var proceed = false
//    @State private var searchText = ""  // For search functionality
//    @State private var showActionSheet = false // State for showing the action sheet
//
//    let allergyOptions = [" Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]
//
//    var filteredAllergies: [String] {
//        if searchText.isEmpty {
//            return allergyOptions
//        } else {
//            return allergyOptions.filter { $0.lowercased().contains(searchText.lowercased()) }
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    ForEach(filteredAllergies, id: \.self) { allergy in
//                        AllergySelectionRow(allergy: allergy, isSelected: selectedAllergies.contains(allergy), selectedAllergies: $selectedAllergies)
//                            .padding()
//                    }
//                }
//                .searchable(text: $searchText) // Add search bar
//
//                Button(action: {
//                    proceed = true
//                }) {
////                    Text("Next")
////                        .bold()
////                        .padding()
////                        .frame(maxWidth: .infinity)
////                        .background(Color.indigo)
////                        .foregroundColor(.white)
////                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                }
//                .padding()
//                .fullScreenCover(isPresented: $proceed) {
//                    MealImageToRecipeView(allergies: Array(selectedAllergies))
//                }
//            }
//            .navigationTitle("Choose Your Allergies")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(
//                        destination: MainView(), // Replace with your target view
//                        isActive: $proceed
//                    ) {
//                        Button("Done") {
//                            proceed=true
//                        }
//                        .foregroundColor(Color.green)
//                        .disabled(selectedAllergies.isEmpty) // Disable button if no allergies are selected
//                    }
//                }
//            }
//        }.navigationBarBackButtonHidden(true)
//    }
//}

import SwiftUI

import SwiftUI

struct AllergySelectionView: View {
    @State private var selectedAllergies: Set<String> = [] // Stores selected allergies
    @State private var proceed = false
    @State private var searchText = "" // For search functionality
    @State private var showActionSheet = false // State for showing the action sheet
    @State private var navigateToAIRecipeView = false // State for navigation to AIRecipeView

    let allergyOptions = ["Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]

    var filteredAllergies: [String] {
        if searchText.isEmpty {
            return allergyOptions
        } else {
            return allergyOptions.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(filteredAllergies, id: \.self) { allergy in
                        AllergySelectionRow(
                            allergy: allergy,
                            isSelected: selectedAllergies.contains(allergy),
                            selectedAllergies: $selectedAllergies
                        )
                        .padding()
                    }
                }
                .searchable(text: $searchText) // Add search bar

                Button(action: {
                    proceed = true
                }) {
                    // Placeholder for "Next" button, if needed
                }
                .padding()
                .fullScreenCover(isPresented: $proceed) {
                    MealImageToRecipeView(allergies: Array(selectedAllergies))
                }
            }
            .navigationTitle("Choose Your Allergies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        proceed = true
                    }
                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                    .disabled(selectedAllergies.isEmpty) // Disable button if no allergies are selected
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(
                        destination: AIRecipeView(), // Navigate to AIRecipeView
                        isActive: $navigateToAIRecipeView
                    ) {
                        Button(action: {
                            navigateToAIRecipeView = true // Trigger navigation
                        }) {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Home")
                            }
                            .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



struct AllergySelectionRow: View {
    let allergy: String
    var isSelected: Bool
    @Binding var selectedAllergies: Set<String> // Binding to the set of selected allergies

    var body: some View {
        Button(action: {
            if isSelected {
                selectedAllergies.remove(allergy)
            } else {
                selectedAllergies.insert(allergy)
            }
        }) {
            HStack {
                Text(allergy)
                    .padding()
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                }
            }
            .padding([.top, .bottom], 5)
        }
    }
}


import SwiftUI
import PhotosUI
import GoogleGenerativeAI
import UIKit

struct MealImageToRecipeView: View {
    @State private var selectedImage: Image?
    @State private var analyzedResult: String?
    @State private var isAnalyzing = false
    @State private var showImagePicker = false
    @State private var showCameraPicker = false
    @State private var showActionSheet = false // State for action sheet
    @Environment(\.presentationMode) var presentationMode // To handle navigation back
    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    let allergies: [String]

    var body: some View {
        NavigationView {
            VStack {
                Text("Upload a Meal Image")
                    .font(.largeTitle)
                    .padding()

                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()

                    if isAnalyzing {
                        ProgressView("Analyzing...")
                            .padding()
                    }
                } else {
                    Button(action: {
                        showActionSheet = true // Show action sheet when the button is tapped
                    }) {
                        Text("Get Started")
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 79/255, green: 143/255, blue: 0/255))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding()
                }

                if let analyzedResult {
                    NavigationLink(destination: ResultView(result: analyzedResult, image: selectedImage)) {
                        Text("View Recipe")
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 79/255, green: 143/255, blue: 0/255))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding()
                }
            }
            .padding()
            .actionSheet(isPresented: $showActionSheet) { // ActionSheet to choose photo library or camera
                ActionSheet(
                    title: Text("Select Image Source"),
                    buttons: [
                        .default(Text("Photo Library")) {
                            showImagePicker = true
                        },
                        .default(Text("Camera")) {
                            showCameraPicker = true
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    if let image = image {
                        selectedImage = Image(uiImage: image)
                        analyze(uiImage: image)
                    }
                }
            }
            .sheet(isPresented: $showCameraPicker) {
                ImagePicker(sourceType: .camera) { image in
                    if let image = image {
                        selectedImage = Image(uiImage: image)
                        analyze(uiImage: image)
                    }
                }
            }
            .navigationBarTitle("Meal to Recipe", displayMode: .inline) // Set navigation bar title
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss() // Navigate back
            }) {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }
                .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
            })
        }
    }




    @MainActor private func analyze(uiImage: UIImage) {
        analyzedResult = nil
        isAnalyzing = true

        let prompt = """
        Analyze the provided image and complete the following tasks:
        1. Identify the ingredient(s) shown in the image.
        2. Check if any of the identified ingredients match the following allergies: \(allergies.joined(separator: ", ")).
        3. If any ingredient matches an allergy, automatically suggest suitable substitutions and provide an allergy-free recipe.
        4. If no allergens are detected, provide a regular recipe with step-by-step instructions.
        5. If the image is unclear or does not show food or ingredients, respond with "The image is not clear. Please provide a clearer image."
        6. Ensure the final recipe is completely safe for individuals with the specified allergies.
        """

        Task {
            do {
                let response = try await model.generateContent(prompt, uiImage)
                if let text = response.text {
                    analyzedResult = text
                    isAnalyzing = false
                }
            } catch {
                print("Error analyzing image: \(error)")
                isAnalyzing = false
            }
        }
    }
}

import SwiftUI

struct ResultView: View {
    let result: String
    let image: Image?

    @State private var navigateToAllergySelection = false // State to control navigation

    var body: some View {
        NavigationView {
            VStack {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding()
                }
                
                ScrollView {
                    Text(result)
                        .padding()
                }
            }
            // Hide default back button
             // Set navigation title
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: AIRecipeView(), // Target view
                        isActive: $navigateToAllergySelection
                    ) {
                        Button("Done") {
                            navigateToAllergySelection = true // Trigger navigation
                        }
                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
                    }
                }
            }
        } .navigationBarBackButtonHidden(true)
            
    }
}




struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var completion: (UIImage?) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true)
            parent.completion(info[.originalImage] as? UIImage)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
            parent.completion(nil)
        }
    }
}

extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}


//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//
//
//
//
//// View for managing allergies
//struct AllergySelectionView: View {
//    @StateObject private var firestoreManager = FirestoreManager() // Firestore manager for allergy handling
//    @StateObject private var userViewModel = UserViewModel()       // Instance of UserViewModel to get user data
//    @State private var proceed = false
//    @State private var searchText = ""
//    
//    @State private var selectedAllergies: Set<String> = [] // Stores selected allergies
//    @State private var showActionSheet = false
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if userViewModel.isLoading {
//                    ProgressView("Loading user data...") // Show loading while fetching user data
//                } else {
//                    List {
//                        ForEach(filteredAllergies, id: \.id) { allergy in
//                            AllergySelectionRow(
//                                allergy: allergy,
//                                isSelected: selectedAllergies.contains(allergy.name),
//                                selectedAllergies: $selectedAllergies
//                            )
//                            .padding()
//                        }
//                    }
//                }
//            }
//            .searchable(text: $searchText)
//            .navigationTitle("Choose Your Allergy")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(
//                        destination: MealImageToRecipeView().navigationBarBackButtonHidden(true),
//                        isActive: $proceed
//                    ) {
//                        Button("Done") {
//                            saveUserAllergies()
//                            proceed = true
//                        }
//                        .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        .disabled(userViewModel.user == nil) // Disable button until user data is loaded
//                    }
//                }
//            }
//        }
//        .onAppear {
//            firestoreManager.fetchAllergies()
//            userViewModel.fetchUser()  // Fetch user data
//            loadSavedAllergies()  // Load saved allergies for the current user
//        }
//        .onChange(of: FirestoreManager.userSavedAllergies) { savedAllergies in
//            self.selectedAllergies = Set(savedAllergies) // Update selected allergies with saved allergies
//        }
//    }
//
//    // Filter allergies based on search text
//    var filteredAllergies: [Allergy] {
//        searchText.isEmpty ? firestoreManager.allergies : firestoreManager.allergies.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//    }
//    
//    private func saveUserAllergies() {
//        if let userID = userViewModel.user?.id {
//            firestoreManager.saveUserAllergies(userID: userID, allergies: Array(selectedAllergies))
//            print("Saved allergies: \(selectedAllergies) for user ID: \(userID)")
//        } else {
//            print("Error: User ID not available.")
//        }
//    }
//    
//    private func loadSavedAllergies() {
//        if let userID = userViewModel.user?.id {
//            firestoreManager.fetchUserAllergies(userID: userID)
//            print("User ID found, fetching allergies...")
//        } else {
//            print("No user ID found to load allergies.")
//        }
//    }
//}
//
//// AllergyRow view for individual allergy items
//struct AllergySelectionRow: View {
//    let allergy: Allergy
//    let isSelected: Bool
//    @Binding var selectedAllergies: Set<String> // Use binding to update selectedAllergies
//
//    var body: some View {
//        HStack {
//            Text(allergy.symbol)
//                .font(.title)
//            Text(allergy.name)
//            Spacer()
//            if isSelected {
//                Image(systemName: "checkmark.circle")
//                    .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//            }
//        }
//        .padding(.vertical, -5)
//        .contentShape(Rectangle()) // Make the entire row tappable
//        .onTapGesture {
//            toggleSelection(for: allergy.name)
//        }
//    }
//
//    private func toggleSelection(for allergyName: String) {
//        if isSelected {
//            selectedAllergies.remove(allergyName)
//        } else {
//            selectedAllergies.insert(allergyName)
//        }
//    }
//}


// FirestoreManager for managing Firestore operations
//class FirestoreManager: ObservableObject {
//    @Published var allergies: [Allergy] = []
//    static var userSavedAllergies: [String] = [] // New variable to store user's saved allergies
//
//    private var db = Firestore.firestore()
//
//    func fetchAllergies() {
//        db.collection("allergy").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching allergies: \(error)")
//                return
//            }
//
//            guard let documents = snapshot?.documents else {
//                print("No allergy documents found")
//                return
//            }
//
//            self.allergies = documents.compactMap { document -> Allergy? in
//                let allergy = try? document.data(as: Allergy.self)
//                print("Fetched allergy:", allergy) // Debugging line
//                return allergy
//            }
//            print("All allergies fetched:", self.allergies)
//        }
//    }
//    
//    func saveUserAllergies(userID: String, allergies: [String]) {
//        let userRef = db.collection("users").document(userID)
//        
//        userRef.getDocument { (document, error) in
//            if let error = error {
//                print("Error fetching user document: \(error)")
//                return
//            }
//
//            if let document = document, document.exists {
//                // Update the existing document with allergies
//                userRef.updateData(["allergies": allergies]) { error in
//                    if let error = error {
//                        print("Error updating allergies: \(error)")
//                    } else {
//                        print("Allergies successfully updated!")
//                    }
//                }
//            } else {
//                // Document doesn't exist, create it with initial data
//                let newUser = User(id: userID, username: "defaultUsername", age: 0, email: "default@example.com", allergies: allergies)
//                do {
//                    try userRef.setData(from: newUser)
//                    print("User and allergies successfully created!")
//                } catch let error {
//                    print("Error creating user: \(error)")
//                }
//            }
//        }
//    }
//
//    // Updated function to fetch saved allergies and store them in userSavedAllergies
//    func fetchUserAllergies(userID: String) {
//        let userRef = db.collection("users").document(userID)
//        
//        userRef.getDocument { (document, error) in
//            if let error = error {
//                print("Error fetching user allergies: \(error)")
//                return
//            }
//            
//            if let document = document, let data = document.data(),
//               let allergies = data["allergies"] as? [String] {
//                FirestoreManager.userSavedAllergies = allergies // Store fetched allergies in userSavedAllergies
//            } else {
//                print("User document does not exist or allergies not found.")
//                FirestoreManager.userSavedAllergies = [] // Default to an empty list if no allergies are found
//            }
//        }
//    }
//}
