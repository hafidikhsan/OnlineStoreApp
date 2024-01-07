//
//  WelcomeView.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var presentNextView = false
    @State private var nextView: welcomViewStack = .login
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("OnlineStoreLogo")
                    .resizable()
                    .frame(width: 250, height: 250)
                
                VStack {
                    Spacer()
                    
                    Button {
                        nextView = .login
                        presentNextView.toggle()
                    } label: {
                        Text("Login".uppercased())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .padding(.horizontal)
                    
                    Button {
                        nextView = .regist
                        presentNextView.toggle()
                    } label: {
                        Text("Register".uppercased())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .padding()
                }
            }
            .navigationDestination(isPresented: $presentNextView) {
                switch nextView {
                case .login:
                    LoginView()
                case .regist:
                    RegistrationView()
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
