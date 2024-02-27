//
//  CameraViewModel.swift
//  SneakersInAir
//
//  Created by Salvo on 26/02/24.
//

import Foundation
import AVFoundation
import UIKit

class PhotoContentViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    let session: AVCaptureSession
    @Published var preview: Preview?
    
    override init() {
        self.session = AVCaptureSession()
        
        super.init()
        
        Task(priority: .background) {
            switch await AuthorizationChecker.checkCaptureAuthorizationStatus() {
            case .permitted:
                try session
                    .addPhotoInput()
                    .addPhotoOutput()
                    .startRunning()
                
                DispatchQueue.main.async {
                    self.preview = Preview(with: self.session, gravity: .resizeAspectFill)
                }
                
            case .notPermitted:
                break
            }
        }
    }
    
    
    func capturePhoto() {
        print ("cattura")
        guard let output = session.photoOutput else {
            print("Cannot find photo output")
            return
        }
        
        let photoSettings = AVCapturePhotoSettings()
        output.capturePhoto(with: photoSettings, delegate: CameraDelegate())
        
    }
    
    func getImage() -> UIImage{
        var image: UIImage = UIImage()
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
           let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("fotina.jpeg")
            image    = UIImage(contentsOfFile: imageURL.path) ?? UIImage(named: "ff")!
           // Do whatever you want with the image
        }else{
            print("dioporco")
        }
        return image
    }
    
}
