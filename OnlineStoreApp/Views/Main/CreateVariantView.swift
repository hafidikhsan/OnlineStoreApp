//
//  CreateVariantView.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI
import PhotosUI

struct CreateVariantView: View {
    
    @EnvironmentObject private var productServices: ProductServices
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAlertShow: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("BackIcon").resizable().frame(width: 40,height: 40)
                    }
                    
                    Text("Create Variant")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                }.padding()
                
                ScrollView {
                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipped()
                            .shadow(color: .gray, radius: 8, x: 0, y: 5)
                    } else {
                        ZStack {
                            Image("ImageIcon")
                        }
                        .frame(width: 200, height: 200)
                        .shadow(color: .gray, radius: 8, x: 0, y: 5)
                    }
                    
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Select a photo")
                                .padding()
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                // Retrieve selected asset in the form of Data
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                    
                    VStack(alignment: .leading)  {
                        Text("Variant Name")
                            .font(.title3)
                            .fontWeight(.bold)
                        TextField("Variant Name", text: $productServices.createVariantName)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    VStack(alignment: .leading) {
                        Text("Harga")
                            .font(.title3)
                            .fontWeight(.bold)
                        HStack {
                            VStack{
                                Text("Rp. ")
                                    .padding()
                                    .background(.gray)
                            }
                            TextField("0", value: $productServices.createVariantPrice, formatter: Self.formatter)
                                .keyboardType(.numberPad)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                    VStack(alignment: .leading) {
                        Text("Stok")
                            .font(.title3)
                            .fontWeight(.bold)
                        HStack {
                            TextField("0", value: $productServices.createVariantStock, formatter: Self.formatter)
                                .keyboardType(.numberPad)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            
                            Button {
                                productServices.createVariantStock -= 1
                            } label: {
                                Text("-")
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                            
                            Button {
                                productServices.createVariantStock += 1
                            } label: {
                                Text("+")
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                    }
                }.padding()
                
                Button {
                    // Check Value
                    
                    // Append to publish [CreateVariant]
                } label: {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

struct CreateVariantView_Previews: PreviewProvider {
    static var previews: some View {
        CreateVariantView().environmentObject(ProductServices())
    }
}
