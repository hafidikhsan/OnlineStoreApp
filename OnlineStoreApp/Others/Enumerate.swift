//
//  Enumerate.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import Foundation

enum appRoots {
    case welcome
    case home
}

enum welcomViewStack {
    case login
    case regist
}

enum fetchingAPIStatus {
    case initialized
    case fetching
    case success
    case error(_ message: String)
}
