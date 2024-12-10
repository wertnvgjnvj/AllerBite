//import SwiftUI
//import VisionKit
//
//struct MainView: View {
//    @EnvironmentObject var vm: AppViewModel
//    @State var isAlertVisible = false
//    @State private var isSettingViewActive = false
//    @State private var isMainViewActive = false
//    @State private var navigateToProfileView: Bool = false
//    @State private var isSheetVisible = false
//    @State private var selectedAllergies = Set<String>()
//    @ObservedObject private var cameraCapture = CameraPhotoCapture()
//    @State private var alertMessage = ""
//    @State private var showScanner = true
//    @State private var responseText = ""
//
//    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = []
//
//    var body: some View {
//        if showScanner {
//            switch vm.dataScannerAccessStatus {
//            case .scannerAvailable:
//                mainView
//            case .cameraNotAvailable:
//                Text("Your device doesn't have a camera")
//            case .scannerNotAvailable:
//                Text("Your device doesn't have support for scanning barcode with this app")
//            case .cameraAccessNotGranted:
//                Text("Please provide access to the camera in settings")
//            case .notDetermined:
//                Text("Requesting camera access")
//            }
//        }
//    }
//
//    private var mainView: some View {
//        return DataScannerView(
//            recognizedItems: $vm.recognizedItems,
//            showAlert: $isAlertVisible,
//            navigateToProfileView: $navigateToProfileView,
//            recognizedDataType: vm.recognizedDataType,
//            recognizesMultipleItems: vm.recognizesMultipleItems,
//            cameraCapture: cameraCapture,
//            selectedAllergies: $selectedAllergies,
//            responseText: $responseText
//        )
//        .onAppear {
//            vm.scanType = .text
//            loadSavedAllergies()
//        }
//        .background { Color.gray.opacity(0.3) }
//        .ignoresSafeArea()
//        .id(vm.dataScannerViewId)
//        .fullScreenCover(isPresented: $navigateToProfileView) {
//            ResultSheetView(responseText: $responseText)
//        }
//        .sheet(isPresented: $isSheetVisible) {
//            bottomContainerView
//                .background(.ultraThinMaterial)
//                .presentationDetents([.medium, .fraction(0.25)])
//                .presentationDragIndicator(.visible)
//                .interactiveDismissDisabled()
//                .onAppear {
//                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                          let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
//                        return
//                    }
//                    controller.view.backgroundColor = .clear
//                }
//        }
//        .onChange(of: vm.scanType) { _ in vm.recognizedItems = [] }
//        .onChange(of: vm.textContentType) { _ in vm.recognizedItems = [] }
//        .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = [] }
//    }
//
//    private var headerView: some View {
//        VStack {
//            HStack {
//                Picker("Scan Type", selection: $vm.scanType) {
//                    Text("Text").tag(ScanType.text)
//                    Text("Barcode").tag(ScanType.barcode)
//                }.pickerStyle(.segmented)
//            }.padding(.top)
//
//            if vm.scanType == .text {
//                Picker("Text content type", selection: $vm.textContentType) {
//                    ForEach(textContentTypes, id: \.self.textContentType) { option in
//                        Text(option.title).tag(option.textContentType)
//                    }
//                }.pickerStyle(.segmented)
//            }
//
//            Text(vm.headerText).padding(.top)
//        }.padding(.horizontal)
//    }
//
//    private var bottomContainerView: some View {
//        VStack {
//            headerView
//            ScrollView {
//                LazyVStack(alignment: .leading, spacing: 16) {
//                    ForEach(vm.recognizedItems) { item in
//                        switch item {
//                        case .text(let text):
//                            Text(text.transcript)
//                        case .barcode(let barcode):
//                            Text(barcode.payloadStringValue ?? "Unknown barcode")
//                        @unknown default:
//                            Text("Unknown")
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//    }
//
//    private var backButtonView: some View {
//        NavigationLink(destination: ContentView()) {
//            Image(systemName: "chevron.left")
//                .foregroundColor(.black)
//                .padding()
//                .background(Color.white)
//                .clipShape(Circle())
//                .shadow(radius: 2)
//        }
//    }
//
//    private func loadSavedAllergies() {
//        if let savedAllergies = UserDefaults.standard.array(forKey: "savedAllergies") as? [String] {
//            print("Loaded saved allergies:", savedAllergies)
//            self.selectedAllergies = Set(savedAllergies)
//        }
//    }
//}


