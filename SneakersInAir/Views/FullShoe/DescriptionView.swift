//
//  DescriptionView.swift
//  SneakersInAir
//
//  Created by Salvo on 09/03/24.
//

import SwiftUI
import SwiftyJSON

struct DescriptionView: View {
    
    @Binding var json: JSON

    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 25)
                .overlay{
                    ScrollView{
                        VStack(spacing: 0){
                            HStack{
                                Spacer()
                                Image(systemName: "pencil.and.list.clipboard")
                                    .resizable()
                                    .scaledToFit()
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: UIScreen.width/12)
                                    .foregroundStyle(.customblack)
                                Text("Description")
                                    .font(.system(size: 22, weight: .bold, design: .none))
                                    .scaledToFill()
                                    .foregroundStyle(.customblack)
                                Spacer()
                            }
                            .padding(.top, 25)
                            .padding(.leading, 0)
                            .padding(.bottom, 20)
                            
                            Text("\(json["description"].string != "" ? json["description"].string ?? "The description for this shoe couldn't be found. We invite you to send us an email to enrich our app at macbookinair@gmail.com reporting this specific shoe name." : "The description for this shoe couldn't be found. We invite you to send us an email to enrich our app at macbookinair@gmail.com reporting this specific shoe name." )")
                                .font(.system(size: 17, weight: .regular, design: .none))
                                .multilineTextAlignment(.leading)
                                .padding([.leading, .trailing], 20)
                                .padding([.leading], 15)
                                .padding(.bottom, 30)
                                .foregroundStyle(.customblack)
                            Spacer()
                        }
                    }
                }
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    DescriptionView(json: .constant(JSON()))
}
