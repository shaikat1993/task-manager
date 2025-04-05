//
//  BaseControllerProtocol.swift
//  Task_Manager
//
//  Created by Md Sadidur Rahman on 5/4/25.
//

import Foundation

protocol BaseControllerProtocol: AnyObject {
    associatedtype CoordinatorType: CoordinatorProtocol
    var coordinator: CoordinatorType? { get set }
}
