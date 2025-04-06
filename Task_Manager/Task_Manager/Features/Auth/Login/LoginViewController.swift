//
//  LoginViewController.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 6/4/25.
//

import UIKit
import Combine

class LoginViewController: BaseViewController<LoginViewModel> {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: GradientButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupKeyboardHandling()
    }
    
    private func setupUI() {
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    
    private func setupBindings() {
        // Text field bindings
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        
        // Error label bindings
        viewModel.$emailError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.emailErrorLabel.text = error
                self?.emailErrorLabel.isHidden = (error == nil)
            }
            .store(in: &cancellables)
        
        viewModel.$passwordError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.passwordErrorLabel.text = error
                self?.passwordErrorLabel.isHidden = (error == nil)
            }
            .store(in: &cancellables)
        
        // Login button state binding
        viewModel.$canLogin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] canLogin in
                self?.loginButton.isEnabled = canLogin
            }
            .store(in: &cancellables)
        
        // Loading state binding
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    PPHUD.show()
                    self?.loginButton.setTitle("", for: .normal)
                } else {
                    PPHUD.dismiss()
                    self?.loginButton.setTitle("Login", for: .normal)
                }
                self?.loginButton.isEnabled = !isLoading
            }
            .store(in: &cancellables)
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillShow),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillHide),
                                             name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func emailChanged() {
        viewModel.email = emailTextField.text ?? ""
    }
    
    @objc private func passwordChanged() {
        viewModel.password = passwordTextField.text ?? ""
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        
        let keyboardHeight = keyboardFrame.height - 200
        
        // Animate the view up when keyboard shows
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        
        // Animate the view back down when keyboard hides
        UIView.animate(withDuration: duration) {
            self.view.transform = .identity
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        dismissKeyboard()
        viewModel.login() // No need to pass email and password anymore
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        dismissKeyboard()
        viewModel.showRegistration()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
