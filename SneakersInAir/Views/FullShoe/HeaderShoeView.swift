//
//  HeaderShoeView.swift
//  SneakersInAir
//
//  Created by Salvo on 08/03/24.
//

import SwiftUI
import SwiftyJSON

struct HeaderShoeView: View {
    
    @Binding var json: JSON
    
    var body: some View {
        Group{
            HStack{
                Text("\(json["shoeName"].string ?? "Shoe not found")")
                    .font(.system(size: 22, weight: .bold, design: .none))
                Spacer()
            }
            .padding(.leading, 15)
            
            HStack(spacing: 0){
                Group{
                    Text("Color: \(json["colorway"].string ?? "Not Found")")
                    Text("|")
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    Text("ID: \(json["styleID"].string ?? "Not Found")")
                }
                .font(.system(size: 12, weight: .regular, design: .none))
                .opacity(0.75)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading, 15)
            
            HStack(spacing: 0){
                Text("Released")
                    .font(.system(size: 15, weight: .semibold, design: .none))
                    .padding([.leading, .trailing], 20)
                    .padding([.top, .bottom], 4)
                    .background(RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(.customorange)
                        .opacity(0.75))
                Text("\(json["releaseDate"].string ?? "Not Found")")
                    .font(.system(size: 17, weight: .regular, design: .none))
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading, 15)
            
            
            
        }
        .foregroundStyle(.customblack)
    }
}

#Preview {
    HeaderShoeView(json: .constant(JSON()))
}
