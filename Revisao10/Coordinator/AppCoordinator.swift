//
//  AppCoordinator.swift
//  Revisao10
//
//  Created by ednardo alves on 28/09/25.
//

import Foundation
import UIKit

final class AppCoordinator {
    var window: UIWindow
    var navigation: UINavigationController!
    
    var homeCoordinator: HomeCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.navigation = UINavigationController()
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    func start() {
        showHome()
    }
    
    func showHome() {
        navigation.setViewControllers([], animated: false)
        
        let homeCoordinator = HomeCoordinator(navigation: navigation)
        homeCoordinator.appCoordinator = self
        self.homeCoordinator = homeCoordinator
        homeCoordinator.start()
    }
}
