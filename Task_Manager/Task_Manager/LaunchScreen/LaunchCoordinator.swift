//
//  LaunchCoordinator.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import Foundation
import UIKit

protocol LaunchCoordinatorProtocol: AnyObject {
    func launchDidCompleted()
}

final class LaunchCoordinator: BaseCoordinator,
                               LaunchCoordinatorProtocol {
    // MARK: - Properties
    private let completion: () -> Void
    
    // MARK: - Initialization
    init(navigationController: UINavigationController,
         completion: @escaping () -> Void) {
        self.completion = completion
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        showLaunchScreen()
    }
    
    // MARK: - LaunchCoordinatorProtocol
    func launchDidCompleted() {
        cleanup()
        completion()
    }
    
    // MARK: - Private Methods
    private func showLaunchScreen() {
        let storyboard = UIStoryboard(name: "Launch", 
                                      bundle: nil)
        let viewModel = LaunchViewModel(coordinator: self)
        guard let viewController = storyboard.instantiateViewController(identifier: "LaunchViewController") as? LaunchViewController else {
                return
            }
        viewController.viewModel = viewModel
        navigationController.setViewControllers([viewController],
                                                animated: false)
    }
}
