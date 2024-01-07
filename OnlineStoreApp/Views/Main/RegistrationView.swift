//
//  RegistrationView.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

struct RegistrationView: View {
    
    @EnvironmentObject private var authetification: AuthServices
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var isValidNameRegis: Bool = true
    
    @State private var email: String = ""
    @State private var isValidEmailRegis: Bool = true
    
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var isValidPassword: Bool = true
    
    @State private var passwordConfirm: String = ""
    @State private var showPasswordConfirm: Bool = false
    @State private var isValidPasswordConfirm: Bool = true
    
    @State private var isAlertShow: Bool = false
    @State private var registSucess: Bool = false
    @State private var registMessage: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                if authetification.isLoading {
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
                            Text("Register")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.blue)
                            
                            VStack(alignment: .leading) {
                                Text("Name")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                TextField("Jhon Doe", text: $name)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(!isValidNameRegis ? Color.red : Color.gray, lineWidth: 1)
                                    )
                                    .onSubmit {
                                        isValidNameRegis = name.count > 0
                                    }
                                if !isValidNameRegis {
                                    Text("Name not valid")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color.red)
                                }
                            }
                            .padding(.vertical, 10)
                            
                            VStack(alignment: .leading) {
                                Text("Email")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                EmailTextField(email: $email, isValidEmail: $isValidEmailRegis)
                                if !isValidEmailRegis {
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
                                PasswordTextField(text: $password, isShow: $showPassword, isValidPassword: $isValidPassword)
                                if !isValidPassword {
                                    Text("Password not valid")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color.red)
                                }
                            }
                            .padding(.vertical, 10)
                            
                            VStack(alignment: .leading) {
                                Text("Password Confirm")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                PasswordTextField(text: $passwordConfirm, isShow: $showPasswordConfirm, isValidPassword: $isValidPasswordConfirm)
                                if !isValidPasswordConfirm {
                                    Text("Password Confirm not valid")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color.red)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button {
                        isValidNameRegis = name.count > 0
                        isValidEmailRegis = Validators.isValidEmail(email)
                        isValidPassword = Validators.isValidPassword(password)
                        isValidPasswordConfirm = Validators.isValidPassword(passwordConfirm)
                        
                        if isValidNameRegis && isValidEmailRegis && isValidPassword && isValidPasswordConfirm {
                            if password == passwordConfirm {
                                authetification.authRegist(name: name, email: email, password: password) { result in
                                    switch result {
                                    case .success(let response):
                                        print("Registration successful - Code: \(response.code), Message: \(response.message)")
                                        registSucess = true
                                        registMessage = "Registration Successful"
                                    case . failure(let error):
                                        print("Registration failed with error: \(error.localizedDescription)")
                                        registSucess = false
                                        registMessage = error.localizedDescription
                                    }
                                    isAlertShow = true
                                }
                            } else {
                                isValidPasswordConfirm = false
                            }
                        }
                    } label: {
                        Text("Register".uppercased())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color.blue)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 10)
                }
                .opacity(authetification.isLoading ? 0.3 : 1.0)
            }
            .alert(registSucess ? "Success" : "Error", isPresented: $isAlertShow) {
                if registSucess {
                    Button("Ok") { dismiss() }
                } else {
                    Button("Try Again") {}
                }
            } message: {
                Text(registMessage)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environmentObject(AuthServices())
    }
}
