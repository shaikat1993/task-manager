//
//  Endpoint.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: [String:Any]? { get }
    var requiresAuth: Bool { get }
}

extension Endpoint {
    var url: URL?{
        return URL(string: baseURL + path)
    }
    
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    
    var requiresAuth: Bool {
        return true
    }
}
