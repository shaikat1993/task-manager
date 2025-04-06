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
    func handleRegistrationRequest()
    func navigateBackToLogin()
}

/// Coordinator handling authentication flow
final class AuthCoordinator: BaseCoordinator {
    private weak var loginVC: LoginViewController?
    
    override func start() {
        showLogin()
    }
    
    private func showLogin() {
        let storyboard = UIStoryboard(name: "Login",
                                      bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
                    withIdentifier: "LoginViewController"
                ) as? LoginViewController else {
                    return
                }
        let viewModel = LoginViewModel(delegate: self)
        viewController.viewModel = viewModel
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    private func showRegistration() {
//        let viewModel = RegistrationViewModel(coordinator: self)
//        let viewController = RegistrationViewController(viewModel: viewModel)
//        viewController.coordinator = self
//        push(viewController)
    }
    
    internal func navigateBackToLogin() {
        guard let loginVC = loginVC else {return}
        navigationController.popToViewController(loginVC,
                                                 animated: true)
    }
}

extension AuthCoordinator: AuthCoordinatorProtocol {
    func handleSuccessfulLogin() {
        cleanup()
        if let appCoordinator = findCoordinator() as AppCoordinator? {
            appCoordinator.start()
        }
    }
    
    func handleRegistrationRequest() {
        showRegistration()
    }
}
