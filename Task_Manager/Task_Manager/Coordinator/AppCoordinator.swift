//
//  AppCoordinator.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import Foundation
import UIKit

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
        // for testing
        //showAuthFlow()
        
        
//        // Check authentication status
//        if TokenManager.shared.isAuthenticated {
//            //showMainFlow()
//        } else {
//            showAuthFlow()
//        }
        
        showLaunchScreen()
    }
    
    private func handleLaunchComplete() {
//        if TokenManager.shared.isAuthenticated {
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
}
