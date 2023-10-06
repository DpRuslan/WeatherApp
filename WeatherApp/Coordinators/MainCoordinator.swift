//
//  MainCoordinator.swift
//

import Foundation
import UIKit.UINavigationController

final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parent: Coordinator?
    var navigationController: UINavigationController?
    
    func start() {
        let vc = MainViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

