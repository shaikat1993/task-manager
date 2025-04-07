//
//  TaskDetailViewModel.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation
import Combine

final class TaskDetailViewModel {
    private let task: TaskModel
    private weak var delegate: MainCoordinatorProtocol?
    
    @Published private(set) var sections: [TaskDetailSection] = []
    
    init(task: TaskModel,
         delegate: MainCoordinatorProtocol? = nil) {
        self.task = task
        self.delegate = delegate
        setupSections()
    }
    private func setupSections() {
        sections = [
            .info([.title(task.title),
                   .description(task.description)]),
            .status([.priority(task.priority),
                .status(task.status)]),
            .date([.dueDate(task.dueDate)])
        ]
    }
}


// MARK: - Section Models
enum TaskDetailSection {
    case info([TaskDetailItem])
    case status([TaskDetailItem])
    case date([TaskDetailItem])
    
    var title: String {
        switch self {
        case .info: return "Information"
        case .status: return "Status"
        case .date: return "Date"
        }
    }
    
    var items: [TaskDetailItem] {
        switch self {
        case .info(let items): return items
        case .status(let items): return items
        case .date(let items): return items
        }
    }
}

enum TaskDetailItem {
    case title(String)
    case description(String)
    case priority(TaskModel.TaskPriority)
    case status(TaskModel.TaskStatus)
    case dueDate(Date)
    
    var isTitle: Bool {
        switch self {
        case .title:
            return true
        default:
            return false
        }
    }
}
