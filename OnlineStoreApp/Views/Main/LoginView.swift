//
//  LoginView.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject private var authentification: AuthServices
    @Environment(\.dismiss) private var dismiss
    
    @State private var email: String = ""
    @State private var isValidEmailLogin: Bool = true
    
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var isValidPasswordLogin: Bool = true
    
    @State private var isAlertShow: Bool = false
    @State private var loginSucess: Bool = false
    @State private var loginMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                if authentification.isLoading {
                    ProgressView()
                }
                
                VStack(alignment: .leading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image("BackIcon").resizable().frame(width: 40,height: 40).padding()
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Login")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.blue)
                            
                            VStack(alignment: .leading) {
                                Text("Email")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                EmailTextField(email: $email, isValidEmail: $isValidEmailLogin)
                                if !isValidEmailLogin {
                                    Text("Email not valid")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color.red)
                                }
                            }
                            .padding(.vertical, 10)
                            
                            VStack(alignment: .leading) {
                                Text("Password")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                PasswordTextField(text: $password, isShow: $showPassword, isValidPassword: $isValidPasswordLogin)
                                if !isValidPasswordLogin {
                                    Text("Password not valid")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color.red)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button {
                        isValidEmailLogin = Validators.isValidEmail(email)
                        isValidPasswordLogin = Validators.isValidPassword(password)
                        
                        if isValidEmailLogin && isValidPasswordLogin {
                            authentification.authLogin(email: email, password: password) { result in
                                switch result {
                                case .success(let response):
                                    print("Login successful - Code: \(response.code), Message: \(response.message)")
                                    appRootManager.currentToken = response.data.token
                                    loginSucess = true
                                    withAnimation(.spring()) {
                                        appRootManager.currentRoot = .home
                                    }
                                case .failure(let error):
                                    print("Login failed with error: \(error.localizedDescription)")
                                    loginSucess = false
                                    loginMessage = error.localizedDescription
                                    isAlertShow = true
                                }
                            }
                        }
                    } label: {
                        Text("Login".uppercased())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color.blue)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 10)
                }
                .opacity(authentification.isLoading ? 0.3 : 1.0)
            }
            .alert("Error", isPresented: $isAlertShow) {
                Button("Try Again") { }
            } message: {
                Text(loginMessage)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthServices()).environmentObject(AppRootManager())
    }
}
