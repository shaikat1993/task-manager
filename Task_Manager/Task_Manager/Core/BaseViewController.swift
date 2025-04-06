//
//  BaseViewController.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 6/4/25.
//

import UIKit

class BaseViewController<ViewModel>: UIViewController {
    var viewModel: ViewModel!
    
    class func instantiate(fromStoryboard storyboard: Storyboard,
                           viewModel: ViewModel) -> Self {
        let storyboard = UIStoryboard(name: storyboard.identifier,
                                      bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
        viewController.viewModel = viewModel
        return viewController
    }
}
