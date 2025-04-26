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
    static let shared =  NetworkManager()
    private var chacheImage = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getData(completed: @escaping (Result<[Appetizer], AppError>) -> Void) {
        guard let url = URL(string: "https://seanallen-course-backend.herokuapp.com/swiftui-fundamentals/appetizers") else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(AppetizerResponse.self, from: data)
                completed(.success(decodedResponse.request))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = self.chacheImage.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.chacheImage.setObject(image, forKey: cacheKey)
            completed(image)
            return
        }
        
        task.resume()
    }
}
