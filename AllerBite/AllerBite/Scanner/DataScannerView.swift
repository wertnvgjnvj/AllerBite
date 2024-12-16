
import SwiftUI
import VisionKit
import AVFoundation
import GoogleGenerativeAI

struct DataScannerView: UIViewControllerRepresentable {
    @Binding var recognizedItems: [RecognizedItem]
    @Binding var showAlert: Bool
    @Binding var navigateToHelloView: Bool
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
            navigateToHelloView: $navigateToHelloView,
            cameraCapture: cameraCapture,
            selectedAllergies: selectedAllergies,
            responseText: $responseText
        )
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Binding var recognizedItems: [RecognizedItem]
        @Binding var showAlert: Bool
        @Binding var navigateToHelloView: Bool
        var cameraCapture: CameraPhotoCapture
        var selectedAllergies: Set<String>
        @Binding var responseText: String
        var dataScanner: DataScannerViewController?

        init(recognizedItems: Binding<[RecognizedItem]>, showAlert: Binding<Bool>, navigateToHelloView: Binding<Bool>, cameraCapture: CameraPhotoCapture, selectedAllergies: Set<String>, responseText: Binding<String>) {
            self._recognizedItems = recognizedItems
            self._showAlert = showAlert
            self._navigateToHelloView = navigateToHelloView
            self.cameraCapture = cameraCapture
            self.selectedAllergies = selectedAllergies
            self._responseText = responseText
            super.init()
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            if let item = addedItems.first, case let .text(text) = item {
                Task {
                    await processScannedIngredients(text.transcript)
                    DispatchQueue.main.async {
                        self.navigateToHelloView = true
                    }
                }
            }
        }

        func processScannedIngredients(_ scannedText: String) async {
            do {
                let model = GenerativeModel(
                    name: "gemini-1.5-flash",
                    apiKey: APIKey.default
                )

                // Constructing a comprehensive prompt for better AI understanding
                let allergiesPrompt = FirestoreManager.userSavedAllergies.isEmpty
                    ? "Below is the list of ingredients. Analyze them and determine if the product is safe for general use. If unsafe, explain why."
                    : "Below is the list of ingredients. Check if any of these ingredients match the following allergies: \(FirestoreManager.userSavedAllergies.joined(separator: ", ")). If unsafe, explain why."
                print("hi !\(scannedText)")
                let prompt = """
                \(allergiesPrompt)

                Ingredients:
                \(scannedText)
                """

                let chatSession = model.startChat(history: [])
                let response = try await chatSession.sendMessage(prompt)

                DispatchQueue.main.async {
                    self.responseText = response.text ?? "No detailed response received from Gemini."
                }

                if let response = response.text, response.lowercased().contains("unsafe") {
                    DispatchQueue.main.async {
                        self.showAlert = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.responseText = "Error: \(error.localizedDescription)"
                }
                print("Error during ingredient analysis: \(error.localizedDescription)")
            }
        }
    }
}
