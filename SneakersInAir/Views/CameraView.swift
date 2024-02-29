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
    
    @State var image = UIImage(named: "ff")
    @State var isShowingPopup: Bool = false
    @State var shoeName: String = "tt"
    @State var shoeVariant: String = "ttt"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraPreview(session: cameraViewModel.session)
                /*
                PopupShoeView(shoeName: "aaaaa", shoeVariant: "aaaaa")
                    .popup(isPresented: $isShowingPopup) {
                } customize: {
                    $0
                        .type(.floater())
                        .position(.top)
                        .animation(.spring())
                        .closeOnTapOutside(true)
                        .backgroundColor(.black.opacity(0.5))
                }
                 */
                VStack(spacing: 0) {
                    Button(action: {
                        // Call method to on/off flash light
                    }, label: {
                        Image(systemName: cameraViewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 20, weight: .medium, design: .default))
                    })
                    .accentColor(cameraViewModel.isFlashOn ? .yellow : .white)
                    
                    Spacer()
                    
                    Image(uiImage: image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    Button(action: {
                        cameraViewModel.captureImage()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            image = cameraViewModel.getImage()
                            apiManager.uploadImageToImgur(image: image!)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                if let imgurLink = apiManager.imgurLink {
                                    apiManager.fetchDataFromServer(imageUrl: imgurLink)
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 20){
                                if let imgurDeleteHash = apiManager.deleteHash {
                                    apiManager.deleteImageFromImgur(deleteHash: imgurDeleteHash)
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                isShowingPopup.toggle()
                            }
                        }
                    }) {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70, alignment: .center)
                            .overlay(
                                Circle()
                                    .stroke(Color.black.opacity(0.8), lineWidth: 2)
                                    .frame(width: 59, height: 59, alignment: .center)
                            )
                    }
                }
                .padding(20)
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
