//
//  NetworkManager.swift
//  Appetizer
//
//  Created by Vivek Madhukar on 29/07/24.
//

import UIKit

enum AppError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
}

final class NetworkManager {
    static let shared = NetworkManager()
    private var cacheImage = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getData() async throws ->  [Appetizer] {
        guard let url = URL(string: "http://localhost:3000/foodItems") else {
            throw AppError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw AppError.invalidResponse
            }
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("Raw response JSON: \(prettyString)")
            } else {
                print("Failed to convert data to string")
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(AppetizerResponse.self, from: data)
                return decodedResponse.request
            } catch {
                throw AppError.invalidData
            }
        } catch {
            throw AppError.unableToComplete
        }
    }
    
    func getUserData() async throws ->  UserModel {
        guard let url = URL(string: "http://localhost:3000/getuserdata") else {
            throw AppError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [ "email": "vivekmadhukar05@gmail.com" ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            request.httpBody = jsonData
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw AppError.invalidResponse
            }
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("Raw response JSON: \(prettyString)")
            } else {
                print("Failed to convert data to string")
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(UserModel.self, from: data)
                return decodedResponse
            } catch {
                throw AppError.invalidData
            }
        } catch {
            throw AppError.unableToComplete
        }
    }
    
    func saveUserData(user: UserModel) async throws {
        guard let url = URL(string: "http://localhost:3000/updateuserdata") else {
            throw AppError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "email": user.email as Any,
            "firstName": user.firstName as Any,
            "lastName": user.lastName as Any,
            "extraNapkin": user.extraNapkin as Any,
            "frequentRefills": user.frequentRefills as Any
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            request.httpBody = jsonData
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw AppError.invalidResponse
            }
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("Raw response JSON: \(prettyString)")
            } else {
                print("Failed to convert data to string")
            }
            
            print("User saved successfully status code: \(response.statusCode)")
        } catch {
            throw AppError.unableToComplete
        }
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        
        if let image = self.cacheImage.object(forKey: cacheKey) {
            return image
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            self.cacheImage.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}
