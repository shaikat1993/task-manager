//
//  Storyboard.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 6/4/25.
//

import Foundation
public enum Storyboard: String {
    case login = "Login"
    case registration = "Registration"
    
    var identifier: String {
        return rawValue
    }
}
