//
//  Explore.swift
//  SneakersInAir
//
//  Created by Giovanni Borriello on 19/02/24.
//

import SwiftUI




struct ExploreView: View {
    @State private var searchText: String = ""
    var body: some View {
        SearchBar(text: $searchText)
    }
}
#Preview {
    ExploreView()
}


// Design della barra di ricerca
struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack{
            TextField("Search", text: $text)
                .padding(.leading, 34)
                .padding(.trailing, 8)
                .padding(.vertical, 8)
                .overlay(
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.orange)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                            .padding(.trailing, 4)
                        
                    }
                )
                .overlay(
                    HStack{
                        Image(systemName: "mic.fill")
                            .foregroundColor(.orange)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 15)
                            .padding(.leading, 4)
                        
                    }
                )
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke()
        
        )
        .padding()
        
        
    }
}
