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
                    Image(systemName: "shoe")
                    Text("Drops")
                }
            ScannerView()
                .tabItem {
                    Image(systemName: "plus.viewfinder")
                    Text("Scanner")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
        }
    }
}

#Preview {
    ContentView()
}
