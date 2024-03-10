//
//  FullShoeView.swift
//  SneakersInAir
//
//  Created by Salvo on 05/03/24.
//

import SwiftUI
import SwiftyJSON

struct FullShoeView: View {
    
    @Binding var json: JSON
    @Binding var shoeImage: UIImageView
    @State var shoeName = "Nike Dunk High Slam Jam White Pure Platinum"
    @State var shoeColor = "Blue/White-Gum"
    @State var shoeID = "CV1677-100"
    @State var showingStockX = false
    @State var showingFlightClub = false
    @State var showingGoat = false
    @State var showingDescription = false
    
    var body: some View {
        VStack(spacing: 1){
            Rectangle()
                .foregroundStyle(.white)
                .frame(maxHeight: UIScreen.height/3)
                .overlay{
                    Image(uiImage: (shoeImage.image ?? UIImage(named: "scarpavuota"))!)
                        .resizable()
                        .scaledToFit()
                        .padding(30)
                        .padding(.bottom, -20)
                }
            Rectangle()
                .foregroundStyle(.white)
                .shadow(radius: 5)
                .overlay{
                    ScrollView{
                        VStack(spacing: 0){
                            LogoShoeView(json: $json, showingDescription: $showingDescription)
                            
                            HeaderShoeView(json: $json)
                            
                            MarketplaceShoeView(json: $json)
                            .padding(.top, 10)
                            
                            VStack(spacing: 0){
                                HStack{
                                    Image(systemName: "sparkle.magnifyingglass")
                                        .resizable()
                                        .scaledToFit()
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: UIScreen.width/12)
                                    Text("Suggestions")
                                        .font(.system(size: 22, weight: .semibold, design: .none))
                                        .scaledToFill()
                                        .foregroundStyle(.customblack)
                                    Spacer()
                                }
                                .padding(.top, 25)
                                .padding(.leading, 15)
                                .padding(.bottom, 7)
                                
                                HStack(spacing: 0){
                                    Text("Based on: ")
                                        .font(.system(size: 12, weight: .regular, design: .none))
                                        .foregroundStyle(.customblack)
                                        .scaledToFill()
                                        .opacity(0.75)
                                    Text("\(json["silhoutte"].string ?? "Not Found")")
                                        .font(.system(size: 12, weight: .regular, design: .none))
                                        .scaledToFill()
                                    Spacer()
                                }
                                .padding(.leading, 15)
                                Spacer()
                                
                            }
                            
                            VStack{
                                ScrollView(.horizontal){
                                    HStack{
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundStyle(.white)
                                            .shadow(color: Color(.black).opacity(0.25), radius: 4, x: -1, y: 2)
                                            .overlay{
                                                VStack{
                                                    Image(uiImage: UIImage(named: "scarpavuota")!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(10)
                                                }
                                            }
                                            .frame(minWidth: UIScreen.width/3,  minHeight: UIScreen.height/7)
                                            .padding(.leading, 15)
                                            .padding([.top, .bottom], 10)
                                        
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundStyle(.white)
                                            .shadow(color: Color(.black).opacity(0.25), radius: 4, x: -1, y: 2)
                                            .overlay{
                                                VStack{
                                                    Image(uiImage: UIImage(named: "scarpaprova")!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(10)
                                                }
                                            }
                                            .frame(minWidth: UIScreen.width/3,  minHeight: UIScreen.height/7)
                                            .padding(.leading, 15)
                                            .padding([.top, .bottom], 10)
                                        
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundStyle(.white)
                                            .shadow(color: Color(.black).opacity(0.25), radius: 4, x: -1, y: 2)
                                            .overlay{
                                                VStack{
                                                    Image(uiImage: UIImage(named: "scarpavuota")!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(10)
                                                }
                                            }
                                            .frame(minWidth: UIScreen.width/3,  minHeight: UIScreen.height/7)
                                            .padding(.leading, 15)
                                            .padding([.top, .bottom], 10)
                                        
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundStyle(.white)
                                            .shadow(color: Color(.black).opacity(0.25), radius: 4, x: -1, y: 2)
                                            .overlay{
                                                VStack{
                                                    Image(uiImage: UIImage(named: "scarpaprova")!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(10)
                                                }
                                            }
                                            .frame(minWidth: UIScreen.width/3,  minHeight: UIScreen.height/7)
                                            .padding(.leading, 15)
                                            .padding([.top, .bottom], 10)
                                    }
                                }
                            }
                            .padding(.bottom, 50)
                        }
                    }
                    
                }
                .ignoresSafeArea()
                .padding(.top, -15)
                .sheet(isPresented: $showingDescription, content: {
                    DescriptionView(json: $json)
                        .presentationDetents([.medium])
                })
        }
        
        .toolbar{
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.customorange)
                })
            })
        }
    }
}

#Preview {
    FullShoeView(json: .constant(JSON()), shoeImage: .constant(UIImageView()))
}
