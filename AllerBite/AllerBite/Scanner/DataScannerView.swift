//import SwiftUI
//import VisionKit
//import AVFoundation
//import GoogleGenerativeAI
//
//struct DataScannerView: UIViewControllerRepresentable {
//    @Binding var recognizedItems: [RecognizedItem]
//    @Binding var showAlert: Bool
//    @Binding var navigateToProfileView: Bool
//    let recognizedDataType: DataScannerViewController.RecognizedDataType
//    let recognizesMultipleItems: Bool
//    var cameraCapture: CameraPhotoCapture
//    @Binding var selectedAllergies: Set<String>
//    @Binding var responseText: String
//
//    func makeUIViewController(context: Context) -> DataScannerViewController {
//        let vc = DataScannerViewController(
//            recognizedDataTypes: [recognizedDataType],
//            qualityLevel: .balanced,
//            recognizesMultipleItems: recognizesMultipleItems,
//            isGuidanceEnabled: true,
//            isHighlightingEnabled: true
//        )
//        vc.delegate = context.coordinator
//        context.coordinator.dataScanner = vc
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
//        if navigateToProfileView {
//            uiViewController.stopScanning()
//        } else {
//            try? uiViewController.startScanning()
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(
//            recognizedItems: $recognizedItems,
//            showAlert: $showAlert,
//            navigateToProfileView: $navigateToProfileView,
//            cameraCapture: cameraCapture,
//            selectedAllergies: selectedAllergies,
//            responseText: $responseText
//        )
//    }
//
//    class Coordinator: NSObject, DataScannerViewControllerDelegate {
//        @Binding var recognizedItems: [RecognizedItem]
//        @Binding var showAlert: Bool
//        @Binding var navigateToProfileView: Bool
//        var capturedImage: UIImage?
//        var cameraCapture: CameraPhotoCapture
//        var selectedAllergies: Set<String>
//        var dataScanner: DataScannerViewController?
//        @Binding var responseText: String
//
//        init(recognizedItems: Binding<[RecognizedItem]>, showAlert: Binding<Bool>, navigateToProfileView: Binding<Bool>, cameraCapture: CameraPhotoCapture, selectedAllergies: Set<String>, responseText: Binding<String>) {
//            self._recognizedItems = recognizedItems
//            self._showAlert = showAlert
//            self._navigateToProfileView = navigateToProfileView
//            self.cameraCapture = cameraCapture
//            self.selectedAllergies = selectedAllergies
//            self._responseText = responseText
//            super.init()
//        }
//
//        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
//            print("Selected Allergies: \(selectedAllergies)")
//            for item in addedItems {
//                switch item {
//                case .text(let text):
//                    Task {
//                        await checkForAllergens(text.transcript)
//                    }
//                default:
//                    break
//                }
//            }
//        }
//
//        func checkForAllergens(_ text: String) async {
//            do {
//                let model = GenerativeModel(
//                    name: "gemini-1.5-flash",
//                    apiKey: APIKey.default
//                )
//              
//                let allergiesPrompt = selectedAllergies.isEmpty
//                    ? "Analyze the ingredients."
//                    : "Analyze the following text and identify any ingredients that could be harmful based on the following allergies: \(selectedAllergies.joined(separator: ", "))."
//                
//                let chatSession = model.startChat(history: [])
//                let response = try await chatSession.sendMessage("\(allergiesPrompt) \(text)")
//                self.responseText = response.text ?? "No response received"
//                
//                print("Gemini response: \(self.responseText)")
//
//                if response.text?.containsAllergen(for: selectedAllergies) ?? false {
//                    print("Allergen detected!")
//                    showAlert = true
//                    showImageCaptureAndNavigateToProfile(dataScanner: dataScanner)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.responseText = "Error: \(error.localizedDescription)"
//                }
//                print("Error during allergen check: \(error.localizedDescription)")
//            }
//        }
//
//        private func showImageCaptureAndNavigateToProfile(dataScanner: DataScannerViewController?) {
//            DispatchQueue.main.async {
//                Task {
//                    do {
//                        guard let dataScanner = dataScanner else {
//                            print("DataScanner is nil")
//                            return
//                        }
//                        let image = try await dataScanner.capturePhoto()
//                        let url = try FileManager.default
//                            .url(for: .documentDirectory,
//                                 in: .userDomainMask,
//                                 appropriateFor: nil,
//                                 create: true)
//                            .appendingPathComponent("preview.jpeg")
//                        if let data = image.jpegData(compressionQuality: 0.9) {
//                            try data.write(to: url)
//                        }
//
//                        self.cameraCapture.capturedImage = image
//                        self.navigateToProfileView = true
//                    } catch {
//                        print("Error capturing photo: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//
//        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
//            self.recognizedItems = recognizedItems.filter { item in
//                !removedItems.contains(where: { $0.id == item.id })
//            }
//        }
//
//        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
//            print("became unavailable with error \(error.localizedDescription)")
//        }
//    }
//}
//
//extension String {
//    func containsAllergen(for allergens: Set<String>) -> Bool {
//        for allergen in allergens {
//            if self.localizedCaseInsensitiveContains(allergen) {
//                return true
//            }
//        }
//        return false
//    }
//}
//

//import SwiftUI
//import VisionKit
//import AVFoundation
//import GoogleGenerativeAI
//
//struct DataScannerView: UIViewControllerRepresentable {
//    @Binding var recognizedItems: [RecognizedItem]
//    @Binding var showAlert: Bool
//    @Binding var navigateToProfileView: Bool
//    let recognizedDataType: DataScannerViewController.RecognizedDataType
//    let recognizesMultipleItems: Bool
//    var cameraCapture: CameraPhotoCapture
//    @Binding var selectedAllergies: Set<String>
//    @Binding var responseText: String
//    @Binding var allergenImage: Image? // Binding for allergen image
//
//    func makeUIViewController(context: Context) -> DataScannerViewController {
//        let vc = DataScannerViewController(
//            recognizedDataTypes: [recognizedDataType],
//            qualityLevel: .balanced,
//            recognizesMultipleItems: recognizesMultipleItems,
//            isGuidanceEnabled: true,
//            isHighlightingEnabled: true
//        )
//        vc.delegate = context.coordinator
//        context.coordinator.dataScanner = vc
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
//        if navigateToProfileView {
//            uiViewController.stopScanning()
//        } else {
//            try? uiViewController.startScanning()
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(
//            recognizedItems: $recognizedItems,
//            showAlert: $showAlert,
//            navigateToProfileView: $navigateToProfileView,
//            cameraCapture: cameraCapture,
//            selectedAllergies: selectedAllergies,
//            responseText: $responseText,
//            allergenImage: $allergenImage // Pass allergenImage to coordinator
//        )
//    }
//
//    class Coordinator: NSObject, DataScannerViewControllerDelegate {
//        @Binding var recognizedItems: [RecognizedItem]
//        @Binding var showAlert: Bool
//        @Binding var navigateToProfileView: Bool
//        var cameraCapture: CameraPhotoCapture
//        var selectedAllergies: Set<String>
//        var dataScanner: DataScannerViewController?
//        @Binding var responseText: String
//        @Binding var allergenImage: Image? // New property to hold the allergen image
//
//        init(recognizedItems: Binding<[RecognizedItem]>, showAlert: Binding<Bool>, navigateToProfileView: Binding<Bool>, cameraCapture: CameraPhotoCapture, selectedAllergies: Set<String>, responseText: Binding<String>, allergenImage: Binding<Image?>) {
//            self._recognizedItems = recognizedItems
//            self._showAlert = showAlert
//            self._navigateToProfileView = navigateToProfileView
//            self.cameraCapture = cameraCapture
//            self.selectedAllergies = selectedAllergies
//            self._responseText = responseText
//            self._allergenImage = allergenImage // Bind allergenImage
//            super.init()
//        }
//
//        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
//            print("Selected Allergies: \(selectedAllergies)")
//            for item in addedItems {
//                if case let .text(text) = item {
//                    Task {
//                        await checkForAllergens(text.transcript)
//                    }
//                }
//            }
//        }
//
//        func checkForAllergens(_ text: String) async {
//            do {
//                let model = GenerativeModel(
//                    name: "gemini-1.5-flash",
//                    apiKey: APIKey.default
//                )
//
//                let allergiesPrompt = selectedAllergies.isEmpty
//                    ? "Analyze the ingredients."
//                    : "Analyze the following text and identify any ingredients that could be harmful based on the following allergies: \(selectedAllergies.joined(separator: ", "))."
//
//                let chatSession = model.startChat(history: [])
//                let response = try await chatSession.sendMessage("\(allergiesPrompt) \(text)")
//                self.responseText = response.text ?? "No response received"
//
//                print("Gemini response: \(self.responseText)")
//
//                if response.text?.containsAllergen(for: selectedAllergies) ?? false {
//                    print("Allergen detected!")
//                    showAlert = true
//                    allergenImage = Image(systemName: "xmark.circle.fill") // Show red X mark
//                    allergenImage?.foregroundColor(.red)
//                    await showImageCaptureAndNavigateToProfile(dataScanner: dataScanner)
//                } else {
//                    allergenImage = Image(systemName: "checkmark.circle.fill") // Show green check mark
//                    allergenImage?.foregroundColor(.green)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.responseText = "Error: \(error.localizedDescription)"
//                    print("Error during allergen check: \(error.localizedDescription)")
//                }
//            }
//        }
//
//        private func showImageCaptureAndNavigateToProfile(dataScanner: DataScannerViewController?) async {
//            guard let dataScanner = dataScanner else {
//                print("DataScanner is nil")
//                return
//            }
//
//            do {
//                let image = try await dataScanner.capturePhoto()
//                guard let imageData = image.jpegData(compressionQuality: 0.9) else {
//                    print("Failed to convert captured image to JPEG data.")
//                    return
//                }
//
//                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("preview.jpeg")
//                try imageData.write(to: url)
//
//                self.cameraCapture.capturedImage = image
//                self.navigateToProfileView = true
//            } catch {
//                print("Error capturing photo: \(error.localizedDescription)")
//            }
//        }
//
//
//        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
//            self.recognizedItems.removeAll { removedItem in
//                removedItems.contains(where: { $0.id == removedItem.id })
//            }
//        }
//
//
//        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
//            print("Scanner became unavailable with error \(error.localizedDescription)")
//        }
//    }
//}
//
//extension String {
//    func containsAllergen(for allergens: Set<String>) -> Bool {
//        for allergen in allergens {
//            if localizedCaseInsensitiveContains(allergen) {
//                return true
//            }
//        }
//        return false
//    }
//}


//import SwiftUI
//import VisionKit
//import AVFoundation
//import GoogleGenerativeAI
//
//struct DataScannerView: UIViewControllerRepresentable {
//    @Binding var recognizedItems: [RecognizedItem]
//    @Binding var showAlert: Bool
//    @Binding var navigateToProfileView: Bool
//    let recognizedDataType: DataScannerViewController.RecognizedDataType
//    let recognizesMultipleItems: Bool
//    var cameraCapture: CameraPhotoCapture
//    @Binding var selectedAllergies: Set<String>
//    @Binding var responseText: String
//
//    func makeUIViewController(context: Context) -> DataScannerViewController {
//        let vc = DataScannerViewController(
//            recognizedDataTypes: [recognizedDataType],
//            qualityLevel: .balanced,
//            recognizesMultipleItems: recognizesMultipleItems,
//            isGuidanceEnabled: true,
//            isHighlightingEnabled: true
//        )
//        vc.delegate = context.coordinator
//        context.coordinator.dataScanner = vc
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
//        if navigateToProfileView {
//            uiViewController.stopScanning()
//        } else {
//            try? uiViewController.startScanning()
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(
//            recognizedItems: $recognizedItems,
//            showAlert: $showAlert,
//            navigateToProfileView: $navigateToProfileView,
//            cameraCapture: cameraCapture,
//            selectedAllergies: selectedAllergies,
//            responseText: $responseText
//        )
//    }
//
//    class Coordinator: NSObject, DataScannerViewControllerDelegate {
//        @Binding var recognizedItems: [RecognizedItem]
//        @Binding var showAlert: Bool
//        @Binding var navigateToProfileView: Bool
//        var capturedImage: UIImage?
//        var cameraCapture: CameraPhotoCapture
//        var selectedAllergies: Set<String>
//        var dataScanner: DataScannerViewController?
//        @Binding var responseText: String
//
//        init(recognizedItems: Binding<[RecognizedItem]>, showAlert: Binding<Bool>, navigateToProfileView: Binding<Bool>, cameraCapture: CameraPhotoCapture, selectedAllergies: Set<String>, responseText: Binding<String>) {
//            self._recognizedItems = recognizedItems
//            self._showAlert = showAlert
//            self._navigateToProfileView = navigateToProfileView
//            self.cameraCapture = cameraCapture
//            self.selectedAllergies = selectedAllergies
//            self._responseText = responseText
//            super.init()
//        }
//
//        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
//            print("Selected Allergies: \(selectedAllergies)")
//            for item in addedItems {
//                switch item {
//                case .text(let text):
//                    Task {
//                        await checkForAllergens(text.transcript)
//                    }
//                default:
//                    break
//                }
//            }
//        }
//
//        // func checkForAllergens(_ text: String) async {
//        //     do {
//        //         let model = GenerativeModel(
//        //             name: "gemini-1.5-flash",
//        //             apiKey: APIKey.default
//        //         )
//              
//        //         let allergiesPrompt = selectedAllergies.isEmpty
//        //             ? "Analyze the ingredients."
//        //             : "Analyze the following text and identify any ingredients that could be harmful based on the following allergies: \(selectedAllergies.joined(separator: ", "))."
//                
//        //         let chatSession = model.startChat(history: [])
//        //         let response = try await chatSession.sendMessage("\(allergiesPrompt) \(text)")
//        //         self.responseText = response.text ?? "No response received"
//                
//        //         print("Gemini response: \(self.responseText)")
//
//        //         if response.text?.containsAllergen(for: selectedAllergies) ?? false {
//        //             print("Allergen detected!")
//        //             showAlert = true
//        //             showImageCaptureAndNavigateToProfile(dataScanner: dataScanner)
//        //         }
//        //     } catch {
//        //         DispatchQueue.main.async {
//        //             self.responseText = "Error: \(error.localizedDescription)"
//        //         }
//        //         print("Error during allergen check: \(error.localizedDescription)")
//        //     }
//        // }
//
//        // private func showImageCaptureAndNavigateToProfile(dataScanner: DataScannerViewController?) {
//        //     DispatchQueue.main.async {
//        //         Task {
//        //             do {
//        //                 guard let dataScanner = dataScanner else {
//        //                     print("DataScanner is nil")
//        //                     return
//        //                 }
//        //                 let image = try await dataScanner.capturePhoto()
//        //                 let url = try FileManager.default
//        //                     .url(for: .documentDirectory,
//        //                          in: .userDomainMask,
//        //                          appropriateFor: nil,
//        //                          create: true)
//        //                     .appendingPathComponent("preview.jpeg")
//        //                 if let data = image.jpegData(compressionQuality: 0.9) {
//        //                     try data.write(to: url)
//        //                 }
//
//        //                 self.cameraCapture.capturedImage = image
//        //                 self.navigateToProfileView = true
//        //             } catch {
//        //                 print("Error capturing photo: \(error.localizedDescription)")
//        //             }
//        //         }
//        //     }
//        // }
//
//
//// Inside the Coordinator class, update the checkForAllergens method:
//func checkForAllergens(_ text: String) async {
//    do {
//        let model = GenerativeModel(
//            name: "gemini-1.5-flash",
//            apiKey: APIKey.default
//        )
//        
//        let allergiesPrompt = selectedAllergies.isEmpty
//            ? "Analyze the ingredients."
//            : "Analyze the following text and identify any ingredients that could be harmful based on the following allergies: \(selectedAllergies.joined(separator: ", "))."
//        
//        let chatSession = model.startChat(history: [])
//        let response = try await chatSession.sendMessage("\(allergiesPrompt) \(text)")
//        
//        await MainActor.run {
//            self.responseText = response.text ?? "No response received"
//            print("Gemini response: \(self.responseText)")
//            
//            if response.text?.containsAllergen(for: selectedAllergies) ?? false {
//                print("Allergen detected!")
//                showAlert = true
//                showImageCaptureAndNavigateToProfile(dataScanner: dataScanner)
//            }
//        }
//    } catch {
//        await MainActor.run {
//            self.responseText = "Error: \(error.localizedDescription)"
//            print("Error during allergen check: \(error.localizedDescription)")
//        }
//    }
//}
//
//private func showImageCaptureAndNavigateToProfile(dataScanner: DataScannerViewController?) {
//    Task {
//        do {
//            guard let dataScanner = dataScanner else {
//                print("DataScanner is nil")
//                return
//            }
//            
//            let image = try await dataScanner.capturePhoto()
//            self.cameraCapture.capturedImage = image
//            
//            // Save image to file system
//            if let data = image.jpegData(compressionQuality: 0.9) {
//                let url = try FileManager.default
//                    .url(for: .documentDirectory,
//                         in: .userDomainMask,
//                         appropriateFor: nil,
//                         create: true)
//                    .appendingPathComponent("preview.jpeg")
//                try data.write(to: url)
//                print("Photo saved successfully")
//            }
//            
//            await MainActor.run {
//                self.navigateToProfileView = true
//            }
//        } catch {
//            print("Error capturing photo: \(error.localizedDescription)")
//        }
//    }
//}
//
//        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
//            self.recognizedItems = recognizedItems.filter { item in
//                !removedItems.contains(where: { $0.id == item.id })
//            }
//        }
//
//        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
//            print("became unavailable with error \(error.localizedDescription)")
//        }
//    }
//}
//
//extension String {
//    func containsAllergen(for allergens: Set<String>) -> Bool {
//        for allergen in allergens {
//            if self.localizedCaseInsensitiveContains(allergen) {
//                return true
//            }
//        }
//        return false
//    }
//}




import SwiftUI
import VisionKit
import AVFoundation
import GoogleGenerativeAI

struct DataScannerView: UIViewControllerRepresentable {
    @Binding var recognizedItems: [RecognizedItem]
    @Binding var showAlert: Bool
    @Binding var navigateToHelloView: Bool // Added navigation state
    let recognizedDataType: DataScannerViewController.RecognizedDataType
    let recognizesMultipleItems: Bool
    var cameraCapture: CameraPhotoCapture
    @Binding var selectedAllergies: Set<String>
    @Binding var responseText: String

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [recognizedDataType],
            qualityLevel: .balanced,
            recognizesMultipleItems: recognizesMultipleItems,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        vc.delegate = context.coordinator
        context.coordinator.dataScanner = vc
        return vc
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if navigateToHelloView {
            uiViewController.stopScanning()
        } else {
            try? uiViewController.startScanning()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            recognizedItems: $recognizedItems,
            showAlert: $showAlert,
            navigateToHelloView: $navigateToHelloView, // Updated binding
            cameraCapture: cameraCapture,
            selectedAllergies: selectedAllergies,
            responseText: $responseText
        )
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Binding var recognizedItems: [RecognizedItem]
        @Binding var showAlert: Bool
        @Binding var navigateToHelloView: Bool // Control navigation to HelloView
        var capturedImage: UIImage?
        var cameraCapture: CameraPhotoCapture
        var selectedAllergies: Set<String>
        var dataScanner: DataScannerViewController?
        @Binding var responseText: String

        init(recognizedItems: Binding<[RecognizedItem]>, showAlert: Binding<Bool>, navigateToHelloView: Binding<Bool>, cameraCapture: CameraPhotoCapture, selectedAllergies: Set<String>, responseText: Binding<String>) {
            self._recognizedItems = recognizedItems
            self._showAlert = showAlert
            self._navigateToHelloView = navigateToHelloView // Initialize navigation state
            self.cameraCapture = cameraCapture
            self.selectedAllergies = selectedAllergies
            self._responseText = responseText
            super.init()
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            for item in addedItems {
                switch item {
                case .text(let text):
                    Task {
                        await checkForAllergens(text.transcript)
                        self.navigateToHelloView = true // Trigger navigation
                    }
                default:
                    break
                }
            }
        }

        func checkForAllergens(_ text: String) async {
            do {
                let model = GenerativeModel(
                    name: "gemini-1.5-flash",
                    apiKey: APIKey.default
                )

                let allergiesPrompt = selectedAllergies.isEmpty
                    ? "Analyze the ingredients."
                    : "Analyze the following text and identify any ingredients that could be harmful based on the following allergies: \(selectedAllergies.joined(separator: ", "))."

                let chatSession = model.startChat(history: [])
                let response = try await chatSession.sendMessage("\(allergiesPrompt) \(text)")
                self.responseText = response.text ?? "No response received"

                print("Gemini response: \(self.responseText)")

                if response.text?.containsAllergen(for: selectedAllergies) ?? false {
                    print("Allergen detected!")
                    showAlert = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.responseText = "Error: \(error.localizedDescription)"
                }
                print("Error during allergen check: \(error.localizedDescription)")
            }
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            self.recognizedItems = recognizedItems.filter { item in
                !removedItems.contains(where: { $0.id == item.id })
            }
        }

        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("became unavailable with error \(error.localizedDescription)")
        }
    }
}

extension String {
    func containsAllergen(for allergens: Set<String>) -> Bool {
        for allergen in allergens {
            if self.localizedCaseInsensitiveContains(allergen) {
                return true
            }
        }
        return false
    }
}
