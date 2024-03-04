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
                .frame(width: 350, height: 120)
                .shadow(radius: 25)
            HStack{
                Image(uiImage: uiImageView.image!)
                    .resizable()
                    .frame(maxWidth: 125, maxHeight: 100)
                    .padding(.leading, 30)
                Spacer()
                Text("\(shoeName)")
                    .foregroundStyle(.customblack)
                    .frame(maxWidth: 150)
                    .font(.body)
                    .padding(.trailing, 50)
            }
        }
    }
}

#Preview {
    PopupShoeView(shoeName: .constant("Jordan 1 Mid Light Smoke Grey"), uiImageView: .constant(UIImageView(image: UIImage(named: "scarpaprova"))))
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
