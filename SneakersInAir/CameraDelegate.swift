//
//  CameraDelegate.swift
//  SneakersInAir
//
//  Created by Salvo on 26/02/24.
//

import Foundation
import AVFoundation
import UIKit

class CameraDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print ("output")
        guard error == nil else {
            print("Error capturing photo: \(error!.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            print("Error converting photo data to image")
            return
        }
        
        // Handle captured image
        saveImage(immagine: image)
        
    }
    
    func saveImage(immagine: UIImage) -> String {
        
        print("salva")
        
        guard let data = immagine.jpegData(compressionQuality: 1) else {
            return "1"
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return "2"
        }
        do {
            try data.write(to: directory.appendingPathComponent("fotina.jpeg")!)
            return "4"
        } catch {
            print(error.localizedDescription)
            return "3"
        }
    }
    
}
