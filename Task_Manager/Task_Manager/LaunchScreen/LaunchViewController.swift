//
//  LaunchViewController.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import UIKit
import Lottie
import Combine

class LaunchViewController: UIViewController {
    // MARK: - UI Components
    @IBOutlet weak var animationView: LottieAnimationView!
    
    // MARK: - Properties
    var viewModel: LaunchViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
        // Do any additional setup after loading the view.
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    func setupAnimation(){
        guard let jsonPath = Bundle.main.path(forResource: "launch", ofType: "json") else {
            //print("❌ Animation file not found at path: \(Bundle.main.bundlePath)")
            return
        }
        
        // Debug print for JSON path
        // print("✅ Found JSON at path: \(jsonPath)")
        
        let animation = LottieAnimation.filepath(jsonPath)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
    }
    
    func startAnimation() {
        guard let animationView = animationView else {
            print("❌ Animation view is nil")
            return
        }
        animationView.play { [weak self] completed in
            if completed {
                self?.performZoomAnimation()
            }
        }
    }
    
    func bind() {
        viewModel.$error
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleError(error)
            }.store(in: &cancellables)
        
    }
    
    func performZoomAnimation() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseIn) { [weak self] in
            self?.animationView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self?.animationView.alpha = 0
        } completion: { [weak self] _ in
            self?.viewModel.animationDidCompleted()
        }
    }
    
    private func handleError(_ error: Error) {
        // Handle error presentation
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
