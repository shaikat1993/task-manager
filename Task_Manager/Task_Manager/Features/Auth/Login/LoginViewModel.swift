//
//  LoginViewModel.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 6/4/25.
//

import Foundation
import Combine

enum LoginError: LocalizedError {
    case invalidCredentials
    case serverError(Int)
    case networkError(String)
    case validationError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .serverError(let code):
            return "Server error: \(code)"
        case .networkError(let message):
            return message
        case .validationError(let message):
            return message
        }
    }
}

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
        
        let endpoint = TaskManagerAPI.login(email: email,
                                            password: password)
        
        NetworkManager.shared.request(endpoint: endpoint) { [weak self] (result: Result<LoginResponse, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    TokenManager.shared.saveToken(response.token)
                    self.delegate?.handleSuccessfulLogin()
                    
                case .failure(let error):
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .unauthorized:
                            self.error = LoginError.invalidCredentials
                        case .serverError(let code):
                            self.error = LoginError.serverError(code)
                        default:
                            self.error = LoginError.networkError(networkError.description)
                        }
                    } else {
                        self.error = LoginError.networkError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func showRegistration() {
        delegate?.showRegistration()
    }
}
