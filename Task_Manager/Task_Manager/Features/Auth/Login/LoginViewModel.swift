//
//  LoginViewModel.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 6/4/25.
//

import Foundation
import Combine

final class LoginViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private weak var delegate: AuthCoordinatorProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    init(delegate: AuthCoordinatorProtocol? = nil) {
        self.delegate = delegate
    }
    
    func login(email: String, 
               password: String) {
        guard (!email.isEmpty),
              (!password.isEmpty) else {
            error = ValidationError.emptyFields
            return
        }
        
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isLoading = false
            //for testing,
            self?.delegate?.handleSuccessfulLogin()
        }
    }
    
    func showRegistration() {
        delegate?.handleRegistrationRequest()
    }
}

extension LoginViewModel {
    enum ValidationError: LocalizedError {
        case emptyFields
        
        var errorDescription: String?{
            switch self{
            case .emptyFields:
                return "Please fill in all fields"
            }
        }
    }
}
