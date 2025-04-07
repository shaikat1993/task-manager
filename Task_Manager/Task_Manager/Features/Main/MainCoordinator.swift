//
//  MainCoordinator.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 7/4/25.
//

import Foundation
import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    func showTaskList()
    func showTaskDetail(_ task: TaskModel)
    func handleLogout()
}

final class MainCoordinator: BaseCoordinator {
    private weak var taskListVC: TaskListViewController?
    
    override func start() {
        showTaskVC()
    }
    
    private func showTaskVC() {
        let viewModel = TaskListViewModel(delegate: self)
        let viewController = TaskListViewController.instantiate(fromStoryboard: .tasks,
                                                                viewModel: viewModel)
        taskListVC = viewController
        navigationController.setViewControllers([viewController],
                                                animated: true)
    }
    
    
    private func showTaskDetailVC(_ task: TaskModel) {
        let viewModel = TaskDetailViewModel(task: task,
                                            delegate: self)
        let viewController = TaskDetailViewController.instantiate(fromStoryboard: .taskDetails,
                                                                  viewModel: viewModel)
        push(viewController)
    }
    
    private func showLogout() {
        TokenManager.shared.cleanToken()
        if let appCoordinator: AppCoordinator = findCoordinator() {
            appCoordinator.start()
        }
    }
}

extension MainCoordinator: MainCoordinatorProtocol {
    func showTaskList() {
        popToRoot()
    }
    
    func showTaskDetail(_ task: TaskModel) {
        showTaskDetailVC(task)
    }
    
    func handleLogout() {
        showLogout()
    }
}
