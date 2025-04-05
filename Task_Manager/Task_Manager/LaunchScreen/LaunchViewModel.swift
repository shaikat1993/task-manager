//
//  LaunchViewModel.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import Foundation
import Combine

class LaunchViewModel {
    // MARK: - Published Properties
    @Published private(set) var isAnimationCompleted = false
    @Published private(set) var error: Error?
    
    private weak var coordinator: LaunchCoordinatorProtocol?
    
    init(coordinator: LaunchCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
    }
    
    func animationDidCompleted() {
        isAnimationCompleted = true
        coordinator?.launchDidCompleted()
    }
}
