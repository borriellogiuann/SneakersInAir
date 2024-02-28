//
//  SneakerItemView.swift
//  SneakersInAir
//
//  Created by Davide Formisano on 23/02/24.
//

import SwiftUI

struct SneakerItemView: View {
    var isFav = false
    var IsNot = false
    
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    ZStack {
                            Rectangle()
                                    .foregroundColor(.white)
                                    .aspectRatio(contentMode: .fill)
                                    .frame( height: 170)
                                    .cornerRadius(25)
                                    .clipped()
                                    .overlay(
                                                Image("Sneaker")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 135, height:  70)
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                                    .padding(.top)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .foregroundColor(.customwhite)
                                                    .cornerRadius(25)
                                                    .frame(width: 380, height: 70, alignment: .bottom)
                                                    .frame(maxHeight: .infinity, alignment: .bottom)
                                                    .overlay(
                                                        Button(action: {
                                                            
                                                        }, label: {
                                                                Image(systemName: "heart")
                                                                    .foregroundColor(.customorange)
                                                        })
                                                        .frame(maxWidth: 210, maxHeight: 140, alignment: .bottomTrailing)
                                                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)

                                                    )
                                                    .overlay(
                                                        Button(action: {
                                                            
                                                        }, label: {
                                                            Image(systemName: "bell")
                                                                .foregroundColor(.customorange)
                                                        })
                                                        .frame(maxWidth: 250, maxHeight: 140, alignment: .bottomTrailing)
                                                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                                                    )
                                                
                                                    .overlay(
                                                        Text("Nike Air Force One")
                                                            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .bottom)
                                                            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                                                    )
                                                
                                            )
                                            .clipped()
                                    }
                                    .cornerRadius(25)
                                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
                                }
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                    }
                }
    

#Preview {
    SneakerItemView()
}
