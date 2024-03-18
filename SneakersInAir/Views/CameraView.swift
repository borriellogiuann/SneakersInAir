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
    @ObservedObject var apiManager = APIManager()
    @ObservedObject var viewModel = PhotoPickerViewModel()
    
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
    @State var imgurLink = ""
    @State var isLoading = false
    
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
                            cameraViewModel.captureImage()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                image = cameraViewModel.getImage()
                                pictureTaken = true
                                if(cameraViewModel.isFlashOn){
                                    cameraViewModel.switchFlash()
                                }
                                Task{
                                    await upload(image: image!)
                                    await fetchDataFromServer()
                                    await updateImageOnUI()
                                    await deleteImageFromImgur()
                                }
                            }
                        }, label: {
                            ZStack{
                                Circle()
                                    .foregroundColor(.customwhite)
                                    .frame(width: UIScreen.width/5, height: UIScreen.height/8, alignment: .center)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black.opacity(0.8), lineWidth: 2)
                                            .frame(width: UIScreen.width/5.7, height: UIScreen.height/9, alignment: .center)
                                    )
                                if(disableCamera){
                                    ZStack {
                                     
                                        Circle()
                                            .stroke(Color(.systemGray5), lineWidth: 14)
                                            .frame(width: UIScreen.width/5, height: UIScreen.height/8)
                             
                                        Circle()
                                            .trim(from: 0, to: 0.2)
                                            .stroke(Color.customorange, lineWidth: 7)
                                            .frame(width: UIScreen.width/5, height: UIScreen.height/8)
                                            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                                            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                                            .onAppear() {
                                                self.isLoading = true
                                                self.isShowingPopup = false
                                        }
                                    }
                                }
                            }
                        })
                        .disabled(disableCamera ? true : false)
                        .padding(.bottom, -20)
                    }
                    .padding(40)
                }
            }
            .onAppear {
                cameraViewModel.checkForDevicePermission()
            }
        }
        .tint(.customorange)
    }
    
    func upload(image: UIImage) async {
        print("1. Uploading image")
        do {
            try await apiManager.uploadImageToImgur(image: image)
            print("1. ✅")
        } catch {
            print("An error occurred in uploading image to imgur")
        }
    }
    
    func fetchDataFromServer() async {
        print("2. Fetching server data")
        do {
            /// Fetch data from server
            try await apiManager.fetchDataFromServer(imageUrl: apiManager.imgurLink ?? "No imgur link")
            print("2. ✅")
        } catch {
            print("An error occurred in getting infos from the server")
        }
        
        shoeName = apiManager.shoeName!
        shoeImageLink = apiManager.shoeImageLink!
        json = apiManager.finalJson!
        
    }
    
    func updateImageOnUI() async {
        print("3. Update UIImage with image from server")
        do {
            /// Place the image in the UIImageView
            try await uiImageView.downloaded(from: shoeImageLink)
            print("3. ✅")
        } catch {
            print("An error occurred in getting the photo")
        }
        
        isShowingPopup = true
        disableCamera = false
        fill = 0.0
        cameraAnimationNumber = 0
        pictureTaken = false
    }
    
    func deleteImageFromImgur() async {
        print("4. Delete image from server")
        do {
            /// Delete the image
            try await apiManager.deleteImageFromImgur(deleteHash: apiManager.deleteHash ?? "no delete hash")
            print("delete hash" + (apiManager.deleteHash ?? "no delete hash"))
            print("4. ✅")
        }
        catch {
            print("An error occurred in deleting the photo")
        }
        isLoading = false
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
