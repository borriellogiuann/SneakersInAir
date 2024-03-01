//
//  CameraManager.swift
//  SneakersInAir
//
//  Created by Salvo on 26/02/24.
//

import Foundation
import AVFoundation
import UIKit

// this class conforms to ObservableObject to make it easier to use with future Combine code
class CameraManager: ObservableObject {

 // Represents the camera's status
 enum Status {
    case configured
    case unconfigured
    case unauthorized
    case failed
 }
 
 // Observes changes in the camera's status
 @Published var status = Status.unconfigured
    
    @Published private var flashMode: AVCaptureDevice.FlashMode = .off
 
 // AVCaptureSession manages the camera settings and data flow between capture inputs and outputs.
 // It can connect one or more inputs to one or more outputs
 let session = AVCaptureSession()

 // AVCapturePhotoOutput for capturing photos
 let photoOutput = AVCapturePhotoOutput()

 // AVCaptureDeviceInput for handling video input from the camera
 // Basically provides a bridge from the device to the AVCaptureSession
 var videoDeviceInput: AVCaptureDeviceInput?

 // Serial queue to ensure thread safety when working with the camera
 private let sessionQueue = DispatchQueue(label: "com.demo.sessionQueue")
 
 // Method to configure the camera capture session
 func configureCaptureSession() {
    sessionQueue.async { [weak self] in
      guard let self, self.status == .unconfigured else { return }
   
      // Begin session configuration
      self.session.beginConfiguration()

      // Set session preset for high-quality photo capture
      self.session.sessionPreset = .photo
   
      // Add video input from the device's camera
      self.setupVideoInput()
   
      // Add the photo output configuration
      self.setupPhotoOutput()
   
      // Commit session configuration
      self.session.commitConfiguration()

      // Start capturing if everything is configured correctly
      self.startCapturing()
   }
 }
 
 // Method to set up video input from the camera
 private func setupVideoInput() {
   do {
      // Get the default wide-angle camera for video capture
      // AVCaptureDevice is a representation of the hardware device to use
      let camera = AVCaptureDevice.default(for: .video)

      guard let camera else {
         print("CameraManager: Video device is unavailable.")
         status = .unconfigured
         session.commitConfiguration()
         return
      }
   
      // Create an AVCaptureDeviceInput from the camera
      let videoInput = try AVCaptureDeviceInput(device: camera)
   
      // Add video input to the session if possible
      if session.canAddInput(videoInput) {
         session.addInput(videoInput)
         videoDeviceInput = videoInput
         status = .configured
      } else {
         print("CameraManager: Couldn't add video device input to the session.")
         status = .unconfigured
         session.commitConfiguration()
         return
      }
   } catch {
      print("CameraManager: Couldn't create video device input: \(error)")
      status = .failed
      session.commitConfiguration()
      return
   }
 }
 
 // Method to configure the photo output settings
 private func setupPhotoOutput() {
   if session.canAddOutput(photoOutput) {
      // Add the photo output to the session
      session.addOutput(photoOutput)

      // Configure photo output settings
      photoOutput.isHighResolutionCaptureEnabled = true
      photoOutput.maxPhotoQualityPrioritization = .quality // work for ios 15.6 and the older versions
      //photoOutput.maxPhotoDimensions = .init(width: 4032, height: 3024) // for ios 16.0*

      // Update the status to indicate successful configuration
      status = .configured
   } else {
      print("CameraManager: Could not add photo output to the session")
      // Set an error status and return
      status = .failed
      session.commitConfiguration()
      return
   }
 }
 
 // Method to start capturing
 private func startCapturing() {
   if status == .configured {
      // Start running the capture session
      self.session.startRunning()
   } else if status == .unconfigured || status == .unauthorized {
      print("errore status")
   }
 }

 // Method to stop capturing
 func stopCapturing() {
   // Ensure thread safety using `sessionQueue`.
   sessionQueue.async { [weak self] in
      guard let self else { return }

      // Check if the capture session is currently running.
      if self.session.isRunning {
         // stops the capture session and any associated device inputs.
         self.session.stopRunning()
      }
   }
 }
    
    @Published var capturedImage: UIImage? = nil

    private var cameraDelegate: CameraDelegate?

    func captureImage() {
       sessionQueue.async { [weak self] in
          guard let self else { return }
      
          // Configure photo capture settings
          var photoSettings = AVCapturePhotoSettings()
      
          // Capture HEIC photos when supported
          if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
             photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
          }
      
          photoSettings.isHighResolutionPhotoEnabled = true
      
          // Specify photo quality and preview format
          if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
             photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
          }

          photoSettings.photoQualityPrioritization = .quality
      
          if let videoConnection = photoOutput.connection(with: .video), videoConnection.isVideoOrientationSupported {
             videoConnection.videoOrientation = .portrait
          }
      
          cameraDelegate = CameraDelegate { [weak self] image in
             self?.capturedImage = image
          }
      
          if let cameraDelegate {
             // Capture the photo with delegate
             self.photoOutput.capturePhoto(with: photoSettings, delegate: cameraDelegate)
          }
       }
    }

    func toggleTorch(tourchIsOn: Bool) {
       // Access the default video capture device.
       guard let device = AVCaptureDevice.default(for: .video) else { return }
          // Check if the device has a torch (flashlight).
          if device.hasTorch {
            do {
                // Lock the device configuration for changes.
                try device.lockForConfiguration()

                // Set the flash mode based on the torchIsOn parameter.
                flashMode = tourchIsOn ? .on : .off

                // If torchIsOn is true, turn the torch on at full intensity.
                if tourchIsOn {
                   try device.setTorchModeOn(level: 1.0)
                } else {
                   // If torchIsOn is false, turn the torch off.
                   device.torchMode = .off
                }
                // Unlock the device configuration.
                device.unlockForConfiguration()
            } catch {
            // Handle any errors during configuration changes.
            print("Failed to set torch mode: \(error).")
          }
       } else {
          print("Torch not available for this device.")
       }
    }
    
}
