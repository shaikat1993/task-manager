//
//  TaskModel.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation

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
    }
    
    enum TaskPriority: String,
                       Codable {
        case low,
             medium,
             high
    }
}
