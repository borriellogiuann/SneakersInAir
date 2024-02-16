//
//  ContentView.swift
//  SneakersInAir
//
//  Created by Giovanni Borriello on 13/02/24.
//

import SwiftUI

struct CustomColor {
    static let lightblue = Color("lightblue")
    static let darkblue = Color("darkblue")
    static let customblack = Color("customblack")
    static let customwhite = Color("customwhite")
}

@Observable
class TabBarController {
    var selectedTab: ContentTab = .mainView
    
    var isShowingHeroView: Bool = false
}

enum ContentTab {
    case mainView
    case secondView
    
    var imageName: String {
        switch self {
        case .mainView: "calendar.badge.exclamationmark"
        case .secondView: "magnifyingglass"
        }
    }
}

struct ContentView: View {
    @State var tabBarController = TabBarController()
    
    var body: some View {
        ZStack {
            Group {
                if tabBarController.selectedTab == .mainView {
                    DropView()
                }
                
                if tabBarController.selectedTab == .secondView {
                    FavoritesView()
                }
            }
            .padding(.bottom, 50)
            
            TabBar()
        }
        .sheet(isPresented: $tabBarController.isShowingHeroView, content: {
            ScannerView()
        })
        .environment(tabBarController)
    }
}

struct TabBar: View {
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                HStack(spacing: 0) {
                    TabBarItem(contentTab: .mainView)
                    TabBarItem(contentTab: .secondView)
                }
                
                TabBarHeroItem()
            }
        }
    }
}

struct TabBarItem: View {
    @Environment(TabBarController.self) var tabBarController
    
    var contentTab: ContentTab
    
    var body: some View {
        Button(action: {
            tabBarController.selectedTab = contentTab
        }) {
            HStack {
                VStack {
                    Image(systemName: contentTab.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(CustomColor.darkblue)
                    Text("Drops")
                }}
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(CustomColor.customwhite)
        }
    }
}

struct TabBarHeroItem: View {
    @Environment(TabBarController.self) var tabBarController
    
    var body: some View {
        HStack {
            Button(action: {
                tabBarController.isShowingHeroView = true
            }) {
                ZStack {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundStyle(CustomColor.customwhite)
                        .overlay {
                            Circle()
                                .stroke(CustomColor.darkblue, lineWidth: 2.0)
                        }
                    Image(systemName: "viewfinder")
                        .foregroundStyle(CustomColor.darkblue)
                        .font(.system(size: 25))
                }
                .frame(width: 70, height: 70)
            }
            .padding(.top, -20)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
