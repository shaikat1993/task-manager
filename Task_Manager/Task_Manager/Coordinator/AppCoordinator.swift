//
//  AppCoordinator.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import Foundation
import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinish()
}

/// The root coordinator of the application.
/// Responsible for:
/// - Initial setup of the window
/// - Managing top-level navigation flows
/// - Coordinating between major features
final class AppCoordinator: BaseCoordinator {

    private let window: UIWindow
    
    /// Creates a new AppCoordinator
    /// - Parameters:
    ///   - window: The main window of the application
    ///   - navigationController: The root navigation controller
    init(window: UIWindow,
         navigationController: UINavigationController) {
        self.window = window
        super.init(navigationController: navigationController)
        setupWindow()
    }
    // MARK: - Private Methods
    
    /// Sets up the main window with the root navigation controller
    func setupWindow() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
        
    /// Starts the flow managed by the coordinator
    override func start() {
        showLaunchScreen()
    }
    
    private func handleLaunchComplete() {
        showMainFlow()
        // Check authentication status
//        if TokenManager.shared.isLoggedIn {
//            showMainFlow()
//        } else {
//            showAuthFlow()
//        }
    }
    
    /// Shows the launch screen
    private func showLaunchScreen(){
        let coordinator = LaunchCoordinator(navigationController: navigationController) {
            [weak self] in
            self?.handleLaunchComplete()
        }
        addChild(coordinator)
        coordinator.start()
    }
    
    private func showAuthFlow() {
        let coordinator = AuthCoordinator(navigationController: navigationController)
        addChild(coordinator)
    }
    
    private func showMainFlow() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        addChild(coordinator)
    }
}

extension AppCoordinator : AuthCoordinatorDelegate {
    func authCoordinatorDidFinish() {
        showMainFlow()
    }
}
