//
//  CameraView.swift
//  SneakersInAir
//
//  Created by Salvo on 26/02/24.
//

import SwiftUI
import PopupView
import _PhotosUI_SwiftUI
import SwiftyJSON

struct CameraView: View {
    
    @ObservedObject var cameraViewModel = CameraViewModel()
    var apiManager = APIManager()
    @StateObject var viewModel = PhotoPickerViewModel()
    
    @State var image = UIImage(named: "ff")
    @State var isShowingPopup: Bool = false
    @State var shoeName: String = "test"
    @State var shoeImageLink: URL = URL(string: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco,u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/3914f9b5-be4f-4a18-8a2c-c03a65158ffa/scarpa-jordan-true-flight-J5Ntdp.png")!
    @State var json: JSON = JSON()
    @State var uiImageView: UIImageView = UIImageView()
    @State var disableCamera: Bool = false
    @State var fill: CGFloat = 0.0
    @State var cameraAnimationNumber: Double = 0
    @State var aboutUs = false
    @State var pictureTaken = false
    
    var body: some View {
        NavigationView{
            
            GeometryReader { geometry in
                ZStack {
                    if(!pictureTaken){
                        CameraPreview(session: cameraViewModel.session)
                            .ignoresSafeArea()
                    }else{
                        Image(uiImage: (apiManager.loadPhoto() ?? UIImage(named: "scarpavuota"))!)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                            .frame(maxWidth: UIScreen.width/1.2, maxHeight: UIScreen.height/1.1)
                    }
                    
                    VStack(spacing: 0) {
                        HStack{
                            Button(action: {
                                cameraViewModel.switchFlash()
                            }, label: {
                                Image(systemName: cameraViewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                                    .font(.system(size: 30, weight: .medium, design: .default))
                            })
                            .foregroundStyle(cameraViewModel.isFlashOn ? .yellow : .white)
                            
                            Spacer()
                            
                            Button(action: {
                                aboutUs = true
                            }, label: {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 30, weight: .medium, design: .default))
                            })
                            .foregroundStyle(.white)
                            .sheet(isPresented: $aboutUs, content: {
                                AboutUsView()
                            })
                        }
                        
                        
                        Text("")
                            .padding(0)
                            .popup(isPresented: $isShowingPopup, view: {
                                NavigationLink(destination: FullShoeView(json: $json, shoeImage: $uiImageView), label: {
                                    PopupShoeView(shoeName: $shoeName, uiImageView: $uiImageView, json: $json)
                                })
                            }, customize: {
                                $0
                                    .type(.floater())
                                    .position(.top)
                                    .animation(.spring())
                                    .dragToDismiss(true)
                                    .closeOnTap(true)
                            })
                        
                        Spacer()
                        
                        Button(action: {
                            disableCamera.toggle()
                            cameraAnimationNumber = 0
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                                fill = 1
                            }
                            for x in 0...30{
                                DispatchQueue.main.asyncAfter(deadline: .now()+TimeInterval(Double(x)+1)){
                                    cameraAnimationNumber += 3.35
                                    if cameraAnimationNumber >= 100 {
                                        cameraAnimationNumber = 100
                                    }
                                }
                            }
                            cameraViewModel.captureImage()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                image = cameraViewModel.getImage()
                                apiManager.uploadImageToImgur(image: image!)
                                pictureTaken = true
                                if(cameraViewModel.isFlashOn){
                                    cameraViewModel.switchFlash()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                                    if let imgurLink = apiManager.imgurLink {
                                        apiManager.fetchDataFromServer(imageUrl: imgurLink)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                        shoeName = apiManager.shoeName ?? "nonarriva"
                                        shoeImageLink = apiManager.shoeImageLink!
                                        print(shoeImageLink.absoluteString)
                                        uiImageView.downloaded(from: shoeImageLink)
                                        json = apiManager.finalJson ?? JSON()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                            isShowingPopup = true
                                            disableCamera = false
                                            fill = 0.0
                                            cameraAnimationNumber = 0
                                            pictureTaken = false
                                            
                                        }
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 30){
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
                                            .animation(Animation.linear(duration: 30))
                                        
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
                    /*
                     HStack{
                     VStack{
                     Spacer()
                     VStack() {
                     PhotosPicker(selection: $viewModel.imageSelection){
                     if let image = viewModel.selectedImage {
                     Image (uiImage: image)
                     .resizable ()
                     .scaledToFill()
                     .frame(width: 60, height: 60)
                     .cornerRadius(10)
                     }else{
                     Image("scarpavuota")
                     .resizable()
                     .clipShape(RoundedRectangle(cornerRadius: 20))
                     .frame(width: 60, height: 60)
                     
                     }
                     }
                     .padding(20)
                     .padding(.bottom, 20)
                     }
                     }
                     Spacer()
                     }
                     */
                }
            }
            .onAppear {
                cameraViewModel.checkForDevicePermission()
            }
        }
        .tint(.customorange)
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
