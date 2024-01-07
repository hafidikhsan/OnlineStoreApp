//
//  EditProductView.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 08/01/24.
//

import SwiftUI

struct EditProductView: View {
    
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject private var productServices: ProductServices
    @Environment(\.dismiss) private var dismiss
    
    var productParam: Item
    
    @State var product: Item
    @State private var isAlertShow: Bool = false
    @State private var isSuccess: Bool = false
    @State private var alertMessage: String = ""
    
    init(productParam: Item) {
        self.productParam = productParam
        _product = State(initialValue: productParam)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("BackIcon").resizable().frame(width: 40,height: 40)
                    }
                    
                    Text("Create Product")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        // Delete function
                    } label: {
                        Image("DeleteIcon").resizable().frame(width: 40,height: 40)
                    }
                }.padding()
                
                ScrollView {
                    VStack(alignment: .leading)  {
                        Text("Name")
                            .font(.title3)
                            .fontWeight(.bold)
                        TextField("Product Name", text: $product.title)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    
                    VStack (alignment: .leading) {
                        Text("Description")
                            .font(.title3)
                            .fontWeight(.bold)
                        TextField("Product Description", text: $product.description, axis: .vertical)
                            .padding()
                            .lineLimit(3, reservesSpace: true)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }.padding(.top, 10)
                    
                    VStack (alignment: .leading) {
                        Text("Variant Product")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        ForEach(product.variants, id: \.id) { list in
                            EditVariantCard(name: list.name, price: list.price, stock: list.stock, image: list.image)
                        }
                    }.padding(.top, 10)
                }.padding()
                
                Button {
                    let isNameValid = product.title.count > 0 && product.title.count <= 200
                    let isDescValid = product.description.count > 0 && product.description.count <= 500
                    
                    print(product.title, product.description)
                    
                    if isNameValid && isDescValid {
                        productServices.updateProduct(token: appRootManager.currentToken, id: product.id, title: product.title, desc: product.description){ result in
                            switch result {
                            case .success(_):
                                isSuccess = true
                                alertMessage = "Upload successful"
                                isAlertShow.toggle()
                            case .failure(let error):
                                isAlertShow.toggle()
                                alertMessage = error.localizedDescription
                            }
                        }
                    } else {
                        alertMessage += "Product "
                        
                        if !isNameValid && !isDescValid {
                            alertMessage += "Name and Description "
                        } else if !isNameValid {
                            alertMessage += "Name "
                        } else {
                            alertMessage += "Description "
                        }
                        
                        alertMessage += "Invalid!"
                        isAlertShow.toggle()
                    }
                } label: {
                    Text("Update")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)
            }
            .alert(isSuccess ? "Successful" : "Update Product Failed", isPresented: $isAlertShow) {
                if isSuccess {
                    Button("Ok") {
                        alertMessage = ""
                        dismiss()
                    }
                } else {
                    Button("Try Again") {
                        alertMessage = ""
                    }
                }
            } message: {
                Text(alertMessage)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct EditProductView_Previews: PreviewProvider {
    static var previews: some View {
        EditProductView(productParam: Item(id: 0, title: "Product Name", description: "Product Desc", totalVariant: 10, totalStok: 10, price: 10000, image: "https://picsum.photos/id/12/600", variants: [Variant(id: 111, image: "https://picsum.photos/id/12/600", name: "Variant Name", price: 10000, stock: 10)])).environmentObject(ProductServices()).environmentObject(AppRootManager())
    }
}
