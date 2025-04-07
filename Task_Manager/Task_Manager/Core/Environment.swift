//
//  Environment.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation

enum Environment {
    case development
    case staging
    case production
    
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

struct Configuration {
    static let shared = Configuration()
    
    var baseURL: String {
        switch Environment.current {
        case .development:
            return "http://localhost:5000/api"
        case .staging:
            return "" //[https://staging-api.yourdomain.com/api"](https://staging-api.yourdomain.com/api")
        case .production:
            return "" //[https://api.yourdomain.com/api"](https://api.yourdomain.com/api")
        }
    }
    
    var apiTimeout: TimeInterval {
        switch Environment.current {
        case .development:
            return 30
        case .staging, .production:
            return 15
        }
    }
    
    var shouldShowLogs: Bool {
        switch Environment.current {
        case .development:
            return true
        case .staging, .production:
            return false
        }
    }
}
