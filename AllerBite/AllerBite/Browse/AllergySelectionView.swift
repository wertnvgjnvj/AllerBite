//
//  AllergySelectionView.swift
//  AllerBite
//
//  Created by Sahil Aggarwal on 06/12/24.
//


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
//                VStack {
//                    ForEach(allergyOptions, id: \ .self) { allergy in
//                        Button(action: {
//                            if selectedAllergies.contains(allergy) {
//                                selectedAllergies.removeAll { $0 == allergy }
//                            } else {
//                                selectedAllergies.append(allergy)
//                            }
//                        }) {
//                            Text(allergy)
//                                .padding()
//                                .frame(maxWidth: .infinity)
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
//        VStack {
//            Text("Upload a Meal Image")
//                .font(.largeTitle)
//                .padding()
//
//            if let selectedImage {
//                selectedImage
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    .padding()
//
//                if isAnalyzing {
//                    ProgressView("Analyzing...")
//                        .padding()
//                }
//            } else {
//                Button(action: {
//                    showActionSheet = true
//                }) {
//                    Text("Get Started")
//                        .bold()
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.indigo)
//                        .foregroundColor(.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                }
//                .padding()
//            }
//
//            if let analyzedResult {
//                NavigationLink(destination: ResultView(result: analyzedResult, image: selectedImage)) {
//                    Text("View Recipe")
//                        .bold()
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                }
//                .padding()
//            }
//        }
//        .padding()
//        .actionSheet(isPresented: $showActionSheet) {
//            ActionSheet(title: Text("Select Image"), buttons: [
//                .default(Text("Photo Library")) {
//                    showImagePicker = true
//                },
//                .default(Text("Capture Photo")) {
//                    showCameraPicker = true
//                },
//                .cancel()
//            ])
//        }
//        .sheet(isPresented: $showImagePicker) {
//            ImagePicker(sourceType: .photoLibrary) { image in
//                if let image = image {
//                    selectedImage = Image(uiImage: image)
//                    analyze(uiImage: image)
//                }
//            }
//        }
//        .sheet(isPresented: $showCameraPicker) {
//            ImagePicker(sourceType: .camera) { image in
//                if let image = image {
//                    selectedImage = Image(uiImage: image)
//                    analyze(uiImage: image)
//                }
//            }
//        }
//    }
//
//    @MainActor private func analyze(uiImage: UIImage) {
//            analyzedResult = nil
//            isAnalyzing = true
//
//            let prompt = """
//            Analyze the provided image and complete the following tasks:
//            1. Identify the ingredient(s) shown in the image.
//            2. Check if any of the identified ingredients match the following allergies: \(allergies.joined(separator: ", ")).
//            3. If any ingredient matches an allergy, automatically suggest suitable substitutions and provide an allergy-free recipe.
//            4. If no allergens are detected, provide a regular recipe with step-by-step instructions.
//            5. If the image is unclear or does not show food or ingredients, respond with \"The image is not clear. Please provide a clearer image.\"
//            6. Ensure the final recipe is completely safe for individuals with the specified allergies.
//            """
//
//            Task {
//                do {
//                    let response = try await model.generateContent(prompt, uiImage)
//                    print(prompt)
//                    if let text = response.text {
//                        analyzedResult = text
//                        isAnalyzing = false
//                        
//                    }
//                } catch {
//                    print("Error analyzing image: \(error)")
//                    isAnalyzing = false
//                }
//            }
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
//
////@main
////struct MyApp: App {
////    var body: some Scene {
////        WindowGroup {
////            AllergySelectionView()
////        }
////    }
////}
