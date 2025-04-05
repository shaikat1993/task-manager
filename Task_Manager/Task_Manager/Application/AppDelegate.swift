//
//  AppDelegate.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupAppearance()
        return true
    }
    
    func setupAppearance(){
        //set global UI appearance here
        UINavigationBar.appearance().tintColor = .systemBlue
        UINavigationBar.appearance().prefersLargeTitles = true
    }
}

