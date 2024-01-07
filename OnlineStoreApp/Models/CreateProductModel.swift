//
//  CreateProductModel.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 08/01/24.
//

import Foundation

struct CreateResponse: Codable {
    let code, message: String
}

struct CreateVariant: Codable, Hashable {
    let image: String
    let imageData: Data
    let name: String
    let price, stock: Int
}

struct VariantForm: Codable {
    let name: String
    let image: String
    let price: Int
    let stock: Int
}

struct ProductForm: Codable {
    let title: String
    let description: String
    let variants: [VariantForm]
}
