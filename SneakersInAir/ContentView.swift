////
////  ContentView.swift
////  SneakersInAir
////
////  Created by Giovanni Borriello on 13/02/24.
////
//
//import SwiftUI
//import AVFoundation
//import PhotosUI
//
//
//struct CameraPreview: UIViewRepresentable {
//    
//    let session: AVCaptureSession
//    
//    func makeUIView(context: Context) -> some UIView {
//        let view = UIView(frame: .zero)
//        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(previewLayer)
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        // Update the layer size when the view's size changes
//        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
//            previewLayer.frame = uiView.bounds
//        }
//    }
//}
//
//@MainActor
//final class PhotoPickerViewModel: ObservableObject{
//    
//    @Published private(set) var selectedImage: UIImage? = nil
//    @Published var imageSelection: PhotosPickerItem? = nil {
//        didSet {
//            setImage (from: imageSelection)
//        }
//    }
//    
//    private func setImage (from selection: PhotosPickerItem?) {
//        guard let selection else { return }
//        
//        Task {
//            if let data = try? await selection.loadTransferable (type: Data.self) {
//                if let uiImage = UIImage (data: data) {
//                    selectedImage = uiImage
//                    return
//                }
//            }
//        }
//    }
//}
//
//struct ContentView: View {
//    
//    @StateObject private var viewModel = PhotoPickerViewModel()
//    
//    @State private var session = AVCaptureSession()
//    
//    var body: some View {
//        VStack(spacing: 40) {
//            Text ("Scanner")
//
//            CameraPreview(session: session)
//                .ignoresSafeArea()            
//            
//            if let image = viewModel.selectedImage {
//                Image (uiImage: image)
//                    .resizable ()
//                    .scaledToFill()
//                    .frame(width: 200, height: 200)
//                    .cornerRadius(10)
//            }
//            
//            PhotosPicker(selection: $viewModel.imageSelection){
//                Text("PhotoPicker")
//            }
//        }
//        .onAppear {
//            Task {
//                await setUpCaptureSession()
//            }
//        }
//    }
//}
//
//var isAuthorized: Bool {
//    get async {
//        let status = AVCaptureDevice.authorizationStatus(for: .video)
//        
//        // Determine if the user previously authorized camera access.
//        var isAuthorized = status == .authorized
//        
//        // If the system hasn't determined the user's authorization status,
//        // explicitly prompt them for approval.
//        if status == .notDetermined {
//            isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
//        }
//        
//        return isAuthorized
//    }
//}
//
//func setUpCaptureSession() async {
//    guard await isAuthorized else { return }
//    
//    let session = AVCaptureSession()
//    
//    session.beginConfiguration()
//    let videoDevice = AVCaptureDevice.default(for: .video)
//    guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
//        session.canAddInput(videoDeviceInput)
//    else { return }
//    session.addInput(videoDeviceInput)
//    
//    let photoOutput = AVCapturePhotoOutput()
//    guard session.canAddOutput(photoOutput) else { return }
//    session.sessionPreset = .photo
//    session.addOutput(photoOutput)
//    session.commitConfiguration()
//    
//    // Start the capture session
//    session.startRunning()
//}
//
//#Preview {
//    ContentView()
//}
//
////import SwiftUI
////import AVFoundation
////
////
////
////struct AuthorizationChecker {
////    static func checkCaptureAuthorizationStatus() async -> Status {
////        switch AVCaptureDevice.authorizationStatus(for: .video) {
////        case .authorized:
////            return .permitted
////            
////        case .notDetermined:
////            let isPermissionGranted = await AVCaptureDevice.requestAccess(for: .video)
////            if isPermissionGranted {
////                return .permitted
////            } else {
////                fallthrough
////            }
////            
////        case .denied:
////            fallthrough
////            
////        case .restricted:
////            fallthrough
////            
////        @unknown default:
////            return .notPermitted
////        }
////    }
////}
////
////extension AuthorizationChecker {
////    enum Status {
////        case permitted
////        case notPermitted
////    }
////}
////
////let session = AVCaptureSession()
////let previewLayer = AVCaptureVideoPreviewLayer(session: session)
////
////extension AVCaptureSession {
////    var movieFileOutput: AVCaptureMovieFileOutput? {
////        let output = self.outputs.first as? AVCaptureMovieFileOutput
////        
////        return output
////    }
////    
////    func addMovieInput() throws -> Self {
////        // Add video input
////        let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)
////        
////        let videoInput = try AVCaptureDeviceInput(device: videoDevice!)
////        self.canAddInput(videoInput)
////        
////        self.addInput(videoInput)
////        
////        return self
////    }
////    
////    func addMovieFileOutput() throws -> Self {
////        guard self.movieFileOutput == nil else {
////            // return itself if output is already set
////            return self
////        }
////        
////        let fileOutput = AVCaptureMovieFileOutput()
////        self.canAddOutput(fileOutput)
////        self.addOutput(fileOutput)
////        
////        return self
////    }
////}
////
////struct Preview: UIViewControllerRepresentable {
////    let previewLayer: AVCaptureVideoPreviewLayer
////    let gravity: AVLayerVideoGravity
////    
////    init(
////        with session: AVCaptureSession,
////        gravity: AVLayerVideoGravity
////    ) {
////        self.gravity = gravity
////        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
////    }
////    
////    func makeUIViewController(context: Context) -> UIViewController {
////        let viewController = UIViewController()
////        return viewController
////    }
////    
////    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
////        previewLayer.videoGravity = gravity
////        uiViewController.view.layer.addSublayer(previewLayer)
////        
////        previewLayer.frame = uiViewController.view.bounds
////    }
////    
////    func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
////        previewLayer.removeFromSuperlayer()
////    }
////}
////
////class VideoContentViewModel: NSObject, ObservableObject {
////    let session: AVCaptureSession
////    @Published var preview: Preview?
////    
////    override init() {
////        self.session = AVCaptureSession()
////        
////        super.init()
////        
////        Task(priority: .background) {
////            switch await AuthorizationChecker.checkCaptureAuthorizationStatus() {
////            case .permitted:
////                try session
////                    .addMovieInput()
////                    .addMovieFileOutput()
////                    .startRunning()
////                
////                DispatchQueue.main.async {
////                    self.preview = Preview(with: self.session, gravity: .resizeAspectFill)
////                }
////                
////            case .notPermitted:
////                break
////            }
////        }
////    }
////    func startRecording() {
////        guard let output = session.movieFileOutput else {
////            print("Cannot find movie file output")
////            return
////        }
////        
////        guard
////            let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
////        else {
////            print("Cannot access local file domain")
////            return
////        }
////        
////        let fileName = UUID().uuidString
////        let filePath = directoryPath
////            .appendingPathComponent(fileName)
////            .appendingPathExtension("mp4")
////        
////        output.startRecording(to: filePath, recordingDelegate: self)
////    }
////}
////
////extension VideoContentViewModel: AVCaptureFileOutputRecordingDelegate {
////    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
////        print("Video record is finished!")
////    }
////    func stopRecording() {
////        guard let output = session.movieFileOutput else {
////            print("Cannot find movie file output")
////            return
////        }
////        
////        output.stopRecording()
////    }
////}
////
////struct VideoContentView: View {
////    
////    @StateObject var viewModel = VideoContentViewModel()
////    @State private var isRecording = false
////    
////    var body: some View {
////        ZStack{
////            viewModel.preview?
////                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
////                .ignoresSafeArea()
////            Image(systemName: "viewfinder")
////                .frame(width: 0, height: 0, alignment: .center)
////                .font(.system(size: 300))
////                .fontWeight(.light)
////                .opacity(0.7)
////                .foregroundStyle(CustomColor.CustomOrange)
////            Image(systemName: "shoe")
////                .frame(width: 0, height: 0, alignment: .center)
////                .font(.system(size: 150))
////                .fontWeight(.light)
////                .opacity(0.7)
////                .foregroundStyle(.white)
////            Spacer()
////            Button {
////                if isRecording {
////                    viewModel.stopRecording()
////                } else {
////                    viewModel.startRecording()
////                }
////                isRecording.toggle()
////            } label: {
////                Image(systemName: isRecording ? "stop.circle" : "record.circle")
////                    .resizable()
////                    .frame(width: 100, height: 100)
////                    .foregroundColor(.white)
////            }
////            
////        }
////        
////    }
////}
