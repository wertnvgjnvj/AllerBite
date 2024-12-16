

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import VisionKit
import AVFoundation
import GoogleGenerativeAI

// MainView where the camera scanner starts
struct MainView: View {
    @State private var recognizedItems: [RecognizedItem] = []
    @State private var showAlert: Bool = false
    @State private var navigateToHelloView: Bool = false
    @State private var selectedAllergies: Set<String> = []
    @State private var responseText: String = ""
//    @Binding var tabSelection: Int

    var body: some View {
        NavigationView {
            VStack {
                if navigateToHelloView {
                    NavigationLink(
                        destination: helloView(
                            responseText: $responseText,
                            selectedAllergies: $selectedAllergies
//                            tabSelection: $tabSelection
                        ),
                        isActive: $navigateToHelloView,
                        label: { EmptyView() }
                    )
                }

                DataScannerView(
                    recognizedItems: $recognizedItems,
                    showAlert: $showAlert,
                    navigateToHelloView: $navigateToHelloView,
                    recognizedDataType: .text(),
                    recognizesMultipleItems: true,
                    cameraCapture: CameraPhotoCapture(),
                    selectedAllergies: $selectedAllergies,
                    responseText: $responseText
                )
            }
            .onAppear {
                loadSavedAllergies()
            }
        }
    }

    private func loadSavedAllergies() {
        if let savedAllergies = UserDefaults.standard.array(forKey: "savedAllergies") as? [String] {
            self.selectedAllergies = Set(savedAllergies)
        }
    }
}
