//
//  PasswordTextField.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

struct PasswordTextField: View {
    
    @Binding var text: String
    @Binding var isShow: Bool
    @Binding var isValidPassword: Bool
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if isShow {
                TextField("* * * * * *", text: $text)
                    .onSubmit {
                        isValidPassword = Validators.isValidPassword(text)
                    }
            } else {
                SecureField("* * * * * *", text: $text)
                    .onSubmit {
                        isValidPassword = Validators.isValidPassword(text)
                    }
            }
            
            Button(action: {
                isShow.toggle()
            }) {
                Image(isShow ? "EyeSlashIcon" : "EyeIcon").resizable().frame(width: 25,height: 25)
            }
            .padding(.trailing, 8)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(!isValidPassword ? Color.red : Color.gray, lineWidth: 1)
        )
    }
}

struct PasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextField(text: .constant(""), isShow: .constant(false), isValidPassword: .constant(true))
    }
}
