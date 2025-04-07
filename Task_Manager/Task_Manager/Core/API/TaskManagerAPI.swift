//
//  TaskManagerAPI.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation

enum TaskManagerAPI: Endpoint {
    case register(name: String, email: String, password: String)
    case login(email: String, password: String)
    case tasks
    case createTask(TaskModel)
    case updateTask(TaskModel)
    case deleteTask(TaskModel)
    
    var baseURL: String {
        return Configuration.shared.baseURL
    }
    
    var path: String {
        switch self {
        case .register:
            return "/users/register"
        case .login:
            return "/users/login"
        case .tasks:
            return "/tasks"
        case .createTask:
            return "/tasks"
        case .updateTask(let task):
            return "/tasks/\(task.id)"
        case .deleteTask(let id):
            return "/tasks/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register,
                .login,
                .createTask:
            return .post
        case .tasks:
            return .get
        case .updateTask:
            return .put
        case .deleteTask:
            return .delete
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .register, .login:
            return false
        default:
            return true
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .register(let name,
                       let email,
                       let password):
            return [
                "name": name,
                "email": email,
                "password": password
            ]
        case .login(let email, 
                    let password):
            return [
                "email": email,
                "password": password
            ]
        case .createTask(let task), .updateTask(let task):
            return [
                "title": task.title,
                "description": task.description,
                "status": task.status.rawValue,
                "priority": task.priority.rawValue,
                "dueDate": ISO8601DateFormatter().string(from: task.dueDate)
            ]
        default:
            return nil
        }
    }
}

struct LoginResponse: Codable {
    let user: User
    let token: String
}

struct User: Codable {
    let id: String
    let email: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"  // If your backend uses _id
        case name
        case email
    }
}
