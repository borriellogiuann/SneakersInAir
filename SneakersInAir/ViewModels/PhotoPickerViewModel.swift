//
//  PhotoPickerViewModel.swift
//  SneakersInAir
//
//  Created by Salvo on 04/03/24.
//

import Foundation
import _PhotosUI_SwiftUI

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
