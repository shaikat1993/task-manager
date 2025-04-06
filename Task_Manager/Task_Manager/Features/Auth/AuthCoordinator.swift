//
//  AuthCoordinator.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import Foundation
import UIKit

protocol AuthCoordinatorProtocol: AnyObject {
    func handleSuccessfulLogin()
    func handleSuccessfulRegistration()
    func showRegistration()
    func navigateBackToLogin()
}

/// Coordinator handling authentication flow
final class AuthCoordinator: BaseCoordinator {
    private weak var loginVC: LoginViewController?
    
    override func start() {
        showLogin()
    }
    
    private func showLogin() {
        let viewModel = LoginViewModel(delegate: self)
        let viewController = LoginViewController.instantiate(fromStoryboard: .login,
                                                  viewModel: viewModel)
        loginVC = viewController
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    internal func showRegistration() {
        let viewModel = RegistrationViewModel(delegate: self)
        let viewController = RegistrationViewController.instantiate(fromStoryboard: .registration,
                                                                    viewModel: viewModel)
        push(viewController)
    }
    
    internal func navigateBackToLogin() {
        guard let loginVC = loginVC else {return}
        navigationController.popToViewController(loginVC,
                                                 animated: true)
    }
}

extension AuthCoordinator: AuthCoordinatorProtocol {
    func handleSuccessfulRegistration() {
        handleSuccessfulLogin()
    }
    
    func handleSuccessfulLogin() {
        cleanup()
        if let appCoordinator = findCoordinator() as AppCoordinator? {
            appCoordinator.start()
        }
    }
}
