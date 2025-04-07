//
//  NetworkManager.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Configuration.shared.apiTimeout
        self.session = URLSession(configuration: config)
    }
    
    func request<T: Codable>(endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Decoding error:", error)
                throw NetworkError.decodingError
            }
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.serverError(httpResponse.statusCode)
        }
    }
    
    // Add completion handler version
    func request<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    print("Decoding error:", error)
                    completion(.failure(NetworkError.decodingError))
                }
                
            case 401:
                completion(.failure(NetworkError.unauthorized))
            default:
                completion(.failure(NetworkError.serverError(httpResponse.statusCode)))
            }
        }
        
        task.resume()
    }
}

// Then add the authenticate extension
extension NetworkManager {
    func authenticate(endpoint: TaskManagerAPI) async throws -> LoginResponse {
        let response: LoginResponse = try await request(endpoint: endpoint)
        TokenManager.shared.saveToken(response.token)
        return response
    }
}
