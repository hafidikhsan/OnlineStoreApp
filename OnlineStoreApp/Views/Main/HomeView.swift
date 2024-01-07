//
//  HomeView.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var appRootManager: AppRootManager
    
    @State private var isAlertShow: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    HStack {
                        Text("Product")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image("AddProductIcon").resizable().frame(width: 40,height: 40)
                        }
                    }
                    Spacer()
                    Text(appRootManager.currentToken)
                    Spacer()
                }
                .padding()
                
                Button {
                    isAlertShow = true
                } label: {
                    Image("LogoutIcon")
                        .resizable()
                        .frame(width: 80,height: 80)
                }
                .padding()
            }
            .alert(isPresented:$isAlertShow) {
                Alert(
                    title: Text("Log Out ?"),
                    message: Text("Are you sure to log out ?"),
                    primaryButton: .destructive(Text("Log Out")) {
                        self.appRootManager.currentToken = ""
                        withAnimation(.spring()) {
                            appRootManager.currentRoot = .welcome
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AppRootManager())
    }
}
