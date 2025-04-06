//
//  TaskListViewModel.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation
import Combine

protocol TaskListViewModelProtocol {
    var tasks: [TaskModel] { get }
    var isLoading: Bool { get }
    
    func loadTasks()
    func selectTask(_ task: TaskModel)
    func logout()
}

final class TaskListViewModel{
    @Published private(set) var tasks: [TaskModel] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private weak var delegate: MainCoordinatorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    init(delegate: MainCoordinatorProtocol? = nil) {
        self.delegate = delegate
    }
    
    func loadTasks() {
        isLoading = true
        //simulate api call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){ [weak self] in
            self?.isLoading = false
            // Mock data
            self?.tasks = [
                TaskModel(id: "1",
                          title: "Complete Task Manager",
                          description: "Implement all features Implement all features Implement all features Implement all features Implement all features Implement all features Implement all features Implement all features Implement all features Implement all features Implement all features Implement all features Implement all features Implement all features",
                          dueDate: Date(),
                          status: .inProgress,
                          priority: .high),
                TaskModel(id: "2",
                          title: "Add Tests",
                          description: "Write unit tests",
                          dueDate: Date(),
                          status: .todo,
                          priority: .medium)
            ]
        }
    }
    
    func selectTask(_ task: TaskModel) {
        delegate?.showTaskDetail(task)
    }
    
    func logout() {
        delegate?.handleLogout()
    }
}
