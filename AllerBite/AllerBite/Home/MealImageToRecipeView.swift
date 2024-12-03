//
//  MealImageToRecipeView.swift
//  AllerBite
//
//  Created by Aditya Gaba on 8/12/24.
//
import SwiftUI
import PhotosUI
import GoogleGenerativeAI
import UIKit

struct MealImageToRecipeView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var analyzedResult: String?
    @State private var isAnalyzing: Bool = false
    @State private var isShowingCamera = false
    @State private var allergies: [String] = []
    @State private var showResultView = false
    
    let allergyOptions = ["Peanuts", "Shellfish", "Dairy", "Eggs", "Wheat", "Soy", "Fish", "Tree Nuts"]

    let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)

    var body: some View {
        NavigationView{
            VStack {
                Text("🍕 Meal Image to Recipe")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Powered by Gemini AI :")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                Text("Upload an image of a meal to get a recipe on how to cook it.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .overlay {
                            if isAnalyzing {
                                RoundedRectangle(cornerRadius: 20.0)
                                    .fill(Color.black.opacity(0.5))
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .padding(.horizontal)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .padding(.horizontal)
                }
                
                ScrollView {
                    Text(analyzedResult ?? (isAnalyzing ? "Analyzing..." : "Select or capture a photo to get started"))
                        .font(.system(.title2, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .padding(.horizontal)
                }
                
                Spacer()
                
                HStack {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("Select Photo", systemImage: "photo")
                            .frame(maxWidth: .infinity)
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.indigo)
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    }
                    
                    Button(action: {
                        isShowingCamera = true
                    }) {
                        Label("Capture Photo", systemImage: "camera")
                            .frame(maxWidth: .infinity)
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    }
                    .sheet(isPresented: $isShowingCamera) {
                        ImagePicker(sourceType: .camera) { image in
                            if let image = image {
                                selectedImage = Image(uiImage: image)
                                analyze(uiImage: image)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack {
                    Text("Select Allergies")
                        .font(.headline)
                        .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(allergyOptions, id: \.self) { allergy in
                                Button(action: {
                                    if allergies.contains(allergy) {
                                        allergies.removeAll { $0 == allergy }
                                    } else {
                                        allergies.append(allergy)
                                    }
                                }) {
                                    Text(allergy)
                                        .padding()
                                        .background(allergies.contains(allergy) ? Color.blue : Color.gray)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                }
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            .onChange(of: selectedItem) { oldItem, newItem in
                Task {
                    if let image = try? await newItem?.loadTransferable(type: Image.self) {
                        selectedImage = image
                        if let uiImage = image.asUIImage() {
                            analyze(uiImage: uiImage)
                        }
                    }
                }
            }
            .sheet(isPresented: $showResultView) {
                if let result = analyzedResult, let image = selectedImage {
                    ResultView(result: result, image: image)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    

    @MainActor func analyze(uiImage: UIImage) {
        self.analyzedResult = nil
        self.isAnalyzing.toggle()

//        let prompt = """
//        From the given image, perform the following tasks:
//        1. Identify the ingredient(s) in the image.
//        2. Suggest one popular meal based on the image.
//        3. List other ingredients typically associated with this meal.
//        4. Provide a recipe containing the identified ingredients and step-by-step cooking instructions.
//        5. If the image doesn't clearly represent food or ingredients, respond with "I don't know."
//        6. Consider the following allergies: \(allergies.joined(separator: ", ")).
//        7. If any of the ingredients in the image match an allergy, respond with a warning that the meal contains allergens.
//        8. If the meal appears to be the same as one of the specified allergies, suggest alternatives or modifications to avoid the allergen.
//"""

//        let prompt = """
//        From the given image, perform the following tasks:
//        1. Identify the main ingredient from the image.
//        2. If the following allergies are specified: \(allergies.isEmpty ? "None" : allergies.joined(separator: ", ")), check if the identified main ingredient matches any of them.
//           a. If the main ingredient matches an allergy, return only a warning: "Warning: The main ingredient in this dish contains [allergen]. It is unsafe based on your specified allergies."
//        3. If no allergies are specified or the main ingredient does not match any of the allergies, proceed with the following:
//           a. Suggest a popular meal based on the image.
//           b. List other ingredients typically associated with the meal.
//           c. Provide a recipe containing the identified ingredients with step-by-step cooking instructions.
//
//"""
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
                    print("Response: \(text)")
                    self.analyzedResult = text
                    self.isAnalyzing.toggle()
                    self.showResultView = true
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct ResultView: View {
    let result: String
    let image: Image

    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .padding()

            ScrollView {
                Text(result)
                    .padding()
            }
            .navigationTitle("Generated Recipe")
            .navigationBarTitleDisplayMode(.inline)
        }
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

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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

#Preview{
    MealImageToRecipeView()
}
