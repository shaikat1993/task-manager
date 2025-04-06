//
//  RegistrationViewController.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 6/4/25.
//

import UIKit
import Combine

class RegistrationViewController: BaseViewController<RegistrationViewModel> {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    
    @IBOutlet weak var createAccountButton: GradientButton!
    @IBOutlet weak var loginButton: GradientButton!
    
    private var cancellables = Set<AnyCancellable>()
    private var keyboardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupKeyboardHandling()
    }

    private func setupBindings(){
        nameTextfield.addTarget(self,
                                action: #selector(nameChanged),
                                for: .editingChanged)
        emailTextfield.addTarget(self,
                                action: #selector(emailChanged),
                                for: .editingChanged)
        passwordTextfield.addTarget(self,
                                    action: #selector(passwordChanged),
                                    for: .editingChanged)
        confirmPasswordTextfield.addTarget(self,
                                            action: #selector(confirmPasswordChanged),
                                            for: .editingChanged)
        
        // View model bindings
        viewModel.$nameError
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] error in
            self?.nameErrorLabel.text = error
                self?.nameErrorLabel.isHidden = (error == nil)
            }.store(in: &cancellables)
        
        viewModel.$emailError
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] error in
            self?.emailErrorLabel.text = error
                self?.emailErrorLabel.isHidden = (error == nil)
        }.store(in: &cancellables)
        
        viewModel.$passwordError
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] error in
            self?.passwordErrorLabel.text = error
                self?.passwordErrorLabel.isHidden = (error == nil)
        }.store(in: &cancellables)
        
        viewModel.$confirmPasswordError
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] error in
            self?.confirmPasswordErrorLabel.text = error
                self?.confirmPasswordErrorLabel.isHidden = (error == nil)
        }.store(in: &cancellables)
        
        
        viewModel.$canRegister
            .receive(on: DispatchQueue.main)
            .sink { [weak self] canRegister in
                self?.createAccountButton.isEnabled = canRegister
            }.store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    // start loader
                    PPHUD.show()
                    self?.createAccountButton.setTitle("", for: .normal)
                } else {
                    // stop loader
                    PPHUD.dismiss()
                    self?.createAccountButton.setTitle("Create Account", for: .normal)
                }
                self?.createAccountButton.isEnabled = !isLoading
            }.store(in: &cancellables)
    }
    
    private func setupKeyboardHandling(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func nameChanged() {
        viewModel.name = nameTextfield.text ?? ""
    }
    
    @objc private func emailChanged() {
        viewModel.email = emailTextfield.text ?? ""
    }
    
    @objc private func passwordChanged() {
        viewModel.password = passwordTextfield.text ?? ""
    }
    
    @objc private func confirmPasswordChanged() {
        viewModel.confirmPassword = confirmPasswordTextfield.text ?? ""
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect 
        else {return}
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight + 50
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        
        if let activeTextField = [nameTextfield,
                                  emailTextfield,
                                  passwordTextfield,
                                  confirmPasswordTextfield]
            .first(where: { $0.isFirstResponder}){
            let activeRect = activeTextField.convert(activeTextField.bounds,
                                                     to: scrollView)
            // Add some padding to ensure the field is not right at the keyboard
            let visibleRect = activeRect.insetBy(dx: 0,
                                                 dy: -50)
            scrollView.scrollRectToVisible(visibleRect,
                                           animated: true)
        }
    }
    
    @objc  private func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc  private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        viewModel.register()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        viewModel.navigateBackToLogin()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
