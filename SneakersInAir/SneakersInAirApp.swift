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

extension UIScreen{
   static let width = UIScreen.main.bounds.size.width
   static let height = UIScreen.main.bounds.size.height
   static let size = UIScreen.main.bounds.size
}

@main
struct SneakersInAirApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
