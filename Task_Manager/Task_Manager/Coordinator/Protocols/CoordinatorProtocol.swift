//
//  CoordinatorProtocol.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import Foundation
import UIKit

/// Protocol that defines the base functionality for all coordinators in the application.
/// Coordinators are responsible for handling navigation flow and dependency injection between screens.
protocol CoordinatorProtocol: AnyObject {
    /// The navigation controller used by this coordinator
    var navigationController: UINavigationController { get }
    /// Reference to the parent coordinator, if any
    var parentCoordinator: CoordinatorProtocol? { get set }
    /// Array of child coordinators of this coordinator
    var childCoordinator: [CoordinatorProtocol] { get set }
    
    /// Starts the flow managed by the coordinator
    func start()
    /// Cleanup when the coordinator is no longer needed
    func finish()
    /// Add a child coordinator and start its flow
    /// - Parameter coordinator: The coordinator to start
    func coordinate(to coordinator: CoordinatorProtocol)
}

// MARK: - Default Implementation
extension CoordinatorProtocol {
    /// Default implementation of coordinate(to:)
    /// - Parameter coordinator: The coordinator to start
    /// This method:
    /// 1. Adds the new coordinator to childCoordinators
    /// 2. Sets up the parent-child relationship
    /// 3. Starts the new coordinator's flow
    func coordinate(to coodinator: CoordinatorProtocol) {
        childCoordinator.append(coodinator)
        coodinator.parentCoordinator = self
        coodinator.start()
    }
    
    /// Default implementation of finish()
    /// This method:
    /// 1. Removes all child coordinators
    /// 2. Removes self from parent's childCoordinators
    func finish() {
        childCoordinator.removeAll()
        parentCoordinator?.childCoordinator.removeAll{ ($0 === self) }
    }
}
