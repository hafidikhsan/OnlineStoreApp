//
//  CreateProductView.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

struct CreateProductView: View {
    
    @EnvironmentObject private var productServices: ProductServices
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAlertShow: Bool = false
    @State private var alertMessage: String = ""
    
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
                        
                        // For Each CreateVariant
                        
                        Button {} label: {
                            Text("Add Variant Product")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(.blue, lineWidth: 1)
                                )
                        }
                        .padding(.bottom, 10)
                    }.padding(.top, 10)
                }.padding()
                
                Button {
                    let isNameValid = productServices.createProductName.count > 0 && productServices.createProductName.count <= 200
                    let isDescValid = productServices.createProductDesc.count > 0 && productServices.createProductDesc.count <= 500
                    // Check list
                    
                    if isNameValid && isDescValid {
                        print(productServices.createProductName, productServices.createProductDesc)
                        alertMessage = ""
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
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)
            }
            .alert("Create Product Failed", isPresented: $isAlertShow) {
                Button("Try Again") {
                    alertMessage = ""
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
        CreateProductView().environmentObject(ProductServices())
    }
}
