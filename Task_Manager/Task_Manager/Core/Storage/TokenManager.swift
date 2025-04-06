//
//  TokenManager.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation

final class TokenManager{
    static let shared = TokenManager()
    private let tokenKey = "userToken"
    
    init() { }
    
    var isLoggedIn: Bool {
        return token != nil
    }
    var token: String? {
        get{
            UserDefaults.standard.string(forKey: tokenKey)
        } set{
            UserDefaults.standard.setValue(newValue, 
                                           forKey: tokenKey)
        }
    }
    
    func cleanToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
