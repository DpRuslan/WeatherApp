//
//  Coordinator.swift
//

import Foundation
import UIKit.UINavigationController

// MARK: Navigation Flow by Coordinators

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    
    var parent: Coordinator? { get }
    func start()
    
    func childDidFinish(childCoordinator: Coordinator)
}

extension Coordinator {
    func childDidFinish(childCoordinator: Coordinator) {
        if let firstIndex = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: firstIndex)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension Coordinator {
    var parent: Coordinator? {
        return nil
    }
}
