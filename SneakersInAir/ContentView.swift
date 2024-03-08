//
//  ContentView.swift
//  SneakersInAir
//
//  Created by Giovanni Borriello on 13/02/24.
//

import SwiftUI
import SwiftyJSON

struct ContentView: View {
    
    let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
    
    var body: some View {
        @Environment(\.colorScheme) var colorScheme: ColorScheme
            CameraView()
            

        
        .onAppear(){
            UITabBar.appearance().backgroundColor = schemeTransform(userInterfaceStyle: currentSystemScheme) == .light ? UIColor.customwhite : UIColor.customblack
        }
        /*
        VStack(spacing: 40) {
            Text ("Scanner")
            
            if let image = viewModel.selectedImage {
                Image (uiImage: image)
                    .resizable ()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
            }
            PhotosPicker(selection: $viewModel.imageSelection){
                Image(systemName: "heart")
            }
        }
        */
    }
}

#Preview {
    ContentView()
}

func schemeTransform(userInterfaceStyle:UIUserInterfaceStyle) -> ColorScheme {
    if userInterfaceStyle == .light {
        return .light
    }else if userInterfaceStyle == .dark {
        return .dark
    }
    return .light}
