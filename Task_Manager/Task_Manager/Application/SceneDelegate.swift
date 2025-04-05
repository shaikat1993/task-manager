//
//  SceneDelegate.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    /// Strong reference to app coordinator
    /// Must be retained to keep coordinator hierarchy alive
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else {return}
        
        // Create and configure main window
        let window = UIWindow(windowScene: windowScene)
        // Create root navigation controller
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true,
                                                    animated: false)
        
        // Create and start app coordinator
        let coordinator = AppCoordinator(window: window,
                                         navigationController: navigationController)
        // Store references
        self.window = window
        self.appCoordinator = coordinator
        
        // Begin app flow
        coordinator.start()
    }
}

