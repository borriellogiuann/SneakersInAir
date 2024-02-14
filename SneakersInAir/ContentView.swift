//
//  ContentView.swift
//  SneakersInAir
//
//  Created by Giovanni Borriello on 13/02/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ListView()
                .tabItem {
                    Image(systemName: "calendar.badge.exclamationmark")
                    Text("Drops")
                }
            ScannerView()
                .tabItem {
                    ZStack{
                        Image(systemName: "plus.viewfinder")
                        Image(systemName: "shoe")
                    }
                    Text("Scanner")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
        }
    }
}

#Preview {
    ContentView()
}
