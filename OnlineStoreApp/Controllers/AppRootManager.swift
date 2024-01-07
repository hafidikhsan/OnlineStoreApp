//
//  AppRootManager.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import Foundation

final class AppRootManager: ObservableObject {
    
    @Published var currentRoot: appRoots = .welcome
    @Published var currentToken: String = ""

}
