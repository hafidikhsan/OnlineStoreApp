//
//  LoginModel.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import Foundation

struct Login: Codable {
    let code, message: String
    let data: DataClass
}

struct DataClass: Codable {
    let id: Int
    let token: String
}
