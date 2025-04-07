//
//  TaskModel.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import UIKit

struct TaskModel: Codable {
    let id: String
    let title: String
    let description: String
    let dueDate: Date
    let status: TaskStatus
    let priority: TaskPriority
    
    enum TaskStatus: String,
                     Codable {
        case todo       = "TODO"
        case inProgress = "IN_PROGRESS"
        case done       = "DONE"
        
        var displayText: String {
            switch self {
            case .todo:
                return "To Do"
            case .inProgress:
                return "In Progress"
            case .done:
                return "Done"
            }
        }
        
        var color: UIColor {
            switch self {
            case .todo:
                return .systemGreen
            case .inProgress:
                return .systemYellow
            case .done:
                return .systemRed
            }
        }
    }
    
    enum TaskPriority: String,
                       Codable {
        case low,
             medium,
             high
       
        var displayText: String {
            switch self {
            case .low:
                return "Low"
            case .medium:
                return "Medium"
            case .high:
                return "High"
            }
        }
        
        var color: UIColor {
            switch self {
            case .low:
                return .systemGreen
            case .medium:
                return .systemYellow
            case .high:
                return .systemRed
            }
        }
    }
}
