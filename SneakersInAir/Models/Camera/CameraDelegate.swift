//
//  CameraDelegate.swift
//  SneakersInAir
//
//  Created by Salvo on 26/02/24.
//

import Foundation
import UIKit
import AVFoundation

class CameraDelegate: NSObject, AVCapturePhotoCaptureDelegate {
 
   private let completion: (UIImage?) -> Void
 
   init(completion: @escaping (UIImage?) -> Void) {
      self.completion = completion
   }
 
   func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
       print("capture output")
      if let error {
         print("CameraManager: Error while capturing photo: \(error)")
         completion(nil)
         return
      }
  
      if let imageData = photo.fileDataRepresentation(), let capturedImage = UIImage(data: imageData) {
         saveImage(image: capturedImage)
         completion(capturedImage)
      } else {
         print("CameraManager: Image not fetched.")
      }
   }
 
    func saveImage(image: UIImage) {
            print("save")
            guard let data = image.jpegData(compressionQuality: 1) else {
                return
            }
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return
            }
            do {
                try data.write(to: directory.appendingPathComponent("fotina.jpeg")!)
                try data.write(to: directory.appendingPathComponent("fotina.jpeg")!)
                return
            } catch {
                print(error.localizedDescription)
                return
            }
        }
}
