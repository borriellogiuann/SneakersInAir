import SwiftUI
import AVFoundation

struct AuthorizationChecker {
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

extension AuthorizationChecker {
    enum Status {
        case permitted
        case notPermitted
    }
}

let session = AVCaptureSession()
let previewLayer = AVCaptureVideoPreviewLayer(session: session)

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

class PhotoContentViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    var imageSave: UIImage = UIImage()
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
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error capturing photo: \(error!.localizedDescription)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            print("Error converting photo data to image")
            return
        }
        
        // Handle captured image
        print("Captured photo: \(image)")
        imageSave = image
    }
    
    func capturePhoto() {
        guard let output = session.photoOutput else {
            print("Cannot find photo output")
            return
        }
        
        let photoSettings = AVCapturePhotoSettings()
        output.capturePhoto(with: photoSettings, delegate: self)
        
    }
    
    func saveImage() -> String {
        print(imageSave)
        guard let data = imageSave.jpegData(compressionQuality: 1) else {
            return "1"
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return "2"
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.jpeg")!)
            return "4"
        } catch {
            print(error.localizedDescription)
            return "3"
        }
    }
}

struct PhotoContentView: View {
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @StateObject var viewModel = PhotoContentViewModel()
    
    var body: some View {
        ZStack{
            viewModel.preview?
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .ignoresSafeArea()
            Image(systemName: "viewfinder")
                .frame(width: 0, height: 0, alignment: .center)
                .font(.system(size: 300))
                .fontWeight(.light)
                .opacity(0.7)
                .foregroundStyle(CustomColor.CustomOrange)
            Image(systemName: "shoe")
                .frame(width: 0, height: 0, alignment: .center)
                .font(.system(size: 150))
                .fontWeight(.light)
                .opacity(0.7)
                .foregroundStyle(.white)
            Button(action: {
                viewModel.capturePhoto()
                let success = viewModel.saveImage()
                print(success)
            }) {
                Image(systemName: "camera.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
            }
            Button(action: {
                print(getDocumentsDirectory())
            }, label: {
                Text("daadhaiudaw")
            })
        }
        
    }
}
