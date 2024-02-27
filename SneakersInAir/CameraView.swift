//
//  CameraView.swift
//  SneakersInAir
//
//  Created by Salvo on 26/02/24.
//

import SwiftUI

struct PhotoContentView: View {
    
    @StateObject var viewModel = PhotoContentViewModel()
    @State var immagine: UIImage
    
    var body: some View {
        
        VStack{
            viewModel.preview?
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .ignoresSafeArea()
                .onAppear{
                    immagine = viewModel.getImage()
                }
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
            }) {
                Image(systemName: "camera.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
            }
            Button(action: {
                immagine = viewModel.getImage()
            }, label: {
                Text("getImage")
                Image(uiImage: immagine)
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
            })
        }
        
    }
}

#Preview {
    PhotoContentView(immagine: UIImage())
}
