//
//  TokenManager.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation

final class TokenManager{
    static let shared = TokenManager()
    private let tokenKey = "accessToken"
    
    init() { }
    
    var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    
    func saveToken(_ token: String) {
        accessToken = token
    }
    
    func cleanToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    var isAuthenticated: Bool {
        return accessToken != nil
    }
}
