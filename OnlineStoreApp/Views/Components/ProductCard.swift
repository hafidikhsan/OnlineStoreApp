//
//  ProductCard.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 08/01/24.
//

import SwiftUI

struct ProductCard: View {
    
    var image: String
    var name: String
    var variant: Int
    var stock: Int
    var price: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
                    .scaledToFill()
                    .shadow(color: .gray, radius: 8, x: 0, y: 5)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 170, height: 170)
            .clipped()
            
            Text(name)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Total Variant: \(variant)")
                .font(.title3)
                .padding(.top, 5)
            
            Text("Total Stock: \(stock)")
                .font(.title3)
            
            Text("Rp \(price)")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top, 5)
                .foregroundColor(.blue)
        }
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        ProductCard(image: "https://picsum.photos/id/12/600", name: "Produk", variant: 10, stock: 10, price: 10000)
    }
}
