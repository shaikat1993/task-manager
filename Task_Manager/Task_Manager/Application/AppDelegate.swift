//
//  AppDelegate.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        setupAppearance()
        return true
    }
    
    private func setupWindow() {
        // Create window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Create root navigation controller
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        // Create and start app coordinator
        let coordinator = AppCoordinator(window: window!,
                                       navigationController: navigationController)
        
        // Store reference to coordinator
        self.appCoordinator = coordinator
        
        // Begin app flow
        coordinator.start()
        
        // Make window visible
        window?.makeKeyAndVisible()
    }
    
    private func setupAppearance() {
        //set global UI appearance here
        UINavigationBar.appearance().tintColor = .systemBlue
        UINavigationBar.appearance().prefersLargeTitles = true
    }
}
