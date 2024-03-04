//
//  CameraView.swift
//  SneakersInAir
//
//  Created by Salvo on 26/02/24.
//

import SwiftUI
import PopupView

struct CameraView: View {
    
    @ObservedObject var cameraViewModel = CameraViewModel()
    var apiManager = APIManager()
    @StateObject var viewModel = PhotoPickerViewModel()
    
    @State var image = UIImage(named: "ff")
    @State var isShowingPopup: Bool = false
    @State var shoeName: String = "test"
    @State var shoeImageLink: URL = URL(string: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/3914f9b5-be4f-4a18-8a2c-c03a65158ffa/scarpa-jordan-true-flight-J5Ntdp.png")!
    @State var uiImageView: UIImageView = UIImageView()
    @State var disableCamera: Bool = false
    @State var fill: CGFloat = 0.0
    @State var cameraAnimationNumber: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraPreview(session: cameraViewModel.session)
                
                VStack(spacing: 0) {
                    HStack{
                        Button(action: {
                            cameraViewModel.switchFlash()
                        }, label: {
                            Image(systemName: cameraViewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                                .font(.system(size: 30, weight: .medium, design: .default))
                        })
                        .accentColor(cameraViewModel.isFlashOn ? .yellow : .white)
                        
                        Spacer()
                    }
                    
                    Text("")
                        .padding(0)
                        .popup(isPresented: $isShowingPopup, view: {
                            PopupShoeView(shoeName: $shoeName, uiImageView: $uiImageView)
                        }, customize: {
                            $0
                                .type(.floater())
                                .position(.top)
                                .animation(.spring())
                                .closeOnTapOutside(true)
                        })
                    
                    Spacer()
                    
                    Button(action: {
                        disableCamera.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                            fill = 1
                        }
                        for x in 0...120{
                            DispatchQueue.main.asyncAfter(deadline: .now()+TimeInterval(Double(x)/2.01)){
                                cameraAnimationNumber += 0.83
                                if cameraAnimationNumber >= 100 {
                                    cameraAnimationNumber = 100
                                }
                            }
                        }
                        cameraViewModel.captureImage()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            image = cameraViewModel.getImage()
                            apiManager.uploadImageToImgur(image: image!)
                            if(cameraViewModel.isFlashOn){
                                cameraViewModel.switchFlash()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                if let imgurLink = apiManager.imgurLink {
                                    apiManager.fetchDataFromServer(imageUrl: imgurLink)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 33) {
                                    shoeName = apiManager.shoeName ?? "nonarriva"
                                    shoeImageLink = apiManager.shoeImageLink!
                                    print(shoeImageLink.absoluteString)
                                    uiImageView.downloaded(from: shoeImageLink)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                                        isShowingPopup = true
                                        disableCamera = false
                                        fill = 0.0
                                        cameraAnimationNumber = 0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 50) {
                                            isShowingPopup = false
                                        }
                                    }
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 60){
                                if let imgurDeleteHash = apiManager.deleteHash {
                                    apiManager.deleteImageFromImgur(deleteHash: imgurDeleteHash)
                                }
                            }
                        }
                    }) {
                        ZStack{
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 70, height: 70, alignment: .center)
                                .overlay(
                                    Circle()
                                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                                        .frame(width: 59, height: 59, alignment: .center)
                                )
                            if(disableCamera){
                                ZStack {
                                    
                                    Circle()
                                        .stroke(Color(.systemGray5), lineWidth: 15)
                                        .frame(width: 70, height: 70)
                                    
                                    Circle()
                                        .trim(from: 0, to: fill)
                                        .stroke(.customorange, lineWidth: 15)
                                        .frame(width: 70, height: 70)
                                        .rotationEffect(.init(degrees: -90))
                                        .animation(Animation.linear(duration: 60))
                                    
                                    Text("\(Int(cameraAnimationNumber))%")
                                        .foregroundStyle(.customblack)
                                        .font(.body)
                                }
                            }
                        }
                    }
                    .disabled(disableCamera ? true : false)
                }
                .padding(35)
            }
        }
        .onAppear {
            cameraViewModel.checkForDevicePermission()
        }
    }
}



// use to open app's setting
func openSettings() {
    let settingsUrl = URL(string: UIApplication.openSettingsURLString)
    if let url = settingsUrl {
        UIApplication.shared.open(url, options: [:])
    }
}


#Preview {
    CameraView()
}
