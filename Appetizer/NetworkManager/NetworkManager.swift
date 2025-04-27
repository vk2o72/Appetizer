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
        guard let url = URL(string: "https://seanallen-course-backend.herokuapp.com/swiftui-fundamentals/appetizers") else {
            throw AppError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw AppError.invalidResponse
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
