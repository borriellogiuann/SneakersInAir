//
//  CameraView.swift
//  SneakersInAir
//
//  Created by Salvo on 26/02/24.
//

import SwiftUI

struct CameraView: View {
    
    @ObservedObject var viewModel = CameraViewModel()
    
    @State var image = UIImage(named: "ff")
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    Button(action: {
                        // Call method to on/off flash light
                    }, label: {
                        Image(systemName: viewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 20, weight: .medium, design: .default))
                    })
                    .accentColor(viewModel.isFlashOn ? .yellow : .white)
                    
                    CameraPreview(session: viewModel.session)
                    
                    HStack {
                        Group {
                            Image(uiImage: image!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                    Spacer()
                    Button(action: {
                        viewModel.captureImage()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            image = viewModel.getImage()
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
            viewModel.checkForDevicePermission()
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
