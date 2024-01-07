//
//  SearchTextField.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

struct SearchTextField: View {
    
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject private var productServices: ProductServices
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image("SearchIcon").resizable().frame(width: 35,height: 35)
            
            TextField("Search", text: $text)
                .onSubmit {
                    productServices.fetchingProductList(token: appRootManager.currentToken, search: text)
                }
                .submitLabel(.search)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(text: .constant("")).environmentObject(AppRootManager()).environmentObject(ProductServices())
    }
}
