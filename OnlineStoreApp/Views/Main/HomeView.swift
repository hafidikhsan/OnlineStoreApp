//
//  HomeView.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var appRootManager: AppRootManager
    @EnvironmentObject private var productServices: ProductServices
    
    @State private var searchProductName: String = ""
    @State private var isAlertShow: Bool = false
    @State private var alertMessage: String = ""
    
    let columns = [
        GridItem(.adaptive(minimum: 170)),
        GridItem(.adaptive(minimum: 170)),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    HStack {
                        Text("Product")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            productServices.clearCreateForm()
                        }) {
                            NavigationLink(destination: CreateProductView()) {
                                Image("AddProductIcon").resizable().frame(width: 40,height: 40)
                            }
                        }
                    }
                    
                    SearchTextField(text: $searchProductName)
                    
                    switch productServices.status {
                    case .initialized:
                        VStack {
                            Spacer()
                            ProgressView()
                                .task {
                                    productServices.fetchingProductList(token: appRootManager.currentToken, search: searchProductName)
                                }
                            Spacer()
                        }
                    case .fetching:
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    case .error(let error):
                        VStack {
                            Spacer()
                            Text(error)
                            Spacer()
                        }
                    case .success:
                        VStack {
                            if productServices.productList!.data.items.count == 0 {
                                Spacer()
                                Image("EmptyIcon")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Text("Add Product")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.blue)
                                Spacer()
                            } else {
                                ScrollView {
                                    LazyVGrid(columns: columns, spacing: 20) {
                                        ForEach(productServices.productList!.data.items, id: \.id) { list in
                                            ProductCard(image: list.image, name: list.title, variant: list.totalVariant, stock: list.totalStok, price: list.price)
                                        }
                                    }
                                }
                                .refreshable {
                                    productServices.fetchingProductList(token: appRootManager.currentToken, search: searchProductName)
                                }
                            }
                        }
                    }
                }
                .padding()
                
                Button {
                    isAlertShow = true
                } label: {
                    Image("LogoutIcon")
                        .resizable()
                        .frame(width: 80,height: 80)
                }
                .padding()
            }
            .alert(isPresented:$isAlertShow) {
                Alert(
                    title: Text("Log Out ?"),
                    message: Text("Are you sure to log out ?"),
                    primaryButton: .destructive(Text("Log Out")) {
                        self.appRootManager.currentToken = ""
                        withAnimation(.spring()) {
                            appRootManager.currentRoot = .welcome
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AppRootManager()).environmentObject(ProductServices())
    }
}
