//
//  LoginViewModel.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 6/4/25.
//

import Foundation
import Combine

final class LoginViewModel {
    @Published var email = ""
    @Published var password = ""
    
    @Published private(set) var emailError: String?
    @Published private(set) var passwordError: String?
    
    @Published private(set) var isLoading = false
    @Published private(set) var canLogin = false
    @Published private(set) var error: Error?
    
    private weak var delegate: AuthCoordinatorProtocol?
    private var cancellables = Set<AnyCancellable>()
    private var shouldShowErrors = false  // Add this flag
    
    init(delegate: AuthCoordinatorProtocol? = nil) {
        self.delegate = delegate
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest($email, $password)
            .map { [weak self] email, password in
                if self?.shouldShowErrors == true {
                    self?.validateEmail(email)
                    self?.validatePassword(password)
                }
                return !email.isEmpty && !password.isEmpty
            }
            .assign(to: \.canLogin, on: self)
            .store(in: &cancellables)
    }
    
    private func validateEmail(_ email: String) {
        if email.isEmpty {
            emailError = "Email is required"
        } else if !email.contains("@") {
            emailError = "Please enter a valid email"
        } else {
            emailError = nil
        }
    }
    
    private func validatePassword(_ password: String) {
        if password.isEmpty {
            passwordError = "Password is required"
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
        } else {
            passwordError = nil
        }
    }
    
    func login() {
        shouldShowErrors = true  // Enable error showing when login is attempted
        
        // Validate again before proceeding
        validateEmail(email)
        validatePassword(password)
        
        guard canLogin else { return }
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isLoading = false
            // For testing
            self?.delegate?.handleSuccessfulLogin()
        }
    }
    
    func showRegistration() {
        delegate?.showRegistration()
    }
}