//import SwiftUI
//import VisionKit
//
//struct MainView: View {
//    @EnvironmentObject var vm: AppViewModel
//    @State var isAlertVisible = false
//    @State private var isSettingViewActive = false
//    @State private var isMainViewActive = false
//    @State private var navigateToProfileView: Bool = false
//    @State private var isSheetVisible = false
//    @State private var selectedAllergies = Set<String>()
//    @ObservedObject private var cameraCapture = CameraPhotoCapture()
//    @State private var alertMessage = ""
//    @State private var showScanner = true
//    @State private var responseText = ""
//    @State private var allergenImage: Image? = nil // New state for allergen image
//    
//    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = []
//    
//    var body: some View {
//        if showScanner {
//            switch vm.dataScannerAccessStatus {
//            case .scannerAvailable:
//                mainView
//            case .cameraNotAvailable:
//                Text("Your device doesn't have a camera")
//            case .scannerNotAvailable:
//                Text("Your device doesn't have support for scanning barcode with this app")
//            case .cameraAccessNotGranted:
//                Text("Please provide access to the camera in settings")
//            case .notDetermined:
//                Text("Requesting camera access")
//            }
//        }
//    }
//    
//    private var mainView: some View {
//        VStack {
//            if let allergenImage = allergenImage {
//                allergenImage
//                    .resizable()
//                    .frame(width: 100, height: 100)
//            }
//            
//            DataScannerView(
//                recognizedItems: $vm.recognizedItems,
//                showAlert: $isAlertVisible,
//                navigateToProfileView: $navigateToProfileView,
//                recognizedDataType: vm.recognizedDataType,
//                recognizesMultipleItems: vm.recognizesMultipleItems,
//                cameraCapture: cameraCapture,
//                selectedAllergies: $selectedAllergies,
//                responseText: $responseText
////                allergenImage: $allergenImage // Pass allergenImage to scanner view
//            )
//            .onAppear {
//                vm.scanType = .text
//                loadSavedAllergies()
//            }
//            .background { Color.gray.opacity(0.3) }
//            .ignoresSafeArea()
//            .id(vm.dataScannerViewId)
//            .fullScreenCover(isPresented: $navigateToProfileView) {
//                ResultSheetView(responseText: $responseText)
//            }
//            .sheet(isPresented: $isSheetVisible) {
//                bottomContainerView
//                    .background(.ultraThinMaterial)
//                    .presentationDetents([.medium, .fraction(0.25)])
//                    .presentationDragIndicator(.visible)
//                    .interactiveDismissDisabled()
//                    .onAppear {
//                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                              let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
//                            return
//                        }
//                        controller.view.backgroundColor = .clear
//                    }
//            }
//            .onChange(of: vm.dataScannerAccessStatus) { newStatus in
//                if newStatus == .scannerAvailable {
//                    isMainViewActive.toggle()
//                }
//            }
//        }
//    }
//    
//    private func loadSavedAllergies() {
//        if let savedAllergies = UserDefaults.standard.array(forKey: "savedAllergies") as? [String] {
//            print("Loaded saved allergies:", savedAllergies)
//            self.selectedAllergies = Set(savedAllergies)
//        }
//    }
//    
//    var bottomContainerView: some View {
//        VStack(spacing: 20) {
//            // Title for the bottom sheet
//            Text("Allergen Summary")
//                .font(.headline)
//                .padding()
//            
//            // Display the list of selected allergens
//            if !selectedAllergies.isEmpty {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 10) {
//                        ForEach(Array(selectedAllergies), id: \.self) { allergen in
//                            Text(allergen)
//                                .font(.body)
//                                .padding(.vertical, 5)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .background(Color.gray.opacity(0.1))
//                                .cornerRadius(8)
//                        }
//                    }
//                    .padding()
//                }
//            } else {
//                // Message to show if no allergens are selected
//                Text("No allergens detected.")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding()
//            }
//            
//            // Button to close the sheet
//            Button(action: {
//                isSheetVisible.toggle()  // Close the sheet
//            }) {
//                Text("Close")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding(.horizontal)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(20)
//    }
//}
//


