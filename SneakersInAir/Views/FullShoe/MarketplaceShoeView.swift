//
//  MarketplaceShoeView.swift
//  SneakersInAir
//
//  Created by Salvo on 08/03/24.
//

import SwiftUI
import SwiftyJSON

struct MarketplaceShoeView: View {
    
    @State var showingStockX = false
    @State var showingFlightClub = false
    @State var showingGoat = false
    
    @Binding var json: JSON
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack{
                Image(systemName: "cart")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.semibold)
                    .frame(maxWidth: UIScreen.width/12)
                Text("Marketplace")
                    .font(.system(size: 22, weight: .semibold, design: .none))
                    .scaledToFill()
                    .foregroundStyle(.customblack)
                Spacer()
            }
            .padding(.top, 25)
            .padding(.leading, 15)
            .padding(.bottom, 7)
            
            HStack(spacing: 0){
                Text("Retail: ")
                    .font(.system(size: 12, weight: .regular, design: .none))
                    .foregroundStyle(.customblack)
                    .scaledToFill()
                    .opacity(0.75)
                Text("\(json["retailPrice"].int ?? 0)")
                    .font(.system(size: 12, weight: .regular, design: .none))
                    .scaledToFill()
                Spacer()
            }
            .padding(.leading, 15)
            Spacer()
            
        }
        
        VStack(spacing: 0){
            Group{
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.white)
                    .shadow(color: Color(.black).opacity(0.25), radius: 3, x: -1, y: 2)
                    .overlay{
                        Button(action: {
                            showingStockX = true
                        }, label: {
                            HStack{
                                HStack{
                                    Image("sxlogo2")
                                        .resizable()
                                        .scaledToFit()
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        Text("StockX")
                                            .scaledToFill()
                                            .padding(.trailing, 5)
                                            .foregroundStyle(.customblack)
                                    }
                                    Spacer()
                                }
                                .padding([.leading], 15)
                                Spacer(minLength: UIScreen.width/5)
                                UnevenRoundedRectangle()
                                    .clipShape(
                                        .rect(
                                            topLeadingRadius: 0,
                                            bottomLeadingRadius: 0,
                                            bottomTrailingRadius: 20,
                                            topTrailingRadius: 20
                                        )
                                    )
                                    .foregroundStyle(.customwhite)
                                    .overlay {
                                        
                                        HStack{
                                            Text("$\(json["lowestResellPrice"]["stockX"].int ?? 0)")
                                                .foregroundStyle(.customblack)
                                                .scaledToFill()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.customorange)
                                        }
                                        .sheet(isPresented: $showingStockX, content: {
                                            WebView(url: URL(string: json["resellLinks"]["stockX"].string ?? "https://stockx.com/ikdbaw")!)
                                                .presentationDetents([.large, .medium])
                                        })
                                    }
                                    .frame(maxWidth: UIScreen.width/4)
                            }
                        })
                    }
                
                
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.white)
                    .shadow(color: Color(.black).opacity(0.25), radius: 3, x: -1, y: 2)
                    .overlay{
                        Button(action: {
                            showingFlightClub = true
                        }, label: {
                            HStack{
                                HStack{
                                    Image("fclogo")
                                        .resizable()
                                        .scaledToFit()
                                    HStack{
                                        Spacer()
                                        Text("Flight Club")
                                            .scaledToFill()
                                            .foregroundStyle(.customblack)
                                    }
                                    Spacer()
                                }
                                .padding([.leading, .trailing], 15)
                                Spacer(minLength: UIScreen.width/9.7)
                                UnevenRoundedRectangle()
                                    .clipShape(
                                        .rect(
                                            topLeadingRadius: 0,
                                            bottomLeadingRadius: 0,
                                            bottomTrailingRadius: 20,
                                            topTrailingRadius: 20
                                        )
                                    )
                                    .foregroundStyle(.customwhite)
                                    .overlay {
                                        HStack{
                                            Text("$\(json["lowestResellPrice"]["flightClub"].int ?? 0)")
                                                .foregroundStyle(.customblack)
                                                .scaledToFill()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.customorange)
                                        }
                                    }
                                    .frame(maxWidth: UIScreen.width/4)
                                    .sheet(isPresented: $showingFlightClub, content: {
                                        WebView(url: URL(string: json["resellLinks"]["flightClub"].string ?? "https://www.flightclub.com/aiwdadiuh")!)
                                            .presentationDetents([.large, .medium])
                                    })
                                
                            }
                        })
                    }
                
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.white)
                    .shadow(color: Color(.black).opacity(0.25), radius: 3, x: -1, y: 2)
                    .overlay{
                        Button(action: {
                            showingGoat = true
                        }, label: {
                            HStack{
                                HStack{
                                    Image("glogo")
                                        .resizable()
                                        .scaledToFit()
                                        .padding([.top, .bottom], 0)
                                    
                                    HStack{
                                        Spacer()
                                        Text("Goat")
                                            .padding(.trailing, 6)
                                            .foregroundStyle(.customblack)
                                    }
                                    Spacer()
                                }
                                .padding([.leading, .trailing], 15)
                                Spacer(minLength: UIScreen.width/5)
                                
                                UnevenRoundedRectangle()
                                    .clipShape(
                                        .rect(
                                            topLeadingRadius: 0,
                                            bottomLeadingRadius: 0,
                                            bottomTrailingRadius: 20,
                                            topTrailingRadius: 20
                                        )
                                    )
                                    .foregroundStyle(.customwhite)
                                    .overlay {
                                        HStack{
                                            Text("$\(json["lowestResellPrice"]["goat"].int ?? 0)")
                                                .foregroundStyle(.customblack)
                                                .scaledToFill()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.customorange)
                                        }
                                    }
                                    .frame(maxWidth: UIScreen.width/4)
                                
                                    .sheet(isPresented: $showingGoat, content: {
                                        WebView(url: URL(string: json["resellLinks"]["goat"].string ?? "https://www.goat.com/en-it/aiwhdaouwd")!)
                                            .presentationDetents([.large, .medium])
                                    })
                            }
                        })
                    }
                
            }
            .frame(minHeight: UIScreen.height/15)
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 5)
            
            Spacer()
        }
    }
}

#Preview {
    MarketplaceShoeView(json: .constant(JSON()))
}
