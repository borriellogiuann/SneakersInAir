//
//  ContentView.swift
//  SneakersInAir
//
//  Created by Giovanni Borriello on 13/02/24.
//

import SwiftUI

struct ContentView: View {
    
    let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
    
    var body: some View {
        @Environment(\.colorScheme) var colorScheme: ColorScheme
        TabView {
            CameraView()
                .tabItem {
                    Image(systemName: "plus.viewfinder")
                    Text("Scan")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
            DropView()
                .tabItem {
                    Image(systemName: "calendar.badge.exclamationmark")
                    Text("Drops")
                }
        }
        .accentColor(CustomColor.CustomOrange)
        
        .onChange(of: colorScheme, initial: true, {
            UITabBar.appearance().backgroundColor = schemeTransform(userInterfaceStyle: currentSystemScheme) == .light ? UIColor.customwhite : UIColor.customblack
        })
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
