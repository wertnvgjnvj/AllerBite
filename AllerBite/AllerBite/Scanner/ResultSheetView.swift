//import SwiftUI
//import GoogleGenerativeAI
//import Vision
//
//struct ResultSheetView: View {
//    @State private var navigateToContentView: Bool = false
//    @Environment(\.presentationMode) var presentationMode
//    @State private var capturedImage: UIImage?
//    @Binding var responseText: String
//    @State private var chatMessages: [ChatMessage] = []
//    @State private var userInput: String = ""
//    @State private var extractedText: String = ""
//    @State private var Safety: Bool = false
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
//                        //                        VStack {
//                        //                            if !Safety {
//                        //                                Image(systemName: "x.circle")
//                        //                                    .foregroundColor(.red)
//                        //                                    .font(.system(size: 50))
//                        //                                    .cornerRadius(100)
//                        //                                Text("This product is not safe for you.")
//                        //                                    .font(.title3)
//                        //                                    .foregroundColor(.red)
//                        //                                    .lineSpacing(5)
//                        //                                    .offset(y: 20)
//                        //                            } else {
//                        //                                Image(systemName: "checkmark.circle")
//                        //                                    .foregroundColor(.green)
//                        //                                    .font(.system(size: 50))
//                        //                                    .cornerRadius(100)
//                        //                            }
//                        ////                        }
//                        //                        VStack {
//                        //                            if !Safety {
//                        //                                Image(systemName: "xmark.circle")
//                        //                                    .foregroundColor(.red)
//                        //                                    .font(.system(size: 50))
//                        //                                    .cornerRadius(100)
//                        //                                Text("This product is not safe for you.")
//                        //                                    .font(.title3)
//                        //                                    .foregroundColor(.red)
//                        //                                    .lineSpacing(5)
//                        //                                    .offset(y: 20)
//                        //                            } else {
//                        //                                Image(systemName: "checkmark.circle")
//                        //                                    .foregroundColor(.green)
//                        //                                    .font(.system(size: 50))
//                        //                                    .cornerRadius(100)
//                        //                            }
//                        //                        }
//                        VStack {
//                            if !Safety {
//                                Image(systemName: "xmark.circle")
//                                    .foregroundColor(.red)
//                                    .font(.system(size: 50))
//                                    .cornerRadius(100)
//                                Text("This product is not safe for you.")
//                                    .font(.title3)
//                                    .foregroundColor(.red)
//                                    .lineSpacing(5)
//                                    .offset(y: 20)
//                            } else {
//                                Image(systemName: "checkmark.circle")
//                                    .foregroundColor(.green)
//                                    .font(.system(size: 50))
//                                    .cornerRadius(100)
//                                Text("This product is safe for you.")
//                                    .font(.title3)
//                                    .foregroundColor(.green)
//                                    .lineSpacing(5)
//                                    .offset(y: 20)
//                            }
//                        }
//
//
//
//                        Text("Response from Gemini:")
//                            .font(.headline)
//                            .padding(.top)
//
//                        Text(responseText)  // Displaying the responseText
//                            .padding()
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(8)
//                            .padding(.horizontal)
//
//                        // Display chat messages
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
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Text("Back")
//                            .foregroundColor(.green)
//                    }
//                }
//                ToolbarItem(placement: .principal) {
//                    Text("Result")
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        navigateToContentView = true
//                    }) {
//                        Text("Done")
//                            .foregroundColor(.green)
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $navigateToContentView) {
//                ContentView().navigationBarBackButtonHidden(true)
//            }
//        }
//    }
//
//    @MainActor func sendMessage() {
//        // Add user's message to chat
//        let userMessage = ChatMessage(text: userInput, isUser: true)
//        chatMessages.append(userMessage)
//
//        // Clear the input field
//        userInput = ""
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
//                // Update the UI on the main thread
//                await MainActor.run {
//                    let responseText = response.text ?? "No response"
//                    let responseMessage = ChatMessage(text: responseText, isUser: false)
//                    chatMessages.append(responseMessage)  // Append response to chatMessages
//                    self.responseText = responseText  // Update responseText
//                    updateSafetyStatus(responseText: responseText)  // Update safety status
//                }
//            } catch let error as GenerateContentError {
//                await MainActor.run {
//                    let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
//                    chatMessages.append(errorMessage)
//                }
//            } catch {
//                await MainActor.run {
//                    let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
//                    chatMessages.append(errorMessage)
//                }
//            }
//        }
//    }
//
//    //    func updateSafetyStatus(responseText: String) {
//    //        let lowercasedResponse = responseText.lowercased()
//    //
//    //        if lowercasedResponse.contains("not safe") || lowercasedResponse.contains("allergen") || lowercasedResponse.contains("harmful") {
//    //            Safety = false  // Product is not safe
//    //        } else if lowercasedResponse.contains("safe") || lowercasedResponse.contains("no harmful ingredients") {
//    //            Safety = true  // Product is safe
//    //        }
//    //    }
//    //    func updateSafetyStatus(responseText: String) {
//    //        let lowercasedResponse = responseText.lowercased()
//    //
//    //        if lowercasedResponse.contains("not safe") ||
//    //           lowercasedResponse.contains("allergen") ||
//    //           lowercasedResponse.contains("harmful") {
//    //            Safety = false  // Product is not safe
//    //        } else if lowercasedResponse.contains("no allergens") ||
//    //                  lowercasedResponse.contains("safe") ||
//    //                  lowercasedResponse.contains("no harmful ingredients") {
//    //            Safety = true  // Product is safe
//    //        } else {
//    //            // If there's no explicit mention of allergens or safety, assume the response isn't conclusive
//    //            Safety = false
//    //        }
//    //    }
//    func updateSafetyStatus(responseText: String) {
//            let lowercasedResponse = responseText.lowercased()
//
//            if lowercasedResponse.contains("not safe") ||
//                lowercasedResponse.contains("allergen") ||
//                lowercasedResponse.contains("harmful") ||
//                lowercasedResponse.contains("allergenic ingredients") {
//                Safety = false  // Product is not safe
//            } else if lowercasedResponse.contains("no allergens") ||
//                        lowercasedResponse.contains("safe") ||
//                        lowercasedResponse.contains("no harmful ingredients") {
//                Safety = true  // Product is safe
//            } else {
//                Safety = false
//            }
//        }
//
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
//            self.responseText = self.extractedText  // Update responseText with extracted text
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
//    //    func sendExtractedTextToGemini() {
//    //        Task {
//    //            do {
//    //                let generationConfig = GenerationConfig(
//    //                    temperature: 0,
//    //                    topP: 0.95,
//    //                    topK: 64,
//    //                    maxOutputTokens: 8192
//    //                )
//    //
//    //                let model = GenerativeModel(
//    //                    name: "gemini-1.5-flash",
//    //                    apiKey: APIKey.default,
//    //                    generationConfig: generationConfig
//    //                )
//    //
//    //                let prompt = """
//    //                Based on the following ingredients: \(extractedText), please provide:
//    //                1. A list of allergenic ingredients.
//    //                2. Alternative products that are safe for someone with these allergies.
//    //                3. A summary of any harmful ingredients found.
//    //                """
//    //
//    //                let chatSession = model.startChat(history: [])
//    //                let response = try await chatSession.sendMessage([ModelContent(prompt)])
//    //
//    //                await MainActor.run {
//    //                    let responseText = response.text ?? "No response"
//    //                    let responseMessage = ChatMessage(text: responseText, isUser: false)
//    //                    chatMessages.append(responseMessage)
//    //                    self.responseText = responseText  // Ensure responseText is updated in the UI
//    //                    updateSafetyStatus(responseText: responseText)
//    //                }
//    //            } catch let error as GenerateContentError {
//    //                await MainActor.run {
//    //                    let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
//    //                    chatMessages.append(errorMessage)
//    //                }
//    //            } catch {
//    //                await MainActor.run {
//    //                    let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
//    //                    chatMessages.append(errorMessage)
//    //                }
//    //            }
//    //        }
////    func sendExtractedTextToGemini() {
////        Task {
////            do {
////                let generationConfig = GenerationConfig(
////                    temperature: 0,
////                    topP: 0.95,
////                    topK: 64,
////                    maxOutputTokens: 8192
////                )
////
////                let model = GenerativeModel(
////                    name: "gemini-1.5-flash",
////                    apiKey: APIKey.default,
////                    generationConfig: generationConfig
////                )
////                print(APIKey.default)
////                // Modify the prompt to ask Gemini for allergenic ingredients or a confirmation if none are found
////                let prompt = """
////                Based on the following ingredients: \(extractedText), please determine:
////                1. Does the product contain any allergens or ingredients harmful to people with allergies?
////                2. If allergens are found, specify which ingredients.
////                3. If no allergens are found, confirm the product is safe for consumption.
////                """
////
////
////                let chatSession = model.startChat(history: [])
////                let response = try await chatSession.sendMessage([ModelContent(prompt)])
////
////                await MainActor.run {
////                    let responseText = response.text ?? "No response"
////                    let responseMessage = ChatMessage(text: responseText, isUser: false)
////                    chatMessages.append(responseMessage)
////                    self.responseText = responseText  // Ensure responseText is updated in the UI
////                    updateSafetyStatus(responseText: responseText)  // Check if product is safe based on the response
////                }
////            } catch let error as GenerateContentError {
////                await MainActor.run {
////                    let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
////                    chatMessages.append(errorMessage)
////                }
////            } catch {
////                await MainActor.run {
////                    let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
////                    chatMessages.append(errorMessage)
////                }
////            }
////        }
////    }
////
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
//                // Updated prompt asking to check if the product contains allergens
//                let prompt = """
//                       Please review the following list of ingredients: \(extractedText).
//                       I have an allergy to \(userInput). Based on the ingredients, is this product safe for me to consume?
//                       If not, please identify which ingredients are unsafe due to my allergies.
//                       """
//
//                let chatSession = model.startChat(history: [])
//                let response = try await chatSession.sendMessage([ModelContent(prompt)])
//
//                await MainActor.run {
//                    let responseText = response.text ?? "No response"
//                    let responseMessage = ChatMessage(text: responseText, isUser: false)
//                    chatMessages.append(responseMessage)
//                    self.responseText = responseText  // Ensure responseText is updated in the UI
//                    updateSafetyStatus(responseText: responseText)  // Update safety based on response
//                }
//            } catch let error as GenerateContentError {
//                await MainActor.run {
//                    let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
//                    chatMessages.append(errorMessage)
//                }
//            } catch {
//                await MainActor.run {
//                    let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
//                    chatMessages.append(errorMessage)
//                }
//            }
//        }
//    }
//
//}
//
//
//
//
//
//struct ChatBubble: View {
//    var message: ChatMessage
//
//    var body: some View {
//        HStack {
//            if message.isUser {
//                Spacer()
//                Text(message.text)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .frame(maxWidth: 250, alignment: .trailing)
//            } else {
//                Text(message.text)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .foregroundColor(.black)
//                    .cornerRadius(10)
//                    .frame(maxWidth: 250, alignment: .leading)
//                Spacer()
//            }
//        }
//        .padding(message.isUser ? .leading : .trailing, 40)
//    }
//}
//
//struct ChatMessage: Identifiable {
//    let id = UUID()
//    let text: String
//    let isUser: Bool
//}
//






//import SwiftUI
//import GoogleGenerativeAI
//import Vision
//
//struct ResultSheetView: View {
//    @State private var navigateToContentView: Bool = false
//    @Environment(\.presentationMode) var presentationMode
//    @State private var capturedImage: UIImage?
//    @Binding var responseText: String
//    @State private var chatMessages: [ChatMessage] = []
//    @State private var userInput: String = ""
//    @State private var extractedText: String = ""
//    @State private var Safety: Bool = false
//    @AppStorage("allergies") var allergies: String = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                ScrollView {
//                    VStack(spacing: 15) {
//                        // Display captured image if available
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
//                        // Display user's allergies
//                        if !allergies.isEmpty {
//                            Text("Your Allergies: \(allergies)")
//                                .font(.subheadline)
//                                .padding(.top)
//                        } else {
//                            Text("No allergies specified.")
//                                .font(.subheadline)
//                                .padding(.top)
//                        }
//                        
//                        // Show safety status based on Gemini AI's response
//                        VStack {
//                            if !Safety {
//                                Image(systemName: "xmark.circle")
//                                    .foregroundColor(.red)
//                                    .font(.system(size: 50))
//                                    .cornerRadius(100)
//                                Text("This product is not safe for you.")
//                                    .font(.title3)
//                                    .foregroundColor(.red)
//                                    .lineSpacing(5)
//                                    .offset(y: 20)
//                            } else {
//                                Image(systemName: "checkmark.circle")
//                                    .foregroundColor(.green)
//                                    .font(.system(size: 50))
//                                    .cornerRadius(100)
//                                Text("This product is safe for you.")
//                                    .font(.title3)
//                                    .foregroundColor(.green)
//                                    .lineSpacing(5)
//                                    .offset(y: 20)
//                            }
//                        }
//                        
//                        // Display response from Gemini AI
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
//                        // Display chat messages
//                        ForEach(chatMessages) { message in
//                            ChatBubble(message: message)
//                        }
//                    }
//                    .padding()
//                }
//                
//                // Input area for user's chat messages
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
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Text("Back")
//                            .foregroundColor(.green)
//                    }
//                }
//                ToolbarItem(placement: .principal) {
//                    Text("Result")
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Text("Done")
//                            .foregroundColor(.green)
//                    }
//                }
//
//            }
////            .fullScreenCover(isPresented: $navigateToContentView) {
////                ContentView().navigationBarBackButtonHidden(true)
////            }
//        }
//    }
//    
//    @MainActor func sendMessage() {
//        // Add user's message to chat
//        let userMessage = ChatMessage(text: userInput, isUser: true)
//        chatMessages.append(userMessage)
//        
//        // Clear the input field
//        userInput = ""
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
//                let chatHistory: [ModelContent] = try chatMessages.map { message in
//                    try ModelContent(message.text)
//                }
//                
//                let chatSession = model.startChat(history: chatHistory)
//                let response = try await chatSession.sendMessage([ModelContent(userMessage.text)])
//                
//                await MainActor.run {
//                    let responseText = response.text ?? "No response"
//                    let responseMessage = ChatMessage(text: responseText, isUser: false)
//                    chatMessages.append(responseMessage)
//                    self.responseText = responseText  // Update responseText
//                    updateSafetyStatus(responseText: responseText)  // Update safety status
//                }
//            } catch {
//                await MainActor.run {
//                    let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
//                    chatMessages.append(errorMessage)
//                }
//            }
//        }
//    }
//    
////    func updateSafetyStatus(responseText: String) {
////        let lowercasedResponse = responseText.lowercased()
////        
////        // Detect if the product is safe or not based on the response
////        if lowercasedResponse.contains("not safe") ||
////            lowercasedResponse.contains("allergen") ||
////            lowercasedResponse.contains("harmful") ||
////            lowercasedResponse.contains("unsafe ingredients") {
////            Safety = false  // Product is not safe
////        } else if lowercasedResponse.contains("no allergens") ||
////                    lowercasedResponse.contains("safe") ||
////                    lowercasedResponse.contains("no harmful ingredients") {
////            Safety = true  // Product is safe
////        } else {
////            Safety = false  // Default safety status if response is unclear
////        }
////    }
//    
//    func updateSafetyStatus(responseText: String) {
//        let lowercasedResponse = responseText.lowercased()
//        
//        if lowercasedResponse.contains("not safe") ||
//            lowercasedResponse.contains("allergen") ||
//            lowercasedResponse.contains("unsafe") {
//            Safety = false
//        } else if lowercasedResponse.contains("safe") {
//            Safety = true
//        } else {
//            Safety = false
//        }
//    }
//
//    
//    
//    // func readImage() -> UIImage? {
//    //     let fileManager = FileManager.default
//    //     let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//    //     let imageUrl = documentsDirectory.appendingPathComponent("preview.jpeg")
//        
//    //     if let imageData = try? Data(contentsOf: imageUrl) {
//    //         print("Image successfully loaded.")
//    //         return UIImage(data: imageData)
//    //     } else {
//    //         print("Image file not found.")
//    //         return nil
//    //     }
//    // }
//
//    // Update the readImage() function in ResultSheetView:
//func readImage() -> UIImage? {
//    let fileManager = FileManager.default
//    let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let imageUrl = documentsDirectory.appendingPathComponent("preview.jpeg")
//    
//    if let imageData = try? Data(contentsOf: imageUrl) {
//        print("Image successfully loaded from: \(imageUrl)")
//        return UIImage(data: imageData)
//    } else {
//        print("Failed to load image from: \(imageUrl)")
//        return nil
//    }
//}
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
//            self.responseText = self.extractedText  // Update responseText with extracted text
//            
//            // Send the extracted text to Gemini for more information
//            sendExtractedTextToGemini(extractedText: self.extractedText)  // Pass the extracted text
//        }
//        
//        do {
//            try requestHandler.perform([request])
//        } catch {
//            print("Unable to perform the request: \(error.localizedDescription)")
//        }
//    }
//
//    
//    
////    private func resultLoadSavedAllergies(completion: @escaping ([String]) -> Void) {
////        // Check if saved allergies exist in UserDefaults
////        if let savedAllergies = UserDefaults.standard.array(forKey: "savedAllergies") as? [String] {
////            // Ensure the completion handler is on the main thread
////            DispatchQueue.main.async {
////                print("Result sheet - Loaded saved allergies:", savedAllergies)
////                completion(savedAllergies) // Pass the allergies to the completion handler
////            }
////        } else {
////            // No saved allergies found, pass an empty array
////            DispatchQueue.main.async {
////                print("No saved allergies found in UserDefaults.")
////                completion([]) // Pass an empty array if no allergies are found
////            }
////        }
////    }
//    
//    private func resultLoadSavedAllergies(completion: @escaping ([String]) -> Void) {
//        if let savedAllergies = UserDefaults.standard.array(forKey: "savedAllergies") as? [String] {
//            DispatchQueue.main.async {
//                print("Loaded allergies: \(savedAllergies)")
//                completion(savedAllergies)
//            }
//        } else {
//            DispatchQueue.main.async {
//                print("No allergies found.")
//                completion([])
//            }
//        }
//    }
//
//
////    func sendExtractedTextToGemini(extractedText: String) {
////        // Load saved allergies before sending the text to Gemini
////        print(APIKey.default)
////        resultLoadSavedAllergies { savedAllergies in
////            Task {
////                do {
////                    let generationConfig = GenerationConfig(
////                        temperature: 0,
////                        topP: 0.95,
////                        topK: 64,
////                        maxOutputTokens: 8192
////                    )
////                    
////                    let model = GenerativeModel(
////                        name: "gemini-1.5-flash",
////                        apiKey: APIKey.default,
////                        generationConfig: generationConfig
////                    )
////                    
////                    // Use savedAllergies in the prompt
//////                    let prompt = """
//////                    Analyze the following ingredients list for potential allergens based on the provided allergy list: \(savedAllergies).
//////                    
//////                    The ingredients are: \(extractedText).
//////                    
//////                    If any allergens from the allergy list are present, respond with:
//////                    "Product contains allergic ingredients. Not safe for you."
//////                    List the unsafe ingredients as:
//////                    "Unsafe ingredients: [allergen_1, allergen_2, ...]."
//////                    
//////                    If no allergens or derivatives are found, respond with:
//////                    "Product is safe for you."
//////                    
//////                    Ensure that the output is concise and does not include additional explanations or details.
//////                    """
////                    let prompt = """
////                    Analyze the provided product ingredients against the selected allergies: \(savedAllergies).
////
////                    The ingredients to check are: \(extractedText).
////
////                    1. If any of the ingredients match the selected allergies, respond with:
////                       "Warning: Product contains allergic ingredients. Not safe for you."
////                       List the specific unsafe ingredients as:
////                       "Unsafe ingredients: [allergen_1, allergen_2, ...]."
////
////                    2. If no ingredients match the selected allergies, respond with:
////                       "Product is safe for you."
////
////                    Keep the output concise and limited to this information only.
////                    """
////
////                    
////                    print(prompt)
////                   
////                    let chatSession = model.startChat(history: [])
////                    let response = try await chatSession.sendMessage([ModelContent(prompt)])
////                    
////                    await MainActor.run {
////                        let responseText = response.text ?? "No response"
////                        let responseMessage = ChatMessage(text: responseText, isUser: false)
////                        chatMessages.append(responseMessage)
////                        self.responseText = responseText  // Ensure responseText is updated in the UI
////                        updateSafetyStatus(responseText: responseText)  // Update safety based on response
////                    }
////                } catch {
////                    await MainActor.run {
////                        let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
////                        chatMessages.append(errorMessage)
////                    }
////                }
////            }
////        }
////    }
//
//    func sendExtractedTextToGemini(extractedText: String) {
//        print("Starting allergen check with extracted text: \(extractedText)")
//        
//        // Load saved allergies before sending the text to Gemini
//        resultLoadSavedAllergies { savedAllergies in
//            Task {
//                do {
//                    // Configuration for the AI model
//                    let generationConfig = GenerationConfig(
//                        temperature: 0.7,
//                        maxOutputTokens: 512
//                    )
//                    
//                    // Initialize the Generative AI model with your API key
//                    let model = GenerativeModel(
//                        name: "gemini-1.5-flash",
//                        apiKey: "YOUR_ACTUAL_API_KEY",  // Replace with your API key
//                        generationConfig: generationConfig
//                    )
//                    
//                    // Construct the prompt
//                    let prompt = """
//                    Analyze the following ingredients for potential allergens based on the provided allergy list: \(savedAllergies).
//                    Ingredients: \(extractedText).
//                    
//                    Respond with:
//                    - "Warning: Product contains allergens: [list allergens]" if any allergens are found.
//                    - "Product is safe" if no allergens are present.
//                    """
//                    
//                    print("Sending prompt to Gemini:\n\(prompt)")
//                    
//                    // Start the chat session
//                    let chatSession = model.startChat(history: [])
//                    let response = try await chatSession.sendMessage([ModelContent(prompt)])
//                    
//                    // Process the response
//                    await MainActor.run {
//                        let responseText = response.text ?? "No response from Gemini."
//                        print("Gemini Response: \(responseText)")
//                        
//                        // Update chat messages and UI
//                        let responseMessage = ChatMessage(text: responseText, isUser: false)
//                        chatMessages.append(responseMessage)
//                        self.responseText = responseText
//                        updateSafetyStatus(responseText: responseText)
//                    }
//                } catch {
//                    // Handle errors
//                    await MainActor.run {
//                        let errorMessage = "Error during allergen check: \(error.localizedDescription)"
//                        print(errorMessage)
//                        chatMessages.append(ChatMessage(text: errorMessage, isUser: false))
//                    }
//                }
//            }
//        }
//    }
//
//}
//
//struct ChatBubble: View {
//    var message: ChatMessage
//    
//    var body: some View {
//        HStack {
//            if message.isUser {
//                Spacer()
//                Text(message.text)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .frame(maxWidth: 250, alignment: .trailing)
//            } else {
//                Text(message.text)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .foregroundColor(.black)
//                    .cornerRadius(10)
//                    .frame(maxWidth: 250, alignment: .leading)
//                Spacer()
//            }
//        }
//        .padding(message.isUser ? .leading : .trailing, 40)
//    }
//}
//
//struct ChatMessage: Identifiable {
//    let id = UUID()
//    let text: String
//    let isUser: Bool
//}
//
//
//



//import SwiftUI
//import GoogleGenerativeAI
//import Vision
//
//struct ResultSheetView: View {
//    @State private var navigateToContentView: Bool = false
//    @Environment(\.presentationMode) var presentationMode
//    @State private var capturedImage: UIImage?
//    @Binding var responseText: String
//    @State private var chatMessages: [ChatMessage] = []
//    @State private var userInput: String = ""
//    @State private var extractedText: String = ""
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
//                            Image(systemName: "x.circle")
//                                .foregroundColor(.red)
//                                .font(.system(size: 50))
//                                .cornerRadius(100)
//                            
//                            Text("This product is not safe for you.")
//                                .font(.title3)
//                                .foregroundColor(.red)
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
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Text("Back")
//                            .foregroundColor(.green)
//                    }
//                }
//                ToolbarItem(placement: .principal) {
//                    Text("Result")
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        navigateToContentView = true
//                    }) {
//                        Text("Done")
//                            .foregroundColor(.green)
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $navigateToContentView) {
//                ContentView().navigationBarBackButtonHidden(true)
//            }
//        }
//    }
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
////           let prompt = """
////           From the given image, you need to run the following tasks:
////           1. Identify the ingredient name
////           2. Suggest one popular meal name from the given image
////           3. List other ingredients from the meal name
////           4. Return the recipes containing other ingredients and steps on how to cook the meal
////           5. If the image is not an ingredient, just say I don't know
////           6. Consider the following allergies: nut, gluten, dairy
////           """
//
//           Task {
//               do {
//                   let model = GenerativeModel(
//                       name: "gemini-1.5-flash",
//                       apiKey: APIKey.default,
//                       generationConfig: GenerationConfig(
//                           temperature: 0.7,
//                           topP: 0.95,
//                           topK: 64,
//                           maxOutputTokens: 8192
//                       )
//                   )
//
//                   let response = try await model.generateContent(uiImage)
//
//                   if let text = response.text {
//                       print("Response: \(text)")
//                       let responseMessage = ChatMessage(text: text, isUser: false)
//                       chatMessages.append(responseMessage)
//                   }
//               } catch {
//                   print(error.localizedDescription)
//               }
//           }
//       }
//
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
//                Based on the following ingredients: \(extractedText), please provide:
//                1. A list of allergenic ingredients.
//                2. Alternative products that are safe for someone with these allergies.
//                3. A summary of any harmful ingredients found.
//                """
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
//struct ChatBubble: View {
//    var message: ChatMessage
//
//    var body: some View {
//        HStack {
//            if message.isUser {
//                Spacer()
//                Text(message.text)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .frame(maxWidth: 250, alignment: .trailing)
//            } else {
//                Text(message.text)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .foregroundColor(.black)
//                    .cornerRadius(10)
//                    .frame(maxWidth: 250, alignment: .leading)
//                Spacer()
//            }
//        }
//        .padding(message.isUser ? .leading : .trailing, 40)
//    }
//}
//
//struct ChatMessage: Identifiable {
//    let id = UUID()
//    let text: String
//    let isUser: Bool
//}


import SwiftUI
import GoogleGenerativeAI
import Vision

struct ResultSheetView: View {
    @State private var navigateToContentView: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var capturedImage: UIImage?
    @Binding var responseText: String
    @State private var chatMessages: [ChatMessage] = []
    @State private var userInput: String = ""
    @State private var extractedText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 15) {
                        if let image = capturedImage ?? readImage() {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                                .padding(.top)
                                .onAppear {
                                    extractText(from: image)
                                }
                        }

                        VStack {
                            Image(systemName: "x.circle")
                                .foregroundColor(.red)
                                .font(.system(size: 50))
                                .cornerRadius(100)
                            
                            Text("This product is not safe for you.")
                                .font(.title3)
                                .foregroundColor(.red)
                                .lineSpacing(5)
                                .offset(y: 20)
                        }

                        Text("Response from Gemini:")
                            .font(.headline)
                            .padding(.top)

                        Text(responseText)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)

                        ForEach(chatMessages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }

                HStack {
                    TextField("Type your message...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 30)

                    Button(action: {
                        sendMessage()
                    }) {
                        Text("Send")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(Color.blue)
                            .cornerRadius(5)
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Back")
                            .foregroundColor(.green)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Result")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        navigateToContentView = true
                    }) {
                        Text("Done")
                            .foregroundColor(.green)
                    }
                }
            }
            .fullScreenCover(isPresented: $navigateToContentView) {
                ContentView().navigationBarBackButtonHidden(true)
            }
        }
    }

    func sendMessage() {
        // Add user's message to chat
        let userMessage = ChatMessage(text: userInput, isUser: true)
        chatMessages.append(userMessage)

        // Clear the input field
        userInput = ""
        
        if let image = capturedImage ?? readImage() {
            analyze(uiImage: image)
        }


        // Generate response using Gemini
        Task {
            do {
                let generationConfig = GenerationConfig(
                    temperature: 0,
                    topP: 0.95,
                    topK: 64,
                    maxOutputTokens: 8192
                )

                let model = GenerativeModel(
                    name: "gemini-1.5-flash",
                    apiKey: APIKey.default,
                    generationConfig: generationConfig
                )

                // Convert chat history to an array of ModelContent objects
                let chatHistory: [ModelContent] = try chatMessages.map { message in
                    try ModelContent(message.text)
                }

                let chatSession = model.startChat(history: chatHistory)
                let response = try await chatSession.sendMessage([ModelContent(userMessage.text)])

                let responseMessage = ChatMessage(text: response.text ?? "No response", isUser: false)
                chatMessages.append(responseMessage)
            } catch let error as GenerateContentError {
                let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
                chatMessages.append(errorMessage)
            } catch {
                let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
                chatMessages.append(errorMessage)
            }
        }
    }

    @MainActor func analyze(uiImage: UIImage) {
//           let prompt = """
//           From the given image, you need to run the following tasks:
//           1. Identify the ingredient name
//           2. Suggest one popular meal name from the given image
//           3. List other ingredients from the meal name
//           4. Return the recipes containing other ingredients and steps on how to cook the meal
//           5. If the image is not an ingredient, just say I don't know
//           6. Consider the following allergies: nut, gluten, dairy
//           """

           Task {
               do {
                   let model = GenerativeModel(
                       name: "gemini-1.5-flash",
                       apiKey: APIKey.default,
                       generationConfig: GenerationConfig(
                           temperature: 0.7,
                           topP: 0.95,
                           topK: 64,
                           maxOutputTokens: 8192
                       )
                   )

                   let response = try await model.generateContent(uiImage)

                   if let text = response.text {
                       print("Response: \(text)")
                       let responseMessage = ChatMessage(text: text, isUser: false)
                       chatMessages.append(responseMessage)
                   }
               } catch {
                   print(error.localizedDescription)
               }
           }
       }

    
    func readImage() -> UIImage? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageUrl = documentsDirectory.appendingPathComponent("preview.jpeg")
        
        if let imageData = try? Data(contentsOf: imageUrl) {
            return UIImage(data: imageData)
        } else {
            print("Image file not found.")
            return nil
        }
    }

    func extractText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }

            self.extractedText = recognizedStrings.joined(separator: "\n")
            self.responseText = self.extractedText // Update responseText with extracted text

            // Send the extracted text to Gemini for more information
            sendExtractedTextToGemini()
        }

        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request: \(error.localizedDescription)")
        }
    }

    func sendExtractedTextToGemini() {
        // Generate response using Gemini
        Task {
            do {
                let generationConfig = GenerationConfig(
                    temperature: 0,
                    topP: 0.95,
                    topK: 64,
                    maxOutputTokens: 8192
                )

                let model = GenerativeModel(
                    name: "gemini-1.5-flash",
                    apiKey: APIKey.default,
                    generationConfig: generationConfig
                )

                // Craft a detailed prompt
                let prompt = """
                Based on the following ingredients: \(extractedText), please provide:
                1. A list of allergenic ingredients.
                2. Alternative products that are safe for someone with these allergies.
                3. A summary of any harmful ingredients found.
                """

                let chatSession = model.startChat(history: [])
                let response = try await chatSession.sendMessage([ModelContent(prompt)])

                let responseMessage = ChatMessage(text: response.text ?? "No response", isUser: false)
                chatMessages.append(responseMessage)
            } catch let error as GenerateContentError {
                let errorMessage = ChatMessage(text: "Error: \(error.localizedDescription)", isUser: false)
                chatMessages.append(errorMessage)
            } catch {
                let errorMessage = ChatMessage(text: "Unexpected error: \(error.localizedDescription)", isUser: false)
                chatMessages.append(errorMessage)
            }
        }
    }
}

struct ChatBubble: View {
    var message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: 250, alignment: .trailing)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .frame(maxWidth: 250, alignment: .leading)
                Spacer()
            }
        }
        .padding(message.isUser ? .leading : .trailing, 40)
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
