//
//  EmailTextField.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

struct EmailTextField: View {
    
    @Binding var email: String
    @Binding var isValidEmail: Bool
    
    var body: some View {
        TextField("jhondoe@gmail.com", text: $email)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(!isValidEmail ? Color.red : Color.gray, lineWidth: 1)
            )
            .keyboardType(.emailAddress)
            .onSubmit {
                isValidEmail = Validators.isValidEmail(email)
            }
    }
}

struct EmailTextField_Previews: PreviewProvider {
    static var previews: some View {
        EmailTextField(email: .constant(""), isValidEmail: .constant(true))
    }
}
