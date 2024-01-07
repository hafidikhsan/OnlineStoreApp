//
//  CreateVariantCard.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 08/01/24.
//

import SwiftUI

struct CreateVariantCard: View {
    
    let name: String
    let price: Int
    let stock: Int
    let image: Data
    
    var body: some View {
        HStack(alignment: .top) {
            if let uiimage = UIImage(data: image) {
                Image(uiImage: uiimage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipped()
            } else {
                ZStack {
                    Text("Error")
                        .font(.title3)
                }
                .frame(width: 150, height: 150)
            }
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
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct CreateVariantCard_Previews: PreviewProvider {
    static var previews: some View {
        CreateVariantCard(name: "AAA", price: 10, stock: 1, image: Data())
    }
}
