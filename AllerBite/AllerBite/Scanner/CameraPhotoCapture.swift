//import Foundation
//import AVFoundation
//import UIKit
//
//class CameraPhotoCapture: ObservableObject {
//    var captureSession: AVCaptureSession!
//    var stillImageOutput: AVCapturePhotoOutput!
//    var delegate: MyDelegate! // Declare delegate inside the class
//    @Published var capturedImage: UIImage?
//    var isCapturing: Bool = false // Flag to track if capture is in progress
//    private let captureQueue = DispatchQueue(label: "com.allerbite.captureQueue") // Serial queue for capturing
//    
//    init() {
//        captureSession = AVCaptureSession()
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//        stillImageOutput = AVCapturePhotoOutput()
//        delegate = MyDelegate(cameraCapture: self) // Initialize the delegate
//        
//        checkCameraPermissions()
//    }
//    
//    // Request camera permissions
//    func checkCameraPermissions() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            // Already authorized, setup the session
//            setupSession()
//        case .notDetermined:
//            // Request authorization
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if granted {
//                    DispatchQueue.main.async {
//                        self.setupSession()
//                    }
//                } else {
//                    print("User denied camera access.")
//                }
//            }
//        case .denied, .restricted:
//            print("Camera access has been restricted.")
//        @unknown default:
//            print("Unknown camera permission status.")
//        }
//    }
//    
//    func setupSession() {
//        guard let device = AVCaptureDevice.default(for: .video) else {
//            print("No video device found.")
//            return
//        }
//        
//        do {
//            let input = try AVCaptureDeviceInput(device: device)
//            
//            if captureSession.canAddInput(input) {
//                captureSession.addInput(input)
//            }
//            
//            if captureSession.canAddOutput(stillImageOutput) {
//                captureSession.addOutput(stillImageOutput)
//                captureSession.startRunning()
//            }
//        } catch {
//            print("Error setting up camera input: \(error)")
//        }
//    }
//    
//    func captureScreenshot() {
//        captureQueue.async {
//            guard !self.isCapturing else {
//                print("Capture already in progress.")
//                return // Prevent multiple captures
//            }
//            
//            DispatchQueue.main.async {
//                self.isCapturing = true // Set flag to indicate capture in progress
//                let settingsForMonitoring = AVCapturePhotoSettings()
//                
//                // Ensure proper settings for devices that may not support flash or stabilization
//                if self.stillImageOutput.supportedFlashModes.contains(.auto) {
//                    settingsForMonitoring.flashMode = .auto
//                } else {
//                    settingsForMonitoring.flashMode = .off
//                }
//                
//                settingsForMonitoring.isAutoStillImageStabilizationEnabled = self.stillImageOutput.isStillImageStabilizationSupported
//                settingsForMonitoring.isHighResolutionPhotoEnabled = false
//                
//                self.stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self.delegate)
//            }
//        }
//    }
//    
//    // Reset the isCapturing flag after capture
//    func captureDidFinish() {
//        DispatchQueue.main.async {
//            self.isCapturing = false // Reset the flag on the main thread after capture finishes
//        }
//    }
//}
//
//class MyDelegate: NSObject, AVCapturePhotoCaptureDelegate {
//    weak var cameraCapture: CameraPhotoCapture? // Reference to CameraPhotoCapture class to reset the flag
//    
//    init(cameraCapture: CameraPhotoCapture) {
//        self.cameraCapture = cameraCapture
//    }
//    
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        defer {
//            // Reset the capture flag when capture is complete
//            cameraCapture?.captureDidFinish()
//        }
//        
//        if let err = error {
//            print("Error capturing photo: \(err.localizedDescription)")
//            return
//        }
//        
//        guard let photoSampleBuffer = photoSampleBuffer else {
//            print("No photo sample buffer.")
//            return
//        }
//        
//        if let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
//            do {
//                let url = try FileManager.default
//                    .url(for: .documentDirectory,
//                         in: .userDomainMask,
//                         appropriateFor: nil,
//                         create: true)
//                    .appendingPathComponent("preview.jpeg")
//                try photoData.write(to: url)
//                print("Photo saved at \(url)")
//            } catch {
//                print("Error saving photo: \(error.localizedDescription)")
//            }
//        }
//    }
//}




//import Foundation
//import AVFoundation
//import UIKit
//
//class CameraPhotoCapture: ObservableObject {
//    var captureSession: AVCaptureSession!
//    var stillImageOutput: AVCapturePhotoOutput!
//    var delegate: MyDelegate! // Declare delegate inside the class
//    @Published var capturedImage: UIImage?
//    @Published var isCapturing: Bool = false // Updated to @Published for better thread-safety
//    private let captureQueue = DispatchQueue(label: "com.allerbite.captureQueue") // Serial queue for capturing
//    
//    init() {
//        captureSession = AVCaptureSession()
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//        stillImageOutput = AVCapturePhotoOutput()
//        delegate = MyDelegate(cameraCapture: self) // Initialize the delegate
//        
//        checkCameraPermissions()
//    }
//    
//    // Request camera permissions
//    func checkCameraPermissions() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            setupSession()
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                if granted {
//                    DispatchQueue.main.async {
//                        self.setupSession()
//                    }
//                } else {
//                    print("User denied camera access.")
//                }
//            }
//        case .denied, .restricted:
//            print("Camera access has been restricted.")
//        @unknown default:
//            print("Unknown camera permission status.")
//        }
//    }
//    
//    func setupSession() {
//        guard let device = AVCaptureDevice.default(for: .video) else {
//            print("No video device found.")
//            return
//        }
//
//        do {
//            let input = try AVCaptureDeviceInput(device: device)
//            
//            // Add input to capture session
//            if captureSession.canAddInput(input) {
//                captureSession.addInput(input)
//            }
//            
//            // Initialize stillImageOutput and add it to the session
//            let stillImageOutput = AVCapturePhotoOutput()
//            if captureSession.canAddOutput(stillImageOutput) {
//                captureSession.addOutput(stillImageOutput)
//                self.stillImageOutput = stillImageOutput
//            } else {
//                print("Cannot add photo output.")
//            }
//            
//            // Start session on background thread
//            DispatchQueue.global(qos: .userInitiated).async {
//                self.captureSession.startRunning()
//            }
//        } catch {
//            print("Error setting up camera input: \(error)")
//        }
//    }
//
//    
//   func captureScreenshot() {
//       captureQueue.async {
//           DispatchQueue.main.async {
//               guard !self.isCapturing else {
//                   print("Capture already in progress.")
//                   return // Prevent multiple captures
//               }
//               
//               self.isCapturing = true // Set flag to indicate capture in progress
//               let settingsForMonitoring = AVCapturePhotoSettings()
//               
//               if self.stillImageOutput.supportedFlashModes.contains(.auto) {
//                   settingsForMonitoring.flashMode = .auto
//               } else {
//                   settingsForMonitoring.flashMode = .off
//               }
//               
//               settingsForMonitoring.isAutoStillImageStabilizationEnabled = self.stillImageOutput.isStillImageStabilizationSupported
//               settingsForMonitoring.isHighResolutionPhotoEnabled = false
//               
//               self.stillImageOutput.capturePhoto(with: settingsForMonitoring, delegate: self.delegate)
//           }
//       }
//   }
//    
//    // Reset the isCapturing flag after capture
//    func captureDidFinish() {
//        DispatchQueue.main.async {
//            self.isCapturing = false // Reset the flag on the main thread after capture finishes
//        }
//    }
//}
//
//class MyDelegate: NSObject, AVCapturePhotoCaptureDelegate {
//    weak var cameraCapture: CameraPhotoCapture? // Reference to CameraPhotoCapture class to reset the flag
//    
//    init(cameraCapture: CameraPhotoCapture) {
//        self.cameraCapture = cameraCapture
//    }
//    
//    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//        defer {
//            cameraCapture?.captureDidFinish() // Reset the capture flag after capture is complete
//        }
//        
//        if let err = error {
//            print("Error capturing photo: \(err.localizedDescription)")
//            return
//        }
//        
//        guard let photoSampleBuffer = photoSampleBuffer else {
//            print("No photo sample buffer.")
//            return
//        }
//        
//        if let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
//             do {
//            let url = try FileManager.default
//                .url(for: .documentDirectory,
//                     in: .userDomainMask,
//                     appropriateFor: nil,
//                     create: true)
//                .appendingPathComponent("preview.jpeg")
//            try photoData.write(to: url)
//            print("Photo saved at \(url)")
//            
//            // Set the captured image and update UI on main thread
//            if let image = UIImage(data: photoData) {
//                DispatchQueue.main.async {
//                    self.cameraCapture?.capturedImage = image
//                }
//            }
//        }  catch {
//                print("Error saving photo: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//



import Foundation
import AVFoundation
import UIKit

var delegate = MyDelegate()

class CameraPhotoCapture: ObservableObject {
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    @Published var capturedImage: UIImage?
    
    init(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        stillImageOutput = AVCapturePhotoOutput()
        
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if (captureSession.canAddInput(input)) {
                    captureSession.addInput(input)
                    if (captureSession.canAddOutput(stillImageOutput)) {
                        captureSession.addOutput(stillImageOutput)
                        captureSession.startRunning()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func captureScreenshot() {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: delegate)
    }
}

class MyDelegate : NSObject, AVCapturePhotoCaptureDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let err = error{
            print(error)
        }
        if let photoSampleBuffer = photoSampleBuffer {
            if let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
                do {
                    let url = try FileManager.default
                        .url(for: .documentDirectory,
                             in: .userDomainMask,
                             appropriateFor: nil,
                             create: true)
                        .appendingPathComponent("preview.jpeg")
                    try photoData.write(to: url)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

