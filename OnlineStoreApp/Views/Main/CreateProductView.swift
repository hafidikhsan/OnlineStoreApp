//
//  CreateProductView.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

struct CreateProductView: View {
    
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject private var productServices: ProductServices
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAlertShow: Bool = false
    @State private var isSuccess: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var variantPOST: [VariantForm] = []
    
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
                }.padding()
                ScrollView {
                    VStack(alignment: .leading)  {
                        Text("Name")
                            .font(.title3)
                            .fontWeight(.bold)
                        TextField("Product Name", text: $productServices.createProductName)
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
                        TextField("Product Description", text: $productServices.createProductDesc, axis: .vertical)
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
                        
                        ForEach(productServices.createProductVariants, id: \.self) { list in
                            CreateVariantCard(name: list.name, price: list.price, stock: list.stock, image: list.imageData)
                        }
                        
                        Button {
                            productServices.clearCreateVariantForm()
                        } label: {
                            NavigationLink(destination: CreateVariantView()) {
                                Text("Add Variant Product")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .background(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(.blue, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.bottom, 10)
                    }.padding(.top, 10)
                }.padding()
                
                Button {
                    let isNameValid = productServices.createProductName.count > 0 && productServices.createProductName.count <= 200
                    let isDescValid = productServices.createProductDesc.count > 0 && productServices.createProductDesc.count <= 500
                    let isVariantValid = productServices.createProductVariants.count > 0
                    
                    if isNameValid && isDescValid && isVariantValid {
                        for i in productServices.createProductVariants {
                            variantPOST.append(VariantForm(name: i.name, image: i.image, price: i.price, stock: i.stock))
                        }
                        
                        let formPOST = ProductForm(title: productServices.createProductName, description: productServices.createProductDesc, variants: variantPOST)
                        
                        productServices.createProduct(form: formPOST, token: appRootManager.currentToken) { result in
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
                        
                        if !isNameValid && !isDescValid && !isVariantValid {
                            alertMessage += "Name, Description, Variant "
                        } else if !isNameValid {
                            alertMessage += "Name "
                        } else if !isDescValid {
                            alertMessage += "Description "
                        } else {
                            alertMessage += "Variant "
                        }
                        
                        alertMessage += "Invalid!"
                        isAlertShow.toggle()
                    }
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)
            }
            .alert(isSuccess ? "Successful" : "Create Product Failed", isPresented: $isAlertShow) {
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

struct CreateProductView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProductView().environmentObject(ProductServices()).environmentObject(AppRootManager())
    }
}
