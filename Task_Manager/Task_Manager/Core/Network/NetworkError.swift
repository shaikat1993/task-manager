//
//  NetworkError.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation
enum NetworkError : Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unauthorized
    case custom(String)
    
    var description: String{
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Error decoding response"
        case .serverError(let code):
            return "Server error: \(code)"
        case .unauthorized:
            return "Unauthorized access"
        case .custom(let message):
            return message
        }
    }
}
