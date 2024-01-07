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
    let id: Int
    let title, description: String
    let totalVariant, totalStok, price: Int
    let image: String
    let variants: [Variant]

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case totalVariant = "total_variant"
        case totalStok = "total_stok"
        case price, image, variants
    }
}

struct Variant: Codable {
    let id: Int
    let image: String
    let name: String
    let price, stock: Int
}
