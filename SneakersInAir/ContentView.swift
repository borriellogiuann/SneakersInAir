//
//  ContentView.swift
//  SneakersInAir
//
//  Created by Giovanni Borriello on 13/02/24.
//

import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerViewModel: ObservableObject{
    
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage (from: imageSelection)
        }
    }
    
    private func setImage (from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable (type: Data.self) {
                if let uiImage = UIImage (data: data) {
                    selectedImage = uiImage
                    return
                }
            }
        }
    }
}

struct ContentView: View {
    enum TabbedItems: Int, CaseIterable{
        case home = 0
        case favorite
        case chat
        case profile
        
        var title: String{
            switch self {
            case .home:
                return "Home"
            case .favorite:
                return "Favorite"
            case .chat:
                return "Chat"
            case .profile:
                return "Profile"
            }
        }
        
        var iconName: String{
            switch self {
            case .home:
                return "scan-icon"
            case .favorite:
                return "favorites-icon"
            case .chat:
                return "explore-icon"
            case .profile:
                return "drops-icon"
            }
        }
    }
    
    @StateObject private var viewModel = PhotoPickerViewModel()
    @State var selectedTab = 0

    var body: some View {
                ZStack(alignment: .bottom){
                    TabView(selection: $selectedTab) {
                        DropView()
                            .tag(0)

                        ExploreView()
                            .tag(1)

                        FavoritesView()
                            .tag(2)
                        
                        FavoritesView()
                            .tag(3)

                    }
                    ZStack{
                        HStack{
                            ForEach((TabbedItems.allCases), id: \.self){ item in
                                Button{
                                    selectedTab = item.rawValue
                                } label: {
                                    CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                                }
                            }
                        }
                        .padding(6)
                    }
                    .frame(height: 70)
                    .background(.customwhite)
                    .cornerRadius(35)
                    .padding(.horizontal, 26)
                }
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
    }
}
extension ContentView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .black : .gray)
            }
            Spacer()
        }
        .frame(width: isActive ? .infinity : 60, height: 60)
        .background(isActive ? .customorange : .clear)
        .cornerRadius(30)
    }
}

#Preview {
    ContentView()
}
