//
//  CameraViewModel.swift
//  SneakersInAir
//
//  Created by Salvo on 26/02/24.
//

import Foundation
import AVFoundation
import UIKit
import Combine

class CameraViewModel: ObservableObject {
    
    // Reference to the CameraManager.
    var cameraManager = CameraManager()
    
    // Published properties to trigger UI updates.
    @Published var isFlashOn = false
    @Published var showAlertError = false
    @Published var showSettingAlert = false
    @Published var isPermissionGranted: Bool = false
    
    // Cancellable storage for Combine subscribers.
    private var cancelables = Set<AnyCancellable>()
    
    // Reference to the AVCaptureSession.
    var session: AVCaptureSession = .init()
    
    init() {
        // Initialize the session with the cameraManager's session.
        session = cameraManager.session
    }
    
    deinit {
        // Deinitializer to stop capturing when the ViewModel is deallocated.
        cameraManager.stopCapturing()
    }
    
    // Check for camera device permission.
    func checkForDevicePermission() {
        let videoStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if videoStatus == .authorized {
            // If Permission granted, configure the camera.
            isPermissionGranted = true
            configureCamera()
        } else if videoStatus == .notDetermined {
            // In case the user has not been asked to grant access we request permission
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { _ in })
        } else if videoStatus == .denied {
            // If Permission denied, show a setting alert.
            isPermissionGranted = false
            showSettingAlert = true
        }
    }
    
    // Configure the camera through the CameraManager to show a live camera preview.
    func configureCamera() {
        cameraManager.configureCaptureSession()
    }
    
    @Published var capturedImage: UIImage?
    
    // add new closure for getting updated values form the manager class publishers
    func setupBindings() {
        cameraManager.$capturedImage.sink { [weak self] image in
            self?.capturedImage = image
        }.store(in: &cancelables)
    }
    
    // Call when the capture button tap
    func captureImage() {
        cameraManager.captureImage()
    }
    
    func getImage() -> UIImage{
        print("getting new image")
        var image: UIImage = UIImage()
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
           let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("fotina.jpeg")
           image    = UIImage(contentsOfFile: imageURL.path)!
           // Do whatever you want with the image
        }
        return image
    }
    
}
