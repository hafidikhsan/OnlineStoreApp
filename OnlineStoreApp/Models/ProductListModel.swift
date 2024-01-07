//
//  ProductListModel.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import Foundation

struct ProductList: Codable {
    let code, message: String
    let data: DataItems
}

struct DataItems: Codable {
    let items: [Item]
    let perPage, total: Int
    let lastPage: String
    let nextPage, prevPage: String?

    enum CodingKeys: String, CodingKey {
        case items
        case perPage = "per_page"
        case total
        case lastPage = "last_page"
        case nextPage = "next_page"
        case prevPage = "prev_page"
    }
}

struct Item: Codable {
    var id: Int
    var title, description: String
    var totalVariant, totalStok, price: Int
    var image: String
    var variants: [Variant]

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case totalVariant = "total_variant"
        case totalStok = "total_stok"
        case price, image, variants
    }
}

struct Variant: Codable {
    var id: Int
    var image: String
    var name: String
    var price, stock: Int
}
