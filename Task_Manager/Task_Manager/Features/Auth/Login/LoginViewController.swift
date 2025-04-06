//
//  LoginViewController.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 6/4/25.
//

import UIKit
import Combine

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var viewModel: LoginViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
    }
    
    func bind() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] isLoading in
                if isLoading {
                    self?.loginButton.isEnabled = false
                } else {
                    self?.loginButton.isEnabled = true
                }
            }.store(in: &cancellables)
        
        viewModel.$error
            .compactMap({$0})
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] error in
                self?.showError(error)
            }.store(in: &cancellables)
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        present(alert, animated: true)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        viewModel.login(email: emailTextField.text ?? "",
                        password: passwordTextField.text ?? "")
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        viewModel.showRegistration()
    }
    
    
}
