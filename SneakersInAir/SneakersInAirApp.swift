//
//  SneakersInAirApp.swift
//  SneakersInAir
//
//  Created by Giovanni Borriello on 13/02/24.
//

import SwiftUI

struct CustomColor {
    static let CustomBlack = Color("customblack")
    static let CustomWhite = Color("customwhite")
    static let CustomOrange = Color("customorange")
}

@main
struct SneakersInAirApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
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
                AboutUsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }.accentColor(CustomColor.CustomOrange)
        }
    }
}
