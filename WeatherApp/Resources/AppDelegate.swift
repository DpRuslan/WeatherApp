//
//  AppDelegate.swift
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var coreDataStack = CoreDataStack(modelName: "WeatherApp")
    var window: UIWindow?
    var navVC: UINavigationController?
    var coordinator: MainCoordinator?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.main.bounds)
        navVC = UINavigationController()
        coordinator = MainCoordinator()
        
        window?.rootViewController = navVC
        coordinator?.navigationController = navVC
        window?.makeKeyAndVisible()
        
        coordinator?.start()
        
        return true
    }
}

