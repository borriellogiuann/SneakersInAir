//
//  PopupShoeView.swift
//  SneakersInAir
//
//  Created by Salvo on 27/02/24.
//

import SwiftUI

struct PopupShoeView: View {
    
    @Binding var shoeName: String
    @Binding var shoeVariant: String
    
    var body: some View {
        HStack{
            Image(systemName: "shoe")
//            Text("\(shoeName)\n\(shoeVariant)")
//                .foregroundStyle(.customblack)
        }
    }
}

#Preview {
    PopupShoeView(shoeName: .constant("Air Force 1"), shoeVariant: .constant("Blaze Red"))
}
