//
//  EditVariantCard.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 08/01/24.
//

import SwiftUI

struct EditVariantCard: View {
    
    let name: String
    let price: Int
    let stock: Int
    let image: String
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            .clipped()
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text("Rp. \(price)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding(.top)
                Text("\(stock) Pcs")
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding(.top)
            }
            Spacer()
            
            Image("EditIcon")
                .resizable()
                .frame(width: 35, height: 35)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct EditVariantCard_Previews: PreviewProvider {
    static var previews: some View {
        EditVariantCard(name: "AAA", price: 10, stock: 1, image: "https://picsum.photos/id/12/600")
    }
}
