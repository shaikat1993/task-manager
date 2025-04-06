//
//  RegistrationViewModel.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 6/4/25.
//

import Foundation
import Combine

final class RegistrationViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    @Published private(set) var nameError: String?
    @Published private(set) var emailError: String?
   
    @Published private(set) var passwordError: String?
    @Published private(set) var confirmPasswordError: String?
    
    @Published private(set) var canRegister = false
    
    var name: String = "" {
        didSet {
            validateName()
        }
    }
    var email: String = "" {
        didSet{
            validateEmail()
        }
    }
    
    var password: String = "" {
        didSet{
            validatePassword()
            validateConfirmPassword()
        }
    }
    
    var confirmPassword: String = "" {
        didSet {
            validateConfirmPassword()
        }
    }
    
    private weak var delegate: AuthCoordinatorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    init(delegate: AuthCoordinatorProtocol? = nil) {
        self.delegate = delegate
    }
    
    func register() {
        guard canRegister else {return}
        isLoading = true
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading = false
            // for testing
            self?.delegate?.handleSuccessfulLogin()
        }
    }
    
    func navigateBackToLogin() {
        delegate?.navigateBackToLogin()
    }
    
    
    private func validateName() {
        if name.isEmpty {
            nameError = "Name is required"
        } else if name.count < 3 {
            nameError = "Name must be at least 3 characters"
        } else {
            nameError = nil
        }
        updateCanRegister()
    }
    
    private func validateEmail() {
        if email.isEmpty {
            emailError = "Email is required"
        } else {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            emailError = emailPredicate.evaluate(with: email) ? nil : "Please enter a valid email"
        }
        updateCanRegister()
    }
    
    private func validatePassword() {
        if password.isEmpty {
            passwordError = "Password is required"
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
        } else {
            passwordError = nil
        }
        updateCanRegister()
    }
    
    private func validateConfirmPassword() {
        if confirmPassword.isEmpty {
            confirmPasswordError = "Please confirm your password"
        } else if confirmPassword != password {
            confirmPasswordError = "Passwords do not match"
        } else {
            confirmPasswordError = nil
        }
        updateCanRegister()
    }
    
    private func updateCanRegister() {
        canRegister = (emailError == nil) &&
                   (!email.isEmpty) &&
                   (passwordError == nil) &&
                   (!password.isEmpty) &&
                   (confirmPasswordError == nil) &&
                   (!confirmPassword.isEmpty)
    }
}
