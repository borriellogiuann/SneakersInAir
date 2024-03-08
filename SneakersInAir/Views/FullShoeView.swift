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
    @State var showing = false
    @State var showingStockX = false
    @State var showingFlightClub = false
    @State var showingGoat = false
    
    var body: some View {
        VStack(spacing: 1){
            Rectangle()
                .foregroundStyle(.white)
                .frame(maxHeight: UIScreen.height/3)
                .overlay{
                    ZStack{
                        Image(uiImage: (shoeImage.image ?? UIImage(named: "scarpavuota"))!)
                            .resizable()
                            .scaledToFit()
                            .padding(30)
                            .padding(.bottom, -30)
                        
                    }
                }
            Rectangle()
                .foregroundStyle(.white)
                .frame(maxHeight: UIScreen.height/3+UIScreen.height/3)
                .shadow(radius: 5)
                .overlay{
                    VStack(spacing: 0){
                        HStack{
                            Image((json["brand"].string ?? "Nike") + "Logo")
                                .resizable()
                                .scaledToFit()
                            Spacer(minLength: UIScreen.width/1.3)
                        }
                        .padding(.leading, 15)
                        
                        Group{
                            HStack{
                                Text("\(json["shoeName"].string ?? "Shoe not found")")
                                    .font(.system(size: 22, weight: .semibold, design: .none))
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
                            
                            VStack{
                                HStack{
                                    Image(systemName: "cart")
                                        .resizable()
                                        .scaledToFit()
                                        .fontWeight(.semibold)
                                    Text("Marketplace")
                                        .font(.system(size: 22, weight: .semibold, design: .none))
                                        .scaledToFill()
                                    Spacer(minLength: UIScreen.width/1.83)
                                }
                                .padding(.top, 25)
                                .padding(.leading, 15)
                                
                                HStack(spacing: 0){
                                    Text("Retail: ")
                                        .font(.system(size: 12, weight: .regular, design: .none))
                                        .scaledToFill()
                                        .opacity(0.75)
                                        .padding(.leading, 18)
                                    Text("\(json["retailPrice"].int ?? 0)")
                                        .font(.system(size: 12, weight: .regular, design: .none))
                                        .scaledToFill()
                                        .foregroundStyle(.customorange)
                                    Spacer()
                                }
                                
                            }
                        }
                        .foregroundStyle(.customblack)
                        
                        VStack(spacing: 0){
                            Group{
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.white)
                                    .shadow(color: Color(.black).opacity(0.25), radius: 3, x: -1, y: 2)
                                    .overlay{
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
                                                }
                                                Spacer()
                                            }
                                            .padding([.leading], 15)
                                            Spacer(minLength: UIScreen.width/5)
                                            Button(action: {
                                                showing = false
                                                DispatchQueue.main.asyncAfter(deadline: .now()+TimeInterval(0.2)){
                                                    showingStockX = true
                                                }
                                            }, label: {
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
                                            })
                                        }
                                    }
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.white)
                                    .shadow(color: Color(.black).opacity(0.25), radius: 3, x: -1, y: 2)
                                    .overlay{
                                        HStack{
                                            HStack{
                                                Image("fclogo")
                                                    .resizable()
                                                    .scaledToFit()
                                                HStack{
                                                    Spacer()
                                                    Text("Flight Club")
                                                        .scaledToFill()
                                                }
                                                Spacer()
                                            }
                                            .padding([.leading, .trailing], 15)
                                            Spacer(minLength: UIScreen.width/9.7)
                                            Button(action: {
                                                showing = false
                                                DispatchQueue.main.asyncAfter(deadline: .now()+TimeInterval(0.2)){
                                                    showingFlightClub = true
                                                }
                                            }, label: {
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
                                            })
                                            .sheet(isPresented: $showingFlightClub, content: {
                                                WebView(url: URL(string: json["resellLinks"]["flightClub"].string ?? "https://www.flightclub.com/aiwdadiuh")!)
                                                    .presentationDetents([.large, .medium])
                                            })
                                        }
                                    }
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.white)
                                    .shadow(color: Color(.black).opacity(0.25), radius: 3, x: -1, y: 2)
                                    .overlay{
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
                                                }
                                                Spacer()
                                            }
                                            .padding([.leading, .trailing], 15)
                                            Spacer(minLength: UIScreen.width/5)
                                            Button(action: {
                                                showing = false
                                                DispatchQueue.main.asyncAfter(deadline: .now()+TimeInterval(0.2)){
                                                    showingGoat = true
                                                }
                                            }, label: {
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
                                            })
                                            .sheet(isPresented: $showingGoat, content: {
                                                WebView(url: URL(string: json["resellLinks"]["goat"].string ?? "https://www.goat.com/en-it/aiwhdaouwd")!)
                                                    .presentationDetents([.large, .medium])
                                            })
                                        }
                                    }
                                
                            }
                            .padding([.leading, .trailing], 10)
                            .padding([.top, .bottom], 5)
                            Spacer(minLength: UIScreen.height/20)
                        }
                        .padding(.top, 10)
                        
                        .sheet(isPresented: $showing, content: {
                            GeometryReader{ geometryProxy in
                                VStack{
                                    Spacer(minLength: geometryProxy.size.height/100)
                                    HStack{
                                        Spacer()
                                        Text("Description")
                                            .font(.system(size: 22, weight: .semibold, design: .none))
                                            .foregroundStyle(.customblack)
                                            .padding(10)
                                        Spacer()
                                    }
                                    ScrollView(){
                                        Text("\((json["description"].string ?? "") == "" ? "Description not found, please try again with a different shoe. if the error persist, report it to the developer" : json["description"].string ?? "")")
                                            .padding(20)
                                            .multilineTextAlignment(.center)
                                            .lineSpacing(0.5)
                                    }
                                }
                                .padding(10)
                                .presentationDetents([.height(UIScreen.width/14), .medium])
                                .presentationBackground(.regularMaterial)
                                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                                .interactiveDismissDisabled()
                                .background(.customwhite)
                            }
                        })
                    }
                }
                .onChange(of: showingStockX, initial: true, { oldValue,newValue  in
                    if newValue == false {
                        showing = true
                    }
                })
                .onChange(of: showingFlightClub, initial: false, { oldValue,newValue  in
                    if newValue == false {
                        showing = true
                    }
                })
                .onChange(of: showingGoat, initial: false, { oldValue,newValue  in
                    if newValue == false {
                        showing = true
                    }
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
