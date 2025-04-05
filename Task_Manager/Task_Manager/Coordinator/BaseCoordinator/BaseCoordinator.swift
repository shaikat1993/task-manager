//
//  BaseCoordinator.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import Foundation
import UIKit

/// Base coordinator class that implements common coordinator functionality
/// This class serves as the foundation for all coordinators in the application
/// providing shared behavior and state management
class BaseCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    /// The navigation controller used for this coordinator's flow
    let navigationController: UINavigationController
    /// Reference to the parent coordinator
    /// Weak reference to avoid retain cycles
    weak var parentCoordinator: CoordinatorProtocol?
    /// Array of child coordinators
    /// Each coordinator is responsible for managing its child coordinators
    var childCoordinator: [CoordinatorProtocol] = []
    
    // MARK: - Initialization
        
    /// Creates a new BaseCoordinator
    /// - Parameter navigationController: The navigation controller to be used for this coordinator's flow
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - CoordinatorProtocol
    /// Abstract method to start the coordinator's flow
    /// Must be overridden by subclasses
    func start() {
        fatalError("Start method must be implemented by subclass")
    }
    
    // MARK: - Navigation Helpers
    
    /// Presents a view controller modally
    /// - Parameters:
    ///   - viewController: The view controller to present
    ///   - animated: Whether to animate the presentation
    ///   - completion: Optional completion handler
    func present(_ viewController: UIViewController,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil) {
        navigationController.present(viewController,
                                     animated: animated,
                                     completion: completion)
    }
    
    /// Pushes a view controller onto the navigation stack
    /// - Parameters:
    ///   - viewController: The view controller to push
    ///   - animated: Whether to animate the push
    func push(_ viewController: UIViewController,
              animated: Bool = true) {
        navigationController.pushViewController(viewController,
                                                animated: animated)
    }
    
    /// Pops the top view controller from the navigation stack
    /// - Parameter animated: Whether to animate the pop
    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
    
    /// Pops to the root view controller
    /// - Parameter animated: Whether to animate the pop
    func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }
    
    /// Dismisses the currently presented view controller
    /// - Parameters:
    ///   - animated: Whether to animate the dismissal
    ///   - completion: Optional completion handler
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated,
                                     completion: completion)
    }
    
    // MARK: - Child Coordinator Management
    
    /// Adds and starts a child coordinator
    /// - Parameter coordinator: The coordinator to add and start
    func addChild(_ coordinator: CoordinatorProtocol) {
        childCoordinator.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    /// Removes a child coordinator
    /// - Parameter coordinator: The coordinator to remove
    func removeChild(_ coordinator: CoordinatorProtocol) {
        childCoordinator.removeAll{ $0 === coordinator }
    }
    
    /// Removes all child coordinators
    func removeAllChildren() {
        childCoordinator.removeAll()
    }
    
    // MARK: - Memory Management
    /// Cleanup method to remove references and prevent memory leaks
    func cleanup(){
        removeAllChildren()
        removeChild(self)
    }
}

// MARK: - Type Safe Coordinator Access
extension BaseCoordinator {
    /// Gets the nearest ancestor coordinator of the specified type
    /// - Returns: The first ancestor coordinator matching the specified type, or nil if none found
    func findCoordinator<T: CoordinatorProtocol>() -> T? {
        var current: CoordinatorProtocol? = self
        
        while let coordinator = current {
            if let typed = coordinator as? T {
                return typed
            }
            current = coordinator.parentCoordinator
        }
        return nil
    }
}
