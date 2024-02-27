//
//  Camera.swift
//  SneakersInAir
//
//  Created by Salvo on 26/02/24.
//

import Foundation
import SwiftUI
import AVFoundation

struct AuthorizationChecker {
    
    enum Status {
        case permitted
        case notPermitted
    }
    
    static func checkCaptureAuthorizationStatus() async -> Status {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return .permitted
            
        case .notDetermined:
            let isPermissionGranted = await AVCaptureDevice.requestAccess(for: .video)
            if isPermissionGranted {
                return .permitted
            } else {
                fallthrough
            }
            
        case .denied:
            fallthrough
            
        case .restricted:
            fallthrough
            
        @unknown default:
            return .notPermitted
        }
    }
}

extension AVCaptureSession {
    var photoOutput: AVCapturePhotoOutput? {
        let output = self.outputs.first as? AVCapturePhotoOutput
        return output
    }
    
    func addPhotoInput() throws -> Self {
        // Add video input
        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        let videoInput = try AVCaptureDeviceInput(device: videoDevice!)
        self.canAddInput(videoInput)
        
        self.addInput(videoInput)
        
        return self
    }
    
    func addPhotoOutput() throws -> Self {
        guard self.photoOutput == nil else {
            // return itself if output is already set
            return self
        }
        
        let photoOutput = AVCapturePhotoOutput()
        self.canAddOutput(photoOutput)
        self.addOutput(photoOutput)
        
        return self
    }
}

let session = AVCaptureSession()
let previewLayer = AVCaptureVideoPreviewLayer(session: session)

struct Preview: UIViewControllerRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer
    let gravity: AVLayerVideoGravity
    
    init(
        with session: AVCaptureSession,
        gravity: AVLayerVideoGravity
    ) {
        self.gravity = gravity
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        previewLayer.videoGravity = gravity
        uiViewController.view.layer.addSublayer(previewLayer)
        
        previewLayer.frame = uiViewController.view.bounds
    }
    
    func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        previewLayer.removeFromSuperlayer()
    }
}
