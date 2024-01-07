//
//  EditVariantView.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 08/01/24.
//

import SwiftUI
import PhotosUI

struct EditVariantView: View {
    
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject private var productServices: ProductServices
    @Environment(\.dismiss) private var dismiss
    
    var variantParam: Variant
    
    @State var variant: Variant
    
    @State private var isSuccess: Bool = false
    @State private var isAlertShow: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    init(variantParam: Variant) {
        self.variantParam = variantParam
        _variant = State(initialValue: variantParam)
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
                    
                    Text("Edit Variant")
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
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                    
                    VStack(alignment: .leading)  {
                        Text("Variant Name")
                            .font(.title3)
                            .fontWeight(.bold)
                        TextField("Variant Name", text: $variant.name)
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
                            TextField("0", value: $variant.price, formatter: Self.formatter)
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
                            TextField("0", value: $variant.stock, formatter: Self.formatter)
                                .keyboardType(.numberPad)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            
                            Button {
                                variant.stock -= 1
                            } label: {
                                Text("-")
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                            
                            Button {
                                variant.stock += 1
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
                    let isNameValid = variant.name.count > 0 && variant.name.count <= 100
                    
                    if isNameValid && variant.stock >= 0 && variant.price >= 0 {
                        if let image = selectedImageData {
                            productServices.updateVariant(token: appRootManager.currentToken, id: variant.id, name: variant.name, image: "data:image/jpeg;base64," + image.base64EncodedString(), stock: variant.stock, price: variant.price) { result in
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
                            isAlertShow.toggle()
                            alertMessage = "Image is empty"
                        }
                    } else {
                        isAlertShow.toggle()
                        alertMessage = "Input Invalid"
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

struct EditVariantView_Previews: PreviewProvider {
    static var previews: some View {
        EditVariantView(variantParam: Variant(id: 10, image: "https://picsum.photos/id/12/600", name: "Variant Name", price: 1000, stock: 10)).environmentObject(ProductServices()).environmentObject(AppRootManager())
    }
}