//import SwiftUI
//import VisionKit
//
//struct MainView: View {
//    @EnvironmentObject var vm: AppViewModel
//    @State var isAlertVisible = false
//    @State private var isSettingViewActive = false
//    @State private var isMainViewActive = false
//    @State private var navigateToProfileView: Bool = false
//    @State private var isSheetVisible = false
//    @State private var selectedAllergies = Set<String>()
//    @ObservedObject private var cameraCapture = CameraPhotoCapture()
//    @State private var alertMessage = ""
//    @State private var showScanner = true
//    @State private var responseText = ""
//
//    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = []
//
//    var body: some View {
//        if showScanner {
//            switch vm.dataScannerAccessStatus {
//            case .scannerAvailable:
//                mainView
//            case .cameraNotAvailable:
//                Text("Your device doesn't have a camera")
//            case .scannerNotAvailable:
//                Text("Your device doesn't have support for scanning barcode with this app")
//            case .cameraAccessNotGranted:
//                Text("Please provide access to the camera in settings")
//            case .notDetermined:
//                Text("Requesting camera access")
//            }
//        }
//    }
//
//    private var mainView: some View {
//        return DataScannerView(
//            recognizedItems: $vm.recognizedItems,
//            showAlert: $isAlertVisible,
//            navigateToProfileView: $navigateToProfileView,
//            recognizedDataType: vm.recognizedDataType,
//            recognizesMultipleItems: vm.recognizesMultipleItems,
//            cameraCapture: cameraCapture,
//            selectedAllergies: $selectedAllergies,
//            responseText: $responseText
//        )
//        .onAppear {
//            vm.scanType = .text
//            loadSavedAllergies()
//        }
//        .background { Color.gray.opacity(0.3) }
//        .ignoresSafeArea()
//        .id(vm.dataScannerViewId)
//        .fullScreenCover(isPresented: $navigateToProfileView) {
//            ResultSheetView(responseText: $responseText)
//        }
//        .sheet(isPresented: $isSheetVisible) {
//            bottomContainerView
//                .background(.ultraThinMaterial)
//                .presentationDetents([.medium, .fraction(0.25)])
//                .presentationDragIndicator(.visible)
//                .interactiveDismissDisabled()
//                .onAppear {
//                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                          let controller = windowScene.windows.first?.rootViewController?.presentedViewController else {
//                        return
//                    }
//                    controller.view.backgroundColor = .clear
//                }
//        }
//        .onChange(of: vm.scanType) { _ in vm.recognizedItems = [] }
//        .onChange(of: vm.textContentType) { _ in vm.recognizedItems = [] }
//        .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = [] }
//    }
//
//    private var headerView: some View {
//        VStack {
//            HStack {
//                Picker("Scan Type", selection: $vm.scanType) {
//                    Text("Text").tag(ScanType.text)
//                    Text("Barcode").tag(ScanType.barcode)
//                }.pickerStyle(.segmented)
//            }.padding(.top)
//
//            if vm.scanType == .text {
//                Picker("Text content type", selection: $vm.textContentType) {
//                    ForEach(textContentTypes, id: \.self.textContentType) { option in
//                        Text(option.title).tag(option.textContentType)
//                    }
//                }.pickerStyle(.segmented)
//            }
//
//            Text(vm.headerText).padding(.top)
//        }.padding(.horizontal)
//    }
//
//    private var bottomContainerView: some View {
//        VStack {
//            headerView
//            ScrollView {
//                LazyVStack(alignment: .leading, spacing: 16) {
//                    ForEach(vm.recognizedItems) { item in
//                        switch item {
//                        case .text(let text):
//                            Text(text.transcript)
//                        case .barcode(let barcode):
//                            Text(barcode.payloadStringValue ?? "Unknown barcode")
//                        @unknown default:
//                            Text("Unknown")
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//    }
//
//    private var backButtonView: some View {
//        NavigationLink(destination: ContentView()) {
//            Image(systemName: "chevron.left")
//                .foregroundColor(.black)
//                .padding()
//                .background(Color.white)
//                .clipShape(Circle())
//                .shadow(radius: 2)
//        }
//    }
//
//    private func loadSavedAllergies() {
//        if let savedAllergies = UserDefaults.standard.array(forKey: "savedAllergies") as? [String] {
//            print("Loaded saved allergies:", savedAllergies)
//            self.selectedAllergies = Set(savedAllergies)
//        }
//    }
//}



//import SwiftUI
//import VisionKit
//
//struct MainView: View {
//    @State private var recognizedItems: [RecognizedItem] = []
//    @State private var showAlert: Bool = false
//    @State private var navigateToHelloView: Bool = false // Navigation state
//    @State private var selectedAllergies: Set<String> = []
//    @State private var responseText: String = ""
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if navigateToHelloView {
//                    NavigationLink(
//                        destination: helloView( responseText: $responseText, selectedAllergies: $selectedAllergies),
//                        isActive: $navigateToHelloView,
//                        label: { EmptyView() }
//                    )
//                }
//
//                DataScannerView(
//                    recognizedItems: $recognizedItems,
//                    showAlert: $showAlert,
//                    navigateToHelloView: $navigateToHelloView, // Pass navigation binding
//                    recognizedDataType: .text(),
//                    recognizesMultipleItems: true,
//                    cameraCapture: CameraPhotoCapture(),
//                    selectedAllergies: $selectedAllergies,
//                    responseText: $responseText
//                )
//            }
//        }
//    }
//
//
//
//
//    private func loadSavedAllergies() {
//        if let savedAllergies = UserDefaults.standard.array(forKey: "savedAllergies") as? [String] {
//            self.selectedAllergies = Set(savedAllergies)
//        }
//    }
//}


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

    var body: some View {
        NavigationView {
            VStack {
                if navigateToHelloView {
                    NavigationLink(
                        destination: helloView(
                            responseText: $responseText,
                            selectedAllergies: $selectedAllergies
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
