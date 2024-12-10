//
//  helloView.swift
//  AllerBite
//
//  Created by Sahil Aggarwal on 01/12/24.
//



import SwiftUI
import GoogleGenerativeAI
import Vision

//struct helloView: View {
//    @State private var navigateToContentView: Bool = false
//    @Environment(\.presentationMode) var presentationMode
//    @State private var capturedImage: UIImage?
//    @Binding var responseText: String
//    @State private var chatMessages: [ChatMessage] = []
//    @State private var userInput: String = ""
//    @State private var extractedText: String = ""
//
//    var body: some View {
//        NavigationView{
//            VStack {
//                ScrollView {
//                    VStack(spacing: 15) {
//                        if let image = capturedImage ?? readImage() {
//                            Image(uiImage: image)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 250, height: 250)
//                                .padding(.top)
//                                .onAppear {
//                                    extractText(from: image)
//                                }
//                        }
//                        
//                        VStack {
//                            Image(systemName: "hand.wave")
//                                .foregroundColor(.blue)
//                                .font(.system(size: 50))
//                                .cornerRadius(100)
//                            
//                            Text("Welcome to HelloView!")
//                                .font(.title3)
//                                .foregroundColor(.blue)
//                                .lineSpacing(5)
//                                .offset(y: 20)
//                        }
//                        
//                        Text("Response from Gemini:")
//                            .font(.headline)
//                            .padding(.top)
//                        
//                        Text(responseText)
//                            .padding()
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(8)
//                            .padding(.horizontal)
//                        
//                        ForEach(chatMessages) { message in
//                            ChatBubble(message: message)
//                        }
//                    }
//                    .padding()
//                }
//                
//                HStack {
//                    TextField("Type your message...", text: $userInput)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .frame(minHeight: 30)
//                    
//                    Button(action: {
//                        sendMessage()
//                    }) {
//                        Text("Send")
//                            .foregroundColor(.white)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 15)
//                            .background(Color.blue)
//                            .cornerRadius(5)
//                    }
//                }
//                .padding()
//            }
//            .toolbar {
//                
//                ToolbarItem(placement: .principal) {
//                    Text("HelloView")
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        navigateToContentView=true
//                    }) {
//                        Text("Done")
//                            .foregroundColor(.green)
//                    }.background(
//                        NavigationLink(destination: AllergyView(), label: {
//                            EmptyView()
//                        }).opacity(0))
//                }
//            }
//            //
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//    
//struct helloView: View {
//    @State private var navigateToContentView: Bool = false
//    @Environment(\.presentationMode) var presentationMode
//    @State private var capturedImage: UIImage?
//    @Binding var responseText: String
//    @State private var chatMessages: [ChatMessage] = []
//    @State private var userInput: String = ""
//    @State private var extractedText: String = ""
//    var selectedAllergies: Set<String>
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                ScrollView {
//                    VStack(spacing: 15) {
//                        if let image = capturedImage ?? readImage() {
//                            Image(uiImage: image)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 250, height: 250)
//                                .padding(.top)
//                                .onAppear {
//                                    extractText(from: image)
//                                }
//                        }
//                        
//                        VStack {
//                            Image(systemName: "hand.wave")
//                                .foregroundColor(.blue)
//                                .font(.system(size: 50))
//                                .cornerRadius(100)
//                            
//                            Text("Welcome to HelloView!")
//                                .font(.title3)
//                                .foregroundColor(.blue)
//                                .lineSpacing(5)
//                                .offset(y: 20)
//                        }
//                        
//                        Text("Response from Gemini:")
//                            .font(.headline)
//                            .padding(.top)
//                        
//                        Text(responseText)
//                            .padding()
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(8)
//                            .padding(.horizontal)
//                        
//                        ForEach(chatMessages) { message in
//                            ChatBubble(message: message)
//                        }
//                    }
//                    .padding()
//                }
//                
//                HStack {
//                    TextField("Type your message...", text: $userInput)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .frame(minHeight: 30)
//                    
//                    Button(action: {
//                        sendMessage()
//                    }) {
//                        Text("Send")
//                            .foregroundColor(.white)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 15)
//                            .background(Color.blue)
//                            .cornerRadius(5)
//                    }
//                }
//                .padding()
//            }
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("HelloView")
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    // Wrap the Done button in a NavigationLink
//                    NavigationLink(
//                        destination: AllergyView(),
//                        isActive: $navigateToContentView
//                    ) {
//                        Button(action: {
//                            navigateToContentView = true
//                        }) {
//                            Text("Done")
//                                .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        }
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//       
//    }
//
//
//
//
//    func sendMessage() {
//        // Add user's message to chat
//        let userMessage = ChatMessage(text: userInput, isUser: true)
//        chatMessages.append(userMessage)
//
//        // Clear the input field
//        userInput = ""
//        
//        if let image = capturedImage ?? readImage() {
//            analyze(uiImage: image)
//        }
//
//        // Generate response using Gemini
//        Task {
//            do {
//                let generationConfig = GenerationConfig(
//                    temperature: 0,
//                    topP: 0.95,
//                    topK: 64,
//                    maxOutputTokens: 8192
//                )
//
//                let model = GenerativeModel(
//                    name: "gemini-1.5-flash",
//                    apiKey: APIKey.default,
//                    generationConfig: generationConfig
//                )
//
//                // Convert chat history to an array of ModelContent objects
//                let chatHistory: [ModelContent] = try chatMessages.map { message in
//                    try ModelContent(message.text)
//                }
//
//                let chatSession = model.startChat(history: chatHistory)
//                let response = try await chatSession.sendMessage([ModelContent(userMessage.text)])
//
//                let responseMessage = ChatMessage(text: response.text ?? "No response", isUser: false)
//                chatMessages.append(responseMessage)
//            } catch let error as GenerateContentError {
//                let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
//                chatMessages.append(errorMessage)
//            } catch {
//                let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
//                chatMessages.append(errorMessage)
//            }
//        }
//    }
//
//    @MainActor func analyze(uiImage: UIImage) {
//        Task {
//            do {
//                let model = GenerativeModel(
//                    name: "gemini-1.5-flash",
//                    apiKey: APIKey.default,
//                    generationConfig: GenerationConfig(
//                        temperature: 0.7,
//                        topP: 0.95,
//                        topK: 64,
//                        maxOutputTokens: 8192
//                    )
//                )
//
//                let response = try await model.generateContent(uiImage)
//
//                if let text = response.text {
//                    print("Response: \(text)")
//                    let responseMessage = ChatMessage(text: text, isUser: false)
//                    chatMessages.append(responseMessage)
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    func readImage() -> UIImage? {
//        let fileManager = FileManager.default
//        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let imageUrl = documentsDirectory.appendingPathComponent("preview.jpeg")
//        
//        if let imageData = try? Data(contentsOf: imageUrl) {
//            return UIImage(data: imageData)
//        } else {
//            print("Image file not found.")
//            return nil
//        }
//    }
//
//    func extractText(from image: UIImage) {
//        guard let cgImage = image.cgImage else { return }
//
//        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        let request = VNRecognizeTextRequest { (request, error) in
//            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
//
//            let recognizedStrings = observations.compactMap { observation in
//                observation.topCandidates(1).first?.string
//            }
//
//            self.extractedText = recognizedStrings.joined(separator: "\n")
//            self.responseText = self.extractedText // Update responseText with extracted text
//
//            // Send the extracted text to Gemini for more information
//            sendExtractedTextToGemini()
//        }
//
//        do {
//            try requestHandler.perform([request])
//        } catch {
//            print("Unable to perform the request: \(error.localizedDescription)")
//        }
//    }
//
//    func sendExtractedTextToGemini() {
//        // Generate response using Gemini
//        Task {
//            do {
//                let generationConfig = GenerationConfig(
//                    temperature: 0,
//                    topP: 0.95,
//                    topK: 64,
//                    maxOutputTokens: 8192
//                )
//
//                let model = GenerativeModel(
//                    name: "gemini-1.5-flash",
//                    apiKey: APIKey.default,
//                    generationConfig: generationConfig
//                )
//
//                // Craft a detailed prompt
//                let prompt = """
//                Ingredients: \(extractedText)
//                Allergies to check: \(FirestoreManager.userSavedAllergies.joined(separator: " or "))
//
//                Task:
//                1. Identify ingredients harmful to the user based on known allergies.
//                2. Highlight harmful additives unrelated to allergies.
//                3. If safe, recommend similar safe products.
//                """
//
//                
//                print("prompt is: \(prompt)")
//                
//                let chatSession = model.startChat(history: [])
//                let response = try await chatSession.sendMessage([ModelContent(prompt)])
//
//                let responseMessage = ChatMessage(text: response.text ?? "No response", isUser: false)
//                chatMessages.append(responseMessage)
//            } catch let error as GenerateContentError {
//                let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
//                chatMessages.append(errorMessage)
//            } catch {
//                let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
//                chatMessages.append(errorMessage)
//            }
//        }
//    }
//}
//
//
//


//struct helloView: View {
//    @State private var navigateToContentView: Bool = false
//    @Environment(\.presentationMode) var presentationMode
//    @State private var capturedImage: UIImage?
//    @Binding var responseText: String
//    @State private var extractedText: String = ""
//    var selectedAllergies: Set<String>
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                ScrollView {
//                    VStack(spacing: 15) {
//                        if let image = capturedImage ?? readImage() {
//                            Image(uiImage: image)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 250, height: 250)
//                                .padding(.top)
//                                .onAppear {
//                                    extractText(from: image)
//                                }
//                        }
//                        
//                        VStack {
//                            Image(systemName: "hand.wave")
//                                .foregroundColor(.blue)
//                                .font(.system(size: 50))
//                                .cornerRadius(100)
//                            
//                            Text("Welcome to HelloView!")
//                                .font(.title3)
//                                .foregroundColor(.blue)
//                                .lineSpacing(5)
//                                .offset(y: 20)
//                        }
//                        
//                        Text("Response from Gemini:")
//                            .font(.headline)
//                            .padding(.top)
//                        
//                        Text(responseText)
//                            .padding()
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(8)
//                            .padding(.horizontal)
//                    }
//                    .padding()
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("HelloView")
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(
//                        destination: AllergyView(),
//                        isActive: $navigateToContentView
//                    ) {
//                        Button(action: {
//                            navigateToContentView = true
//                        }) {
//                            Text("Done")
//                                .foregroundColor(Color(red: 79/255, green: 143/255, blue: 0/255))
//                        }
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//
//    func extractText(from image: UIImage) {
//        guard let cgImage = image.cgImage else { return }
//
//        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        let request = VNRecognizeTextRequest { (request, error) in
//            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
//
//            let recognizedStrings = observations.compactMap { observation in
//                observation.topCandidates(1).first?.string
//            }
//
//            self.extractedText = recognizedStrings.joined(separator: "\n")
//            self.responseText = self.extractedText // Update responseText with extracted text
//
//            // Send the extracted text to Gemini for more information
//            sendExtractedTextToGemini()
//        }
//
//        do {
//            try requestHandler.perform([request])
//        } catch {
//            print("Unable to perform the request: \(error.localizedDescription)")
//        }
//    }
//
//    func sendExtractedTextToGemini() {
//        Task {
//            do {
//                let generationConfig = GenerationConfig(
//                    temperature: 0,
//                    topP: 0.95,
//                    topK: 64,
//                    maxOutputTokens: 8192
//                )
//
//                let model = GenerativeModel(
//                    name: "gemini-1.5-flash",
//                    apiKey: APIKey.default,
//                    generationConfig: generationConfig
//                )
//
//                // Craft a detailed prompt
//                let prompt = """
//                        Analyze the following ingredients list and provide details about the product:
//                        Ingredients: \(extractedText)
//                        Allergies to check: \(FirestoreManager.userSavedAllergies.joined(separator: " or "))
//
//                        Task:
//                        1. Identify harmful ingredients based on user allergies.
//                        2. Provide product safety insights and recommendations.
//                        3. Suggest similar safe alternatives if the product is unsafe.
//                        """
//
//                print("Prompt is: \(prompt)")
//
//                let response = try await model.generateContent(prompt)
//
//                self.responseText = response.text ?? "No response"
//            } catch let error as GenerateContentError {
//                self.responseText = "Error: \(error.localizedDescription)"
//            } catch {
//                self.responseText = "Unexpected error: \(error.localizedDescription)"
//            }
//        }
//    }
//
//    func readImage() -> UIImage? {
//        let fileManager = FileManager.default
//        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let imageUrl = documentsDirectory.appendingPathComponent("preview.jpeg")
//        
//        if let imageData = try? Data(contentsOf: imageUrl) {
//            return UIImage(data: imageData)
//        } else {
//            print("Image file not found.")
//            return nil
//        }
//    }
//}
struct helloView: View {
    @Binding var responseText: String
    @Binding var selectedAllergies: Set<String>

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
        }
        .padding()
    }
}
