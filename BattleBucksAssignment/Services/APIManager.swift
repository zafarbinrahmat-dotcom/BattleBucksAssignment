//
//  APIManager.swift
//  BattleBucksAssignment
//
//  Created by Zafar Bin Rahmat on 19/10/25.
//

import Foundation

final class APIManager {
    
    private init() {}
    
    static let shared = APIManager()
    private let session = URLSession.shared
    
    private func buildGETRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    private func performRequest<T: Decodable>(reques: URLRequest, responseType: T.Type, complitionHandler: @escaping(Result<T, APIError>) -> Void) {
        let task = session.dataTask(with: reques) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                complitionHandler(.failure(.badStatusCode(httpResponse.statusCode)))
            }
            guard let data = data else {
                complitionHandler(.failure(.noData))
                return
            }
            
            let stringResponse = String(data: data, encoding: .utf8)
            print("response", stringResponse)
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                complitionHandler(.success(decodedData))
            } catch {
                complitionHandler(.failure(.decodingError))
            }
        }
        task.resume()
                                    
    }
    
    func getRequest<T: Decodable>(urlString: String, resonseType: T.Type, complitionHandler: @escaping(Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            complitionHandler(.failure(.invalidURL))
            return
        }
        let request = buildGETRequest(url: url)
        performRequest(reques: request, responseType: resonseType, complitionHandler: complitionHandler)
    }
    
}

extension APIManager {
    enum APIError: Error {
        case invalidURL
        case decodingError
        case networkError
        case badStatusCode(Int)
        case noData
    }
}
