//
//  PopupShoeView.swift
//  SneakersInAir
//
//  Created by Salvo on 27/02/24.
//

import SwiftUI

struct PopupShoeView: View {
    
    @Binding var shoeName: String
    @Binding var uiImageView: UIImageView
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundStyle(.white)
                .frame(width: 300, height: 200)
            HStack{
                Image(uiImage: uiImageView.image!)
                    .resizable()
                    .frame(maxWidth: 150, maxHeight: 50)
                Text("\(shoeName)")
                    .foregroundStyle(.customblack)
                    .frame(maxWidth: 100)
            }
        }
    }
}



extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
