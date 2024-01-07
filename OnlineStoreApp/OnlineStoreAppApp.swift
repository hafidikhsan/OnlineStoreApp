//
//  OnlineStoreAppApp.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

@main
struct OnlineStoreAppApp: App {
    
    @StateObject private var appRootManager = AppRootManager()
    @StateObject private var authentification = AuthServices()
    @StateObject private var productServices = ProductServices()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .welcome:
                    WelcomeView()
                        .environmentObject(authentification)
                case .home:
                    HomeView()
                        .environmentObject(productServices)
                }
            }
            .environmentObject(appRootManager)
        }
    }
}
