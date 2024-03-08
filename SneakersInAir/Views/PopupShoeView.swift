//
//  PopupShoeView.swift
//  SneakersInAir
//
//  Created by Salvo on 27/02/24.
//

import SwiftUI
import SwiftyJSON

struct PopupShoeView: View {
    
    @Binding var shoeName: String
    @Binding var uiImageView: UIImageView
    @Binding var json: JSON
    
    var body: some View {
        //NavigationView(content: {
            //NavigationLink(destination: FullShoeView(json: $json, shoeImage: $uiImageView), label: {
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.width/1.15, height: UIScreen.height/7)
                    .shadow(radius: 25)
                    .overlay{
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
                                .scaledToFill()
                                .padding(.trailing, 30)
                        }
                    }
            //})
        //})
        //.tint(.customorange)
    }
}

#Preview {
    PopupShoeView(shoeName: .constant("Jordan 1 Mid Light Smoke Grey"), uiImageView: .constant(UIImageView(image: UIImage(named: "scarpaprova"))), json: .constant(JSON()))
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
