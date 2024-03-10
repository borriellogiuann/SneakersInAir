//
//  LogoView.swift
//  SneakersInAir
//
//  Created by Salvo on 08/03/24.
//

import SwiftUI
import SwiftyJSON

struct LogoShoeView: View {
    
    @Binding var json: JSON
    @Binding var showingDescription: Bool
    
    var body: some View {
        HStack{
            Image((json["brand"].string ?? "Nike") + "Logo")
                .resizable()
                .scaledToFit()
                .padding([.leading, .trailing], 15)
            Spacer(minLength: UIScreen.width/1.9)
            Button(action: {
                showingDescription = true
            }, label: {
                ZStack{
                    Image(systemName: "bubble.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.customblack)
                        .padding(.trailing, 35)
                        .padding([.leading, .trailing], 15)
                        .padding(.top, 30)
                    Image(systemName: "info.bubble.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.customorange)
                        .padding(.trailing, 35)
                        .padding([.leading, .trailing], 15)
                        .padding(.top, 30)
                }
            })
        }
    }
}

#Preview {
    LogoShoeView(json: .constant(JSON()), showingDescription: .constant(false))
}
