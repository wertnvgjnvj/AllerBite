// import SwiftUI

// struct CameraScanner: View {
//     @Environment(\.presentationMode) var presentationMode
//     var body: some View {
//         NavigationView {
//             Text("Scanning View")
//                 .toolbar {
//                     ToolbarItem(placement: .navigationBarLeading) {
//                         Button {
// self.presentationMode.wrappedValue.dismiss()
//                         } label: {
//                               Text("Cancel")
//                         }
//                     }
//                 }
//                 .interactiveDismissDisabled(true)
//         }
//     }
// }
//import SwiftUI
//
//struct CameraScanner: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject private var cameraCapture = CameraPhotoCapture() // Initialize CameraPhotoCapture
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Display captured image if available
//                if let capturedImage = cameraCapture.capturedImage {
//                    Image(uiImage: capturedImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 300)
//                        .padding()
//                } else {
//                    Text("No image captured")
//                        .foregroundColor(.gray)
//                        .padding()
//                }
//                
//                Spacer()
//
//                // Button to capture the image
//                Button(action: {
//                    cameraCapture.captureScreenshot()
//                }) {
//                    Text("Capture Photo")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(cameraCapture.isCapturingPhoto ? Color.gray : Color.blue)
//                        .cornerRadius(10)
//                }
//                .padding()
//                .disabled(cameraCapture.isCapturingPhoto) // Disable the button when photo is being captured
//                
//                Spacer()
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button {
//                        self.presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Text("Cancel")
//                    }
//                }
//            }
//            .interactiveDismissDisabled(true) // Disable swipe to dismiss
//        }
//    }
//}


//import SwiftUI
//import VisionKit
//
//struct CameraScanner: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject private var cameraCapture = CameraPhotoCapture()
//    @State private var recognizedText: String = ""
//    @State private var showResultSheet = false
//    @State private var responseText: String = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                DataScannerView(
//                    recognizedItems: .constant([]),
//                    showAlert: .constant(false),
//                    navigateToProfileView: $showResultSheet,
//                    recognizedDataType: .text(),
//                    recognizesMultipleItems: true,
//                    cameraCapture: cameraCapture,
//                    selectedAllergies: .constant(Set<String>()),
//                    responseText: $responseText
//                )
//                .ignoresSafeArea()
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $showResultSheet) {
//                ResultSheetView(responseText: $responseText)
//            }
//        }
//    }
//}


//import SwiftUI
//import VisionKit
//
//struct CameraScanner: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject private var cameraCapture = CameraPhotoCapture()
//    @State private var recognizedText: String = ""
//    @State private var showResultSheet = false
//    @State private var showNextView = false
//    @State private var responseText: String = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                DataScannerView(
//                    recognizedItems: .constant([]),
//                    showAlert: .constant(false),
//                    navigateToProfileView: $showResultSheet,
//                    recognizedDataType: .text(),
//                    recognizesMultipleItems: true,
//                    cameraCapture: cameraCapture,
//                    selectedAllergies: .constant(Set<String>()),
//                    responseText: $responseText
//                )
//                .ignoresSafeArea()
//                
//                // New button to navigate to NextView
//                Button(action: {
//                    showNextView.toggle()
//                }) {
//                    Text("Go to Next View")
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                }
//                .padding()
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $showResultSheet) {
//                ResultSheetView(responseText: $responseText)
//            }
//            .fullScreenCover(isPresented: $showNextView) {
//                ResultSheetView(responseText: $responseText)
//            }
//        }
//    }
//}


//import SwiftUI
//import VisionKit
//
//struct CameraScanner: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject private var cameraCapture = CameraPhotoCapture()
//    @State private var recognizedText: String = ""
//    @State private var showResultSheet = false
//    @State private var showNextView = false
//    @State private var responseText: String = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Scanner view
//                DataScannerView(
//                    recognizedItems: .constant([]),
//                    showAlert: .constant(false),
//                    navigateToProfileView: $showResultSheet,
//                    recognizedDataType: .text(),
//                    recognizesMultipleItems: true,
//                    cameraCapture: cameraCapture,
//                    selectedAllergies: .constant(Set<String>()),
//                    responseText: $responseText
//                )
//                .ignoresSafeArea()
//                
//                // Button to navigate to the next view
//                Button(action: {
//                    showNextView.toggle()
//                }) {
//                    Text("Go to Next View")
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                }
//                .padding()
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $showResultSheet) {
//                ResultSheetView(responseText: $responseText)
//            }
//            .fullScreenCover(isPresented: $showNextView) {
////                NextView(responseText: $responseText)
//            }
//        }
//    }
//}



import SwiftUI

struct CameraScanner: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Text("Scanning View")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
self.presentationMode.wrappedValue.dismiss()
                        } label: {
                              Text("Cancel")
                        }
                    }
                }
                .interactiveDismissDisabled(true)
        }
    }
}
