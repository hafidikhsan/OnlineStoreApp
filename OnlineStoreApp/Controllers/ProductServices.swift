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
    
    @Published var createProductName = ""
    @Published var createProductDesc = ""
    @Published var createProductVariants: [CreateVariant] = []
    @Published var createVariantName = ""
    @Published var createVariantImage = ""
    @Published var createVariantPrice = 0
    @Published var createVariantStock = 0
    
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
                        print("Fetch successful - Code: \(productListResponse.code), Message: \(productListResponse.message)")
                    } else {
                        print("Fetch failed - Code: \(productListResponse.code), Message: \(productListResponse.message)")
                        self.status = .error("Status \(productListResponse.code): \(productListResponse.message)")
                    }
                } catch {
                    self.status = .error(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    func createProduct(form: ProductForm, token: String, completion: @escaping (Result<Registration?, Error>) -> Void) {
        self.status = .fetching
        
        guard let url = URL(string: self.baseURL) else {
            self.status = .error("Invalid URL")
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(form)
            request.httpBody = jsonData
        } catch {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error Decode JSON"])))
            self.status = .error("Error Decode JSON")
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    self.status = .error("No data received")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let uploadProductResponse = try decoder.decode(Registration.self, from: data)

                    if uploadProductResponse.code == "20000" {
                        self.status = .success
                        print("Upload successful - Code: \(uploadProductResponse.code), Message: \(uploadProductResponse.message)")
                    } else {
                        print("Upload failed - Code: \(uploadProductResponse.code), Message: \(uploadProductResponse.message)")
                        self.status = .error("Status \(uploadProductResponse.code): \(uploadProductResponse.message)")
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Status \(uploadProductResponse.code): \(uploadProductResponse.message)"])))
                    }
                } catch {
                    completion(.failure(error))
                    self.status = .error(error.localizedDescription)
                }
            }
        }

        task.resume()
    }
    
    func clearCreateForm() {
        self.status = .initialized
        self.createProductName = ""
        self.createProductDesc = ""
        self.createVariantImage = ""
        self.createVariantName = ""
        self.createProductVariants = []
        self.createVariantStock = 0
        self.createVariantPrice = 0
    }
    
    func clearCreateVariantForm() {
        self.createVariantImage = ""
        self.createVariantName = ""
        self.createVariantStock = 0
        self.createVariantPrice = 0
    }
}
