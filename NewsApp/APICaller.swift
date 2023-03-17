//
//  APICaller.swift
//  NewsApp
//
//  Created by Ekrem on 16.03.2023.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadLinesURL = URL(string:"https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=053bba4a6c634971bdd02f88adbbda1c")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
            
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                   
                    print("Articles:\(result.articles.count)")
                    completion(.success(result.articles))
                    
                }
                catch {
                    completion(.failure(error))
                }
                
            }
        }
        task.resume()
    }
    
}

// API RESPONSE MODELS

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
