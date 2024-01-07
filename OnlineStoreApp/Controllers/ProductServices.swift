//
//  ProductServices.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import Foundation

class ProductServices: ObservableObject {
    
    let baseURL = "https://tes-skill.datautama.com/test-skill/api/v1/product"
    
    @Published var status: fetchingAPIStatus = .initialized
    @Published var productList: ProductList?
    
    func fetchingProductList(token: String, search: String) {
        self.status = .fetching
        
        guard let url = URL(string: self.baseURL) else {
            self.status = .error("Invalid URL")
            return
        }
        
        var request: URLRequest
        
        if search.count > 0 {
            var searchURL = URLComponents(string: baseURL)!
            
            searchURL.queryItems = [
                URLQueryItem(name: "search", value: search),
            ]
            
            request = URLRequest(url: searchURL.url!)
        } else {
            request = URLRequest(url: url)
        }
        
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self.status = .error("No data received")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let productListResponse = try decoder.decode(ProductList.self, from: data)
                    
                    if productListResponse.code == "20000" {
                        self.productList = productListResponse
                        self.status = .success
                    } else {
                        self.status = .error("Status \(productListResponse.code): \(productListResponse.message)")
                    }
                } catch {
                    print(data)
                    self.status = .error(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
}
