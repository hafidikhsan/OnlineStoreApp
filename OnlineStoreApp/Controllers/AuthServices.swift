//
//  AuthServices.swift
//  OnlineStoreApp
//
//  Created by Hafid Ikhsan Arifin on 07/01/24.
//

import Foundation

class AuthServices: ObservableObject {
    
    @Published var isLoading = false
    
    func authRegist(name: String, email: String, password: String, completion: @escaping (Result<Registration, Error>) -> Void) {
        self.isLoading = true
        
        let urlString = "https://tes-skill.datautama.com/test-skill/api/v1/auth/register"
        
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let parameters = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            self.isLoading = false
            completion(.failure(error))
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self.isLoading = false
                    completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let registerResponse = try decoder.decode(Registration.self, from: data)
                    
                    if registerResponse.code == "20000" {
                        self.isLoading = false
                        completion(.success(registerResponse))
                    } else {
                        self.isLoading = false
                        completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Status \(registerResponse.code): \(registerResponse.message)"])))
                    }
                } catch {
                    self.isLoading = false
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func authLogin(email: String, password: String, completion: @escaping (Result<Login, Error>) -> Void) {
        self.isLoading = true
        
        let urlString = "https://tes-skill.datautama.com/test-skill/api/v1/auth/login"
        
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let parameters = [
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            self.isLoading = false
            completion(.failure(error))
            return
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self.isLoading = false
                    completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let loginResponse = try decoder.decode(Login.self, from: data)
                    
                    if loginResponse.code == "20000" {
                        self.isLoading = false
                        completion(.success(loginResponse))
                    } else {
                        self.isLoading = false
                        completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Status \(loginResponse.code): \(loginResponse.message)"])))
                    }
                } catch {
                    self.isLoading = false
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
